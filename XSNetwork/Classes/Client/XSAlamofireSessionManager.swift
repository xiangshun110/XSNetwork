//
//  XSAlamofireSessionManager.swift
//  XSNetwork
//
//  Created by XSNetwork on 2026/04/07.
//  A Swift/Alamofire bridge exposing @objc methods for use from Objective-C.
//

import Alamofire
import Foundation

/// Wraps an Alamofire `Session` and exposes an Objective-C–compatible interface
/// for starting, tracking, and cancelling network requests.
@objc class XSAlamofireSessionManager: NSObject {

    // MARK: - Singleton

    @objc static let shared = XSAlamofireSessionManager()

    // MARK: - Sessions

    /// Used for regular GET/POST/etc. requests.
    private let regularSession: Session

    /// Used for uploads and downloads (resource-timeout set to a large value so
    /// that large transfers do not time out; mirrors the original AF behaviour).
    private let transferSession: Session

    // MARK: - Request tracking

    private var requestTable: [NSNumber: Request] = [:]
    private var requestCounter: Int = 0
    private let lock = NSLock()

    // MARK: - Init

    private override init() {
        regularSession = Session(configuration: .default)

        let transferConfig = URLSessionConfiguration.default
        // 0 makes URLSession use the system default (7 days); effectively no timeout
        // for long-running uploads/downloads – matching the original AFNetworking setup.
        transferConfig.timeoutIntervalForResource = 604_800
        transferSession = Session(configuration: transferConfig)

        super.init()
    }

    // MARK: - Data Requests

    /// Start a data request (GET, POST, PUT, DELETE, upload, …).
    ///
    /// - Parameters:
    ///   - request:              The pre-built `URLRequest`.
    ///   - uploadProgressBlock:  Called on the main queue with upload progress.
    ///   - downloadProgressBlock: Called on the main queue with download progress.
    ///   - isUpload:             Pass `YES` to use the long-timeout transfer session.
    ///   - completion:           Called on the main queue when the request finishes.
    ///                           Arguments: `(response, responseObject, error)`.
    /// - Returns: An opaque request identifier that can be passed to `cancelRequest(withID:)`.
    @objc(startDataRequest:uploadProgress:downloadProgress:isUpload:completion:)
    func startDataRequest(_ request: URLRequest,
                          uploadProgress uploadProgressBlock: ((Progress) -> Void)?,
                          downloadProgress downloadProgressBlock: ((Progress) -> Void)?,
                          isUpload: Bool,
                          completion: @escaping (URLResponse?, Any?, Error?) -> Void) -> NSNumber {
        let requestID = generateNextID()
        let session = isUpload ? transferSession : regularSession

        let dataRequest = session.request(request)
            .uploadProgress { progress in
                uploadProgressBlock?(progress)
            }
            .downloadProgress { progress in
                downloadProgressBlock?(progress)
            }
            .response { [weak self] dataResponse in
                self?.removeRequest(forID: requestID)

                // Do not deliver a callback for explicitly cancelled requests.
                if dataResponse.error?.isExplicitlyCancelled == true {
                    return
                }

                let (responseObject, error) = XSAlamofireSessionManager.parseResponse(
                    data: dataResponse.data,
                    response: dataResponse.response,
                    networkError: dataResponse.error
                )
                completion(dataResponse.response, responseObject, error)
            }

        storeRequest(dataRequest, forID: requestID)
        return requestID
    }

    // MARK: - Download Requests

