//  XSServerFactory.swift
//  XSNetwork

import Foundation

@objcMembers
@objc public class XSServerFactory: NSObject {
    @objc public static let sharedInstance = XSServerFactory()
    private var serviceStorage: [String: XSBaseServers] = [:]
    private let lock = NSLock()

    private override init() { super.init() }

    @objc public static func changeEnvironmentType(_ environmentType: XSEnvType) {
        sharedInstance.serviceWithName(DefaultServerName).model.environmentType = environmentType
    }

    @objc public func serviceWithType(_ type: XSServiceType) -> XSBaseServers {
        return serviceWithName(DefaultServerName)
    }

    @objc public func serviceWithName(_ serverName: String) -> XSBaseServers {
        lock.lock()
        defer { lock.unlock() }
        if let existing = serviceStorage[serverName] {
            return existing
        }
        let newService = XSBaseServers(serverName: serverName)
        serviceStorage[serverName] = newService
        return newService
    }
}
