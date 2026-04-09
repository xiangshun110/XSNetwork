//  XSNetworkTools.swift
//  XSNetwork

import Foundation

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

@objc public protocol XSNetworkToolsProtocol: NSObjectProtocol {
    func serverName() -> String
}

@objcMembers
@objc open class XSNetworkTools: NSObject, XSNetworkToolsProtocol {

    private static let _sharedInstance = XSNetworkTools()

    @objc public static func singleInstance() -> XSNetworkTools {
        assert(self === XSNetworkTools.self, "子类请自行实现单例方法,或者自己new一个实例")
        return _sharedInstance
    }

    @objc public var server: XSBaseServers {
        return XSServerFactory.sharedInstance.serviceWithName(serverName())
    }

#if canImport(UIKit)
    private lazy var devEnvlabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.8
        label.textColor = .black
        label.font = .systemFont(ofSize: 11)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 100/255.0, green: 100/255.0, blue: 0, alpha: 0.5)
        label.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(netEnvChange(_:)),
                                               name: NSNotification.Name(NotiEnvChange), object: nil)
        return label
    }()
#else
    private lazy var devEnvlabel: NSTextField = {
        let field = NSTextField(labelWithString: "")
        field.alphaValue = 0.8
        field.textColor = .black
        field.font = .systemFont(ofSize: 11)
        field.alignment = .center
        field.backgroundColor = NSColor(red: 100/255.0, green: 100/255.0, blue: 0, alpha: 0.5)
        field.drawsBackground = true
        NotificationCenter.default.addObserver(self, selector: #selector(netEnvChange(_:)),
                                               name: NSNotification.Name(NotiEnvChange), object: nil)
        return field
    }()
#endif

    private weak var devEnvlabelContainer: XSPlatformView?

    @objc private func netEnvChange(_ noti: Notification?) {
        switch server.model.environmentType {
        case .release:
            devEnvlabel.isHidden = true
        case .develop:
            devEnvlabel.isHidden = false
#if canImport(UIKit)
            devEnvlabel.text = "dev"
#else
            devEnvlabel.stringValue = "dev"
#endif
        case .preRelease:
            devEnvlabel.isHidden = false
#if canImport(UIKit)
            devEnvlabel.text = "pre"
#else
            devEnvlabel.stringValue = "pre"
#endif
        case .custom:
            devEnvlabel.isHidden = false
#if canImport(UIKit)
            devEnvlabel.text = "cus"
#else
            devEnvlabel.stringValue = "cus"
#endif
        @unknown default:
            break
        }
    }

    @objc public func showEnvTagView(_ container: XSPlatformView) {
        devEnvlabelContainer = container
        container.addSubview(devEnvlabel)
#if canImport(UIKit)
        if #available(iOS 11.0, *) {
            devEnvlabel.frame = CGRect(x: container.safeAreaInsets.left,
                                       y: container.safeAreaInsets.top,
                                       width: 40, height: 16)
        } else {
            devEnvlabel.frame = CGRect(x: 0, y: 20, width: 40, height: 16)
        }
#else
        devEnvlabel.frame = CGRect(x: 0, y: container.bounds.height - 16, width: 40, height: 16)
