//  XSErrorHanderResult.swift
//  XSNetwork

import Foundation

@objcMembers
@objc public class XSErrorHanderResult: NSObject {
    /// The error (nil means success)
    public var error: Error?
    /// When true, the response callback will NOT be called
    public var blockResponse: Bool = false
}