    /// Start a file-download request.
    ///
    /// - Parameters:
    ///   - request:      The pre-built `URLRequest`.
    ///   - progressBlock: Called on the main queue with download progress.
    ///   - destination:  Block that receives `(temporaryURL, response)` and returns
    ///                   the desired destination `URL`.
    ///   - completion:   Called on the main queue when the download finishes.
    ///                   Arguments: `(response, fileURL, error)`.
    /// - Returns: An opaque request identifier that can be passed to `cancelRequest(withID:)`.
    @objc(startDownloadRequest:progress:destination:completion:)
    func startDownloadRequest(_ request: URLRequest,
                              progress progressBlock: ((Progress) -> Void)?,
                              destination: @escaping (URL, URLResponse) -> URL,
                              completion: @escaping (URLResponse?, URL?, Error?) -> Void) -> NSNumber {
        let requestID = generateNextID()

        let alDestination: DownloadRequest.Destination = { tempURL, response in
            let destURL = destination(tempURL, response)
            return (destURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        let downloadRequest = transferSession.download(request, to: alDestination)
            .downloadProgress { progress in
                progressBlock?(progress)
            }
            .response { [weak self] downloadResponse in
                self?.removeRequest(forID: requestID)

                if downloadResponse.error?.isExplicitlyCancelled == true {
                    return
                }

                // Unwrap AFError to expose the underlying URLError / NSError to ObjC callers.
                let error: Error? = downloadResponse.error.map { afError in
                    afError.underlyingError ?? afError
                }
                completion(downloadResponse.response, downloadResponse.fileURL, error)
            }

        storeRequest(downloadRequest, forID: requestID)
        return requestID
    }

    // MARK: - Cancellation

    @objc(cancelRequestWithID:)
    func cancelRequest(withID requestID: NSNumber) {
        lock.lock()
        let request = requestTable.removeValue(forKey: requestID)
        lock.unlock()
        request?.cancel()
    }

    @objc(cancelRequestsWithIDs:)
    func cancelRequests(withIDs requestIDList: [NSNumber]) {
        lock.lock()
        for rid in requestIDList {
            requestTable.removeValue(forKey: rid)?.cancel()
        }
        lock.unlock()
    }

    // MARK: - Private Helpers

    private func generateNextID() -> NSNumber {
        lock.lock()
        defer { lock.unlock() }
        requestCounter += 1
        return NSNumber(value: requestCounter)
    }

    private func storeRequest(_ request: Request, forID requestID: NSNumber) {
        lock.lock()
        requestTable[requestID] = request
        lock.unlock()
    }

    private func removeRequest(forID requestID: NSNumber) {
        lock.lock()
        requestTable.removeValue(forKey: requestID)
        lock.unlock()
    }

    // MARK: - Response Parsing

    private static let acceptableStatusCodes = 200...299
    private static let acceptableContentTypes: Set<String> = [
        "application/json", "text/json", "text/javascript", "text/plain", "text/html"
    ]

    /// Validates the HTTP response and deserialises the JSON body.
    ///
    /// Mirrors the logic that was previously implemented in `XSCustomResponseSerializer`
    /// (which was plugged into `AFHTTPSessionManager.responseSerializer`).
    private static func parseResponse(data: Data?,
                                      response: HTTPURLResponse?,
                                      networkError: AFError?) -> (Any?, Error?) {
        // Propagate network-level errors (no connection, timeout, …) as-is,
        // unwrapping AFError to give callers a plain NSError / URLError.
        if let afError = networkError {
            return (nil, afError.underlyingError ?? afError)
        }

        if let httpResponse = response {
            // Validate HTTP status code
            if !acceptableStatusCodes.contains(httpResponse.statusCode) {
                let description = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                let userInfo: [String: Any] = [NSLocalizedDescriptionKey: description]
                return (nil, NSError(domain: NSURLErrorDomain,
                                     code: httpResponse.statusCode,
                                     userInfo: userInfo))
            }

            // Validate Content-Type
            if let mimeType = httpResponse.mimeType,
               !acceptableContentTypes.contains(mimeType) {
                let description = "Request failed: unacceptable content-type: \(mimeType)"
                let userInfo: [String: Any] = [NSLocalizedDescriptionKey: description]
                return (nil, NSError(domain: "com.xsnetwork.error.serialization.response",
                                     code: NSURLErrorCannotDecodeContentData,
                                     userInfo: userInfo))
            }
        }

        guard let data = data, !data.isEmpty else {
            return (nil, nil)
        }

        // Treat a single ASCII space (Rails `head :ok` workaround) as empty
        if data.count == 1, data[0] == 0x20 {
            return (nil, nil)
        }

        do {
            let obj = try JSONSerialization.jsonObject(with: data)
            return (obj, nil)
        } catch {
            return (nil, error)
        }
    }
}
