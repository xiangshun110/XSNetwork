//  XSBaseDataEngine.swift
//  XSNetwork

import Foundation

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

@objcMembers
@objc public class XSBaseDataEngine: NSObject {

    private var requestID: NSNumber = NSNumber(value: -1)

    deinit {
        cancelRequest()
    }

    @objc public func cancelRequest() {
        XSAPIClient.sharedInstance().cancelRequest(withRequestID: requestID)
    }

    /// Creates a request using a platform image (converted to PNG data internally).
    @objc public static func control(_ control: NSObject,
                                     serverName: String,
                                     path: String,
                                     param: [AnyHashable: Any]?,
                                     bodyData: Data?,
                                     dataFilePath: String?,
                                     dataFileURL: URL?,
                                     image: XSPlatformImage?,
                                     dataName: String?,
                                     fileName: String?,
                                     requestType: XSAPIRequestType,
                                     alertType: XSAPIAlertType,
                                     mimeType: String?,
                                     timeout: TimeInterval,
                                     loadingMsg: String?,
                                     complete responseBlock: CompletionDataBlock?,
                                     uploadProgressBlock: ProgressBlock?,
                                     downloadProgressBlock: ProgressBlock?,
                                     errorButtonSelectIndex: ErrorAlertSelectIndexBlock?) -> XSBaseDataEngine {
        var imageData: Data?
        if let image = image {
#if canImport(UIKit)
            imageData = image.pngData()
#else
            if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
                imageData = bitmapRep.representation(using: .png, properties: [:])
            }
#endif
        }
        return self.control(control, serverName: serverName, path: path, param: param,
                            bodyData: bodyData, dataFilePath: dataFilePath,
                            dataFileURL: dataFileURL, imageData: imageData,
                            dataName: dataName, fileName: fileName, requestType: requestType,
                            alertType: alertType, mimeType: mimeType, timeout: timeout,
                            loadingMsg: loadingMsg, complete: responseBlock,
                            uploadProgressBlock: uploadProgressBlock,
                            downloadProgressBlock: downloadProgressBlock,
                            errorButtonSelectIndex: errorButtonSelectIndex)
    }

    /// Creates a request using raw image data.
    @objc public static func control(_ control: NSObject,
                                     serverName: String,
                                     path: String,
                                     param: [AnyHashable: Any]?,
                                     bodyData: Data?,
                                     dataFilePath: String?,
                                     dataFileURL: URL?,
                                     imageData: Data?,
                                     dataName: String?,
                                     fileName: String?,
                                     requestType: XSAPIRequestType,
                                     alertType: XSAPIAlertType,
                                     mimeType: String?,
                                     timeout: TimeInterval,
                                     loadingMsg: String?,
                                     complete responseBlock: CompletionDataBlock?,
                                     uploadProgressBlock: ProgressBlock?,
                                     downloadProgressBlock: ProgressBlock?,
                                     errorButtonSelectIndex: ErrorAlertSelectIndexBlock?) -> XSBaseDataEngine {
        weak var weakControl: NSObject? = control
        let engine = XSBaseDataEngine()
        let server = XSServerFactory.sharedInstance.serviceWithName(serverName)

        var hud: XSProgressHUD?
        if let msg = loadingMsg {
            var view: XSPlatformView?
#if canImport(UIKit)
            if let vc = control as? UIViewController {
                view = vc.view
            } else if let v = control as? UIView {
                view = v
            }
#else
            if let vc = control as? NSViewController {
                view = vc.view
            } else if let v = control as? NSView {
                view = v
            }
#endif
            if let v = view {
                hud = XSProgressHUD.showLoading(in: v, message: msg)
            }
        }

        let dataModel = XSAPIBaseRequestDataModel()
        dataModel.serverName = serverName
        dataModel.apiMethodPath = path
        dataModel.parameters = param
        dataModel.bodyData = bodyData
        dataModel.dataFilePath = dataFilePath
        dataModel.dataFileURL = dataFileURL
        dataModel.imageData = imageData
        dataModel.dataName = dataName
        dataModel.fileName = fileName
        dataModel.mimeType = mimeType
        dataModel.requestType = requestType
        dataModel.uploadProgressBlock = uploadProgressBlock
        dataModel.downloadProgressBlock = downloadProgressBlock
        dataModel.needBaseURL = !path.hasPrefix("http")

        if timeout > 0 {
            dataModel.requestTimeout = timeout
        }

        dataModel.responseBlock = { [weak engine] data, error in
            hud?.hide(animated: true)

            if let responseBlock = responseBlock {
                if let error = error {
                    var emsg = error.localizedDescription
                    let errKey = server.model.errMessageKey
                    if let dict = data as? [AnyHashable: Any],
                       let msg = dict[errKey] as? String {
                        emsg = msg
                    }

                    var aType = alertType
                    if aType == .unknown {
                        aType = server.model.errorAlerType
                    }

                    if aType == .toast {
                        var toastView: XSPlatformView? = server.model.toastView
                        if toastView == nil {
#if canImport(UIKit)
                            if let vc = weakControl as? UIViewController {
                                toastView = vc.view
                            }
#else
                            if let vc = weakControl as? NSViewController {
                                toastView = vc.view
                            }
#endif
                        }
                        if let tv = toastView {
                            XSProgressHUD.showToast(emsg, in: tv, afterDelay: 2.0)
                        }
                    }
                }
                responseBlock(data, error)
            }

            if let eng = engine {
                weakControl?.networkingAutoCancelRequests.removeEngine(withRequestID: eng.requestID)
            }
        }

        engine.requestID = XSAPIClient.sharedInstance().callRequest(with: dataModel)
        control.networkingAutoCancelRequests.setEngine(engine, requestID: engine.requestID)

        return engine
    }
}
