//  XSCustomResponseSerializer.swift
//  XSNetwork
import Foundation

@objcMembers
@objc public class XSCustomResponseSerializer: NSObject, NSCopying {
    public var readingOptions: JSONSerialization.ReadingOptions = []
    public var removesKeysWithNullValues: Bool = false
    public var acceptableStatusCodes: IndexSet = IndexSet(integersIn: 200..<300)
    public var acceptableContentTypes: Set<String> = ["application/json","text/json","text/javascript","text/plain","text/html"]

    public required override init() { super.init() }

    @objc public static func serializer() -> Self { return serializerWithReadingOptions([]) }

    @objc public static func serializerWithReadingOptions(_ options: JSONSerialization.ReadingOptions) -> Self {
        let s = self.init(); s.readingOptions = options; return s
    }

    @objc public func responseObject(for response: URLResponse?, data: Data?, error: AutoreleasingUnsafeMutablePointer<NSError?>?) -> Any? {
        if let http = response as? HTTPURLResponse, !acceptableStatusCodes.contains(http.statusCode) {
            error?.pointee = NSError(domain: NSURLErrorDomain, code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: http.statusCode)])
            return nil
        }
        guard let d = data, !d.isEmpty, !(d.count == 1 && d[0] == 0x20) else { return nil }
        do {
            var obj = try JSONSerialization.jsonObject(with: d, options: readingOptions)
            if removesKeysWithNullValues { obj = removeNulls(obj) }
            return obj
        } catch let e as NSError { error?.pointee = e; return nil }
    }

    private func removeNulls(_ obj: Any) -> Any {
        if let arr = obj as? [Any] { return arr.map { removeNulls($0) } }
        if let dict = obj as? [AnyHashable: Any] {
            var r = dict
            for k in dict.keys {
                if dict[k] == nil || dict[k] is NSNull { r.removeValue(forKey: k) }
                else if let v = dict[k] { r[k] = removeNulls(v) }
            }
            return r
        }
        return obj
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let c = XSCustomResponseSerializer(); c.readingOptions = readingOptions
        c.removesKeysWithNullValues = removesKeysWithNullValues
        c.acceptableStatusCodes = acceptableStatusCodes; c.acceptableContentTypes = acceptableContentTypes
        return c
    }
}
