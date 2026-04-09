import Foundation
import XSNetwork

class ErrorHandler1: XSAPIResponseErrorHandler {
    override func errorHandler(requestDataModel: XSAPIBaseRequestDataModel,
                               responseURL: URLResponse?,
                               responseObject: Any?,
                               error: Error?) -> XSErrorHanderResult {
        let result = XSErrorHanderResult()
        if let error = error {
            result.error = error
            return result
        }
        if let dict = responseObject as? [AnyHashable: Any] {
            let errorCode = (dict["code"] as? Int) ?? 0
            if errorCode == 0 { return result }
            var message = "请求失败"
            if let msg = dict["message"] as? String { message = msg }
            result.error = NSError(domain: NSCocoaErrorDomain, code: errorCode, userInfo: [
                NSLocalizedDescriptionKey: message,
                "data": responseObject ?? [:],
                "URL": responseURL?.url?.absoluteString ?? ""
            ])
        } else {
            result.error = error
        }
        return result
    }
}
