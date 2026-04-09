//  XSAPIClient.swift
//  XSNetwork
import Foundation

@objcMembers
@objc public class XSAPIClient: NSObject {
    private static let _shared = XSAPIClient()
    private override init() { super.init() }

    @objc public static func sharedInstance() -> XSAPIClient { return _shared }

    @objc public func callRequest(with requestModel: XSAPIBaseRequestDataModel) -> NSNumber {
        guard let request = XSAPIURLRequestGenerator.sharedInstance.generateWithRequestDataModel(requestModel) else {
            let err = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey: "Failed to build URLRequest"])
            requestModel.responseBlock?(nil, err)
            return NSNumber(value: -1)
        }

        if requestModel.requestType == .getDownload {
            return XSAlamofireSessionManager.shared.startDownloadRequest(
                request,
                progress: requestModel.downloadProgressBlock,
                destination: { _, response in
                    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let name = requestModel.fileName?.isEmpty == false ? requestModel.fileName! : (response.suggestedFilename ?? "download")
                    return docs.appendingPathComponent(name)
                },
                completion: { _, fileURL, error in requestModel.responseBlock?(fileURL, error) }
            )
        }

        let isUpload = requestModel.requestType == .postUpload
        return XSAlamofireSessionManager.shared.startDataRequest(
            request,
            uploadProgress: requestModel.uploadProgressBlock,
            downloadProgress: requestModel.downloadProgressBlock,
            isUpload: isUpload,
            completion: { [weak self] response, responseObject, error in
                guard self != nil else { return }
                let server = XSServerFactory.sharedInstance.serviceWithName(requestModel.serverName)
                if let handler = server.model.errHander {
                    let result = handler.errorHandler(requestDataModel: requestModel, responseURL: response, responseObject: responseObject, error: error)
                    if !result.blockResponse { requestModel.responseBlock?(responseObject, result.error) }
                } else {
                    requestModel.responseBlock?(responseObject, error)
                }
            }
        )
    }

    @objc public func cancelRequest(withRequestID requestID: NSNumber) {
        XSAlamofireSessionManager.shared.cancelRequest(withID: requestID)
    }

    @objc public func cancelRequests(withRequestIDList requestIDList: [NSNumber]) {
        XSAlamofireSessionManager.shared.cancelRequests(withIDs: requestIDList)
    }
}
