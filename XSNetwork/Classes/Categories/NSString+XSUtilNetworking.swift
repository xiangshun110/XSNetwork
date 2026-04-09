//  NSString+XSUtilNetworking.swift
//  XSNetwork

import Foundation

extension NSString {
    @objc(isEmptyString:)
    public static func isEmptyString(_ string: String?) -> Bool {
        guard let s = string else { return true }
        return s.isEmpty
    }
}