#endif
        netEnvChange(nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(devEnvlabelToTop),
                                               object: nil)
        perform(#selector(devEnvlabelToTop), with: nil, afterDelay: 15.0)
    }

    @objc private func devEnvlabelToTop() {
        guard let container = devEnvlabelContainer else { return }
        if server.model.environmentType != .release {
            container.addSubview(devEnvlabel)
        }
        perform(#selector(devEnvlabelToTop), with: nil, afterDelay: 15.0)
    }

    // MARK: - Request Methods

    @objc @discardableResult
    public func request(_ control: NSObject,
                        param: [AnyHashable: Any]?,
                        path: String,
                        requestType: XSAPIRequestType,
                        loadingMsg: String?,
                        complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(control, serverName: serverName(), path: path,
                                        param: param, bodyData: nil, dataFilePath: nil,
                                        dataFileURL: nil, image: nil, dataName: nil,
                                        fileName: nil, requestType: requestType,
                                        alertType: .unknown, mimeType: nil, timeout: 0,
                                        loadingMsg: loadingMsg, complete: responseBlock,
                                        uploadProgressBlock: nil, downloadProgressBlock: nil,
                                        errorButtonSelectIndex: nil)
    }

    @objc @discardableResult
    public func getRequest(_ control: NSObject,
                           param: [AnyHashable: Any]?,
                           path: String,
                           loadingMsg: String?,
                           complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(control, serverName: serverName(), path: path,
                                        param: param, bodyData: nil, dataFilePath: nil,
                                        dataFileURL: nil, image: nil, dataName: nil,
                                        fileName: nil, requestType: .get,
                                        alertType: .unknown, mimeType: nil, timeout: 0,
                                        loadingMsg: loadingMsg, complete: responseBlock,
                                        uploadProgressBlock: nil, downloadProgressBlock: nil,
                                        errorButtonSelectIndex: nil)
    }

    @objc @discardableResult
    public func postRequest(_ control: NSObject,
                            param: [AnyHashable: Any]?,
                            path: String,
                            loadingMsg: String?,
                            complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(control, serverName: serverName(), path: path,
                                        param: param, bodyData: nil, dataFilePath: nil,
                                        dataFileURL: nil, image: nil, dataName: nil,
                                        fileName: nil, requestType: .post,
                                        alertType: .unknown, mimeType: nil, timeout: 0,
                                        loadingMsg: loadingMsg, complete: responseBlock,
                                        uploadProgressBlock: nil, downloadProgressBlock: nil,
                                        errorButtonSelectIndex: nil)
    }

    @objc @discardableResult
    public func postFormDataRequest(_ control: NSObject,
                                    param: [AnyHashable: Any]?,
                                    path: String,
                                    loadingMsg: String?,
                                    complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(control, serverName: serverName(), path: path,
                                        param: param, bodyData: nil, dataFilePath: nil,
                                        dataFileURL: nil, image: nil, dataName: nil,
                                        fileName: nil, requestType: .postFormData,
                                        alertType: .unknown, mimeType: nil, timeout: 0,
                                        loadingMsg: loadingMsg, complete: responseBlock,
                                        uploadProgressBlock: nil, downloadProgressBlock: nil,
                                        errorButtonSelectIndex: nil)
    }

    @objc @discardableResult
    public func request(_ control: NSObject,
                        bodyData: Data?,
                        param: [AnyHashable: Any]?,
                        path: String,
                        complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(control, serverName: serverName(), path: path,
                                        param: param, bodyData: bodyData, dataFilePath: nil,
                                        dataFileURL: nil, image: nil, dataName: nil,
                                        fileName: nil, requestType: .postUpload,
                                        alertType: .unknown, mimeType: nil, timeout: 0,
                                        loadingMsg: nil, complete: responseBlock,
                                        uploadProgressBlock: nil, downloadProgressBlock: nil,
                                        errorButtonSelectIndex: nil)
    }

    @objc @discardableResult
    public func request(_ control: NSObject,
                        param: [AnyHashable: Any]?,
                        path: String,
                        requestType: XSAPIRequestType,
                        timeout: TimeInterval,
                        complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(control, serverName: serverName(), path: path,
                                        param: param, bodyData: nil, dataFilePath: nil,
                                        dataFileURL: nil, image: nil, dataName: nil,
                                        fileName: nil, requestType: requestType,
                                        alertType: .unknown, mimeType: nil, timeout: timeout,
                                        loadingMsg: nil, complete: responseBlock,
                                        uploadProgressBlock: nil, downloadProgressBlock: nil,
                                        errorButtonSelectIndex: nil)
    }

    @objc @discardableResult
    public func uploadFile(_ control: NSObject,
                           param: [AnyHashable: Any]?,
                           path: String,
                           fileURL: URL?,
                           filePath: String?,
                           fileKey: String?,
                           fileName: String?,
                           requestType: XSAPIRequestType,
                           progress: ProgressBlock?,
                           complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(control, serverName: serverName(), path: path,
                                        param: param, bodyData: nil, dataFilePath: filePath,
                                        dataFileURL: fileURL, image: nil, dataName: fileKey,
                                        fileName: fileName, requestType: requestType,
                                        alertType: .unknown, mimeType: nil, timeout: 0,
                                        loadingMsg: nil, complete: responseBlock,
                                        uploadProgressBlock: progress, downloadProgressBlock: nil,
                                        errorButtonSelectIndex: nil)
    }

    @objc @discardableResult
    public func downloadFile(_ control: NSObject,
                             url: String,
                             fileName: String?,
                             progress: ProgressBlock?,
                             complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(control, serverName: serverName(), path: url,
                                        param: nil, bodyData: nil, dataFilePath: nil,
                                        dataFileURL: nil, image: nil, dataName: nil,
                                        fileName: fileName, requestType: .getDownload,
                                        alertType: .unknown, mimeType: nil, timeout: 0,
                                        loadingMsg: nil, complete: responseBlock,
                                        uploadProgressBlock: nil, downloadProgressBlock: progress,
                                        errorButtonSelectIndex: nil)
    }

    // MARK: - Native Requests (URLSession, no framework)

    @objc public static func requestGET(_ relativePath: String,
                                        params: [AnyHashable: Any]?,
                                        successBlock: HSResponseSuccessBlock?,
                                        failBlock: HSResponseFailBlock?) {
        requestHTTPMethod("GET", relativePath: relativePath, params: params,
                          successBlock: successBlock, failBlock: failBlock)
    }

    @objc public static func requestPOST(_ relativePath: String,
                                         params: [AnyHashable: Any]?,
                                         successBlock: HSResponseSuccessBlock?,
                                         failBlock: HSResponseFailBlock?) {
        requestHTTPMethod("POST", relativePath: relativePath, params: params,
                          successBlock: successBlock, failBlock: failBlock)
    }

    @objc public static func requestJsonPost(_ relativePath: String,
                                             params: [AnyHashable: Any]?,
                                             successBlock: HSResponseSuccessBlock?,
                                             failBlock: HSResponseFailBlock?) {
        guard let url = URL(string: relativePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 5
        if let params = params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params,
                                                          options: .prettyPrinted)
        }
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { failBlock?(error); return }
            guard let data = data else { failBlock?(nil); return }
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: [])
                successBlock?(obj as? [AnyHashable: Any])
            } catch {
                failBlock?(error)
            }
        }.resume()
    }

    private static func requestHTTPMethod(_ method: String,
                                          relativePath: String,
                                          params: [AnyHashable: Any]?,
                                          successBlock: HSResponseSuccessBlock?,
                                          failBlock: HSResponseFailBlock?) {
        guard let url = URL(string: relativePath) else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        request.httpMethod = method
        if let params = params {
            let keys = Array(params.keys)
            var parts: [String] = []
            for key in keys {
                parts.append("\(key)=\(params[key] ?? "")")
            }
            request.httpBody = parts.joined(separator: "&").data(using: .utf8)
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { failBlock?(error); return }
            guard let data = data else { failBlock?(nil); return }
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: [])
                successBlock?(obj as? [AnyHashable: Any])
            } catch {
                failBlock?(error)
            }
        }.resume()
    }

    // MARK: - XSNetworkToolsProtocol

    open func serverName() -> String {
        return DefaultServerName
    }
}
