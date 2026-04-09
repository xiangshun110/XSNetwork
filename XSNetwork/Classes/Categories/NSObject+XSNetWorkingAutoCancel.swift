//  NSObject+XSNetWorkingAutoCancel.swift
//  XSNetwork

import Foundation
import ObjectiveC

private var kNetworkingAutoCancelRequestsKey: UInt8 = 0

extension NSObject {
    @objc public var networkingAutoCancelRequests: XSNetworkingAutoCancelRequests {
        if let existing = objc_getAssociatedObject(self, &kNetworkingAutoCancelRequestsKey) as? XSNetworkingAutoCancelRequests {
            return existing
        }
        let requests = XSNetworkingAutoCancelRequests()
        objc_setAssociatedObject(self, &kNetworkingAutoCancelRequestsKey, requests, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return requests
    }
}
