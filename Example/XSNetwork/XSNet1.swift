import Foundation
import CommonCrypto
import XSNetwork

class XSNet1: XSNetworkTools {
    private static let _instance: XSNet1 = {
        let instance = XSNet1()
        instance.config()
        return instance
    }()

    @objc static func share() -> XSNet1 {
        return _instance
    }

    override func serverName() -> String {
        return "XSNet1"
    }

    private func config() {
        server.model.releaseApiBaseUrl = "http://cslbehring-meeting.edr120.com/2"
        server.model.developApiBaseUrl = "http://jtbl.uatwechat.com/12"

        server.model.errHander = ErrorHandler1()

        server.model.errMessageKey = "message"
        server.model.errorAlerType = .toast

        server.model.headersWithRequestParamsBlock = { [weak self] params in
            return self?.dynamicParamsHeader(params)
        }
    }

    func dynamicParams() -> [AnyHashable: Any] {
        return ["test_uuid": UUID().uuidString]
    }

    func dynamicParamsHeader(_ params: [AnyHashable: Any]) -> [String: String] {
        var dic = params
        dic.removeValue(forKey: "loginuserinfo")

        var header: [String: String] = [:]
        let timestamp = XSNet1.getTimeStamp()
        let nonce = XSNet1.getNonce()

        var sign = ""
        let token = "468e72ac-a8dd-493c-a26d-d3b265109422"
        let commonReqId = "1CD956826E0AF4F9"

        if !dic.isEmpty {
            sign = "\(timestamp)\(nonce)\(commonReqId)\(token)\(XSNet1.dataTOjsonString(dic) ?? "")"
        } else {
            sign = "\(timestamp)\(nonce)\(commonReqId)\(token)"
        }
        header["token"] = token

        sign = XSNet1.removeSpaceAndNewline(sign)
        sign = XSNet1.sortOrderByWith(sign)
        sign = XSNet1.getMd5Str(sign)

        header["timestamp"] = timestamp
        header["nonce"] = nonce
        header["sign"] = sign
        header["Content-Type"] = "application/json"

        return header
    }

    static func getMd5Str(_ str: String) -> String {
        guard let data = str.data(using: .utf8) else { return "" }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { CC_MD5($0.baseAddress, CC_LONG(data.count), &digest) }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func removeSpaceAndNewline(_ str: String) -> String {
        return str
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\n", with: "")
    }

    static func sortOrderByWith(_ str: String) -> String {
        return String(str.sorted())
    }

    static func getNonce() -> String {
        return "\(Int.random(in: 0..<1000))"
    }

    static func getTimeStamp() -> String {
        return "\(Int(Date().timeIntervalSince1970))"
    }

    static func dataTOjsonString(_ object: Any?) -> String? {
        guard let object = object else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: object,
                                                     options: .prettyPrinted) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    @discardableResult
    func hideErrorAlert(_ control: NSObject,
                        param: [AnyHashable: Any]?,
                        path: String,
                        requestType: XSAPIRequestType,
                        loadingMsg: String,
                        complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(control, serverName: serverName(), path: path,
                                        param: param, bodyData: nil, dataFilePath: nil,
                                        dataFileURL: nil, image: nil, dataName: nil,
                                        fileName: nil, requestType: requestType,
                                        alertType: .none, mimeType: nil, timeout: 0,
                                        loadingMsg: loadingMsg, complete: responseBlock,
                                        uploadProgressBlock: nil, downloadProgressBlock: nil,
                                        errorButtonSelectIndex: nil)
    }

    @discardableResult
    func uploadImage(_ control: NSObject,
                     path: String,
                     image: UIImage,
                     params: [AnyHashable: Any]?,
                     dataName: String,
                     progress: ProgressBlock?,
                     complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(control, serverName: serverName(), path: path,
                                        param: params, bodyData: nil, dataFilePath: nil,
                                        dataFileURL: nil, image: image, dataName: dataName,
                                        fileName: "img.png", requestType: .postUpload,
                                        alertType: .unknown, mimeType: "image/png", timeout: 0,
                                        loadingMsg: nil, complete: responseBlock,
                                        uploadProgressBlock: progress, downloadProgressBlock: nil,
                                        errorButtonSelectIndex: nil)
    }

    @discardableResult
    func downloadImage(_ control: NSObject,
                       imgPath: String,
                       progress: ProgressBlock?,
                       complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine? {
        return XSBaseDataEngine.control(self, serverName: serverName(), path: imgPath,
                                        param: nil, bodyData: nil, dataFilePath: nil,
                                        dataFileURL: nil, image: nil, dataName: nil,
                                        fileName: nil, requestType: .getDownload,
                                        alertType: .none, mimeType: nil, timeout: 0,
                                        loadingMsg: nil, complete: responseBlock,
                                        uploadProgressBlock: nil, downloadProgressBlock: progress,
                                        errorButtonSelectIndex: nil)
    }
}
