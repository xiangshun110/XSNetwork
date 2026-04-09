//  XSNetworkingAutoCancelRequests.swift
//  XSNetwork

import Foundation

@objcMembers
@objc public class XSNetworkingAutoCancelRequests: NSObject {
    private var requestEngines: [NSNumber: XSBaseDataEngine] = [:]

    deinit {
        requestEngines.values.forEach { $0.cancelRequest() }
        requestEngines.removeAll()
    }

    @objc public func setEngine(_ engine: XSBaseDataEngine, requestID: NSNumber) {
        guard !requestID.isEqual(to: NSNumber(value: -1)) else { return }
        requestEngines[requestID] = engine
    }

    @objc public func removeEngine(withRequestID requestID: NSNumber) {
        requestEngines.removeValue(forKey: requestID)
    }
}
