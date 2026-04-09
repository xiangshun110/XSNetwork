//  XSBaseServers.swift
//  XSNetwork

import Foundation

@objcMembers
@objc public class XSBaseServers: NSObject {
    @objc public private(set) var model: XSServerModel

    @objc public init(serverName: String) {
        model = XSServerModel(serverName: serverName)
        super.init()
    }
}
