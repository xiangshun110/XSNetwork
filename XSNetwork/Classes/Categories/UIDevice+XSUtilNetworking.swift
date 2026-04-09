//  UIDevice+XSUtilNetworking.swift
//  XSNetwork

#if canImport(UIKit)
import UIKit
import Darwin

extension UIDevice {
    @objc public func platform() -> String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }

    @objc public func correspondVersion() -> String {
        let p = platform()
        switch p {
        case "i386", "x86_64":  return "Simulator"
        case "iPhone1,1":       return "iPhone 2G (A1203)"
        case "iPhone7,2":       return "iPhone 6 (A1549/A1586)"
        case "iPhone8,1":       return "iPhone 6S"
        case "iPhone8,2":       return "iPhone 6S Plus"
        default:                return p
        }
    }
}
#endif
