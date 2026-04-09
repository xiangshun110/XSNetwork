//  XSMainServer.swift
//  XSNetwork

import Foundation

private var releaseURL: String = ""
private var preReleaseURL: String = ""
private var devURL: String = ""

@objcMembers
@objc public class XSMainServer: XSBaseServers {
    @objc public static func setBaseURLWithRelease(_ release: String?, dev: String?, preRelease: String?) {
        releaseURL = release ?? ""
        preReleaseURL = preRelease ?? ""
        devURL = dev ?? ""
    }
}
