//  XSServerConfig.swift
//  XSNetwork

import Foundation

#if canImport(UIKit)
import UIKit
public typealias XSPlatformView = UIView
public typealias XSPlatformViewController = UIViewController
public typealias XSPlatformImage = UIImage
#else
import AppKit
public typealias XSPlatformView = NSView
public typealias XSPlatformViewController = NSViewController
public typealias XSPlatformImage = NSImage
#endif

/// Default server name
public let DefaultServerName: String = "defaultName"
/// Default request timeout (seconds)
public let DefaultTimeout: TimeInterval = 25.0
/// Notification posted when environment type changes
public let NotiEnvChange: String = "environmentTypeChange"

/// Legacy service type (deprecated – use serverName instead)
@objc public enum XSServiceType: Int {
    case main = 0
}

/// HTTP request method
@objc public enum XSAPIRequestType: Int {
    case get = 0
    case post
    case put
    case delete
    case update
    case postUpload
    case postFormData
    case getDownload
}

/// Error alert presentation style
@objc public enum XSAPIAlertType: Int {
    case unknown = 0
    case none
    case toast
}

/// Server environment type
@objc public enum XSEnvType: Int {
    case develop = 0
    case preRelease
    case release
    case custom
}

// MARK: - Type Aliases

public typealias ProgressBlock = (Progress) -> Void
public typealias CompletionDataBlock = (Any?, Error?) -> Void
public typealias ErrorAlertSelectIndexBlock = (UInt) -> Void
public typealias HSResponseSuccessBlock = ([AnyHashable: Any]?) -> Void
public typealias HSResponseFailBlock = (Error?) -> Void
