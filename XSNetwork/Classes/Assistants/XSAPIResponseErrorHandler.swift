//  XSAPIResponseErrorHandler.swift
//  XSNetwork

import Foundation

@objc open class XSAPIResponseErrorHandler: NSObject {

    @objc(errorHandlerWithRequestDataModel:responseURL:responseObject:error:)
    open func errorHandler(requestDataModel: XSAPIBaseRequestDataModel,
                           responseURL: URLResponse?,
                           responseObject: Any?,
                           error: Error?) -> XSErrorHanderResult {
        let result = XSErrorHanderResult()
        if let err = error {
            result.error = err
        }
        return result
    }
}
