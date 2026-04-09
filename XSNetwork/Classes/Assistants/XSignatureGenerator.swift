//  XSignatureGenerator.swift
//  XSNetwork

import Foundation
import CommonCrypto

@objcMembers
@objc public class XSignatureGenerator: NSObject {
    @objc public static func sign(_ dict: [AnyHashable: Any]) -> String {
        let sortedKeys = dict.keys.compactMap { $0 as? String }.sorted()
        var inputString = ""
        for (i, key) in sortedKeys.enumerated() {
            let value = dict[key as AnyHashable] ?? ""
            if i == 0 {
                inputString = "\(key)=\(value)"
            } else {
                inputString += "&\(key)=\(value)"
            }
        }
        return md5(inputString)
    }

    private static func md5(_ input: String) -> String {
        guard let data = input.data(using: .utf8) else { return "" }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes { ptr in
            _ = CC_MD5(ptr.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
