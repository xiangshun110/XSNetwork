//  XSAppContext.swift
//  XSNetwork

import Foundation
import SystemConfiguration

#if canImport(UIKit)
import UIKit
#endif

private func xsIsNetworkReachable() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    guard let ref = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
        }
    }) else { return false }
    var flags: SCNetworkReachabilityFlags = []
    guard SCNetworkReachabilityGetFlags(ref, &flags) else { return true }
    return flags.contains(.reachable) && !flags.contains(.connectionRequired)
}

@objcMembers
@objc public class XSAppContext: NSObject {
    @objc public static let sharedInstance = XSAppContext()

    public var channelID: String = "App Store"
    public var appName: String = ""
    public var user_id: String?

    public var device_id: String = ""
    public var os_name: String = ""
    public var os_version: String = ""
    public var bundle_version: String = ""
    public var app_client_id: String = "1"
    public var device_model: String = ""
    public var device_name: String = ""

    public var qtime: String { String(Date().timeIntervalSince1970) }
    public var isReachable: Bool { xsIsNetworkReachable() }

    private override init() {
        super.init()
        appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
        bundle_version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
#if canImport(UIKit)
        os_name = UIDevice.current.systemName
        os_version = UIDevice.current.systemVersion
        device_name = UIDevice.current.name
        device_model = UIDevice.current.model
#else
        os_name = "macOS"
        let ver = ProcessInfo.processInfo.operatingSystemVersion
        os_version = "\(ver.majorVersion).\(ver.minorVersion).\(ver.patchVersion)"
#endif
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(logoutAction),
            name: NSNotification.Name("LogoutNotification"),
            object: nil
        )
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    @objc private func logoutAction() { user_id = nil }
}
