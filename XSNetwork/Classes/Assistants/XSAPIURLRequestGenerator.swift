//  XSAPIURLRequestGenerator.swift
//  XSNetwork

import Foundation

private let xsURLQueryAllowedCharacters: CharacterSet = {
    return CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}()

@objcMembers
@objc public class XSAPIURLRequestGenerator: NSObject {
    @objc public static let sharedInstance = XSAPIURLRequestGenerator()
    private override init() { super.init() }

    @objc public func generateWithRequestDataModel(_ dataModel: XSAPIBaseRequestDataModel) -> URLRequest? {
        let service = XSServerFactory.sharedInstance.serviceWithName(dataModel.serverName)

        // Build merged parameters
        var mergedParams: [AnyHashable: Any] = [:]
        var isExcluded = false
        if let excludes = service.model.comParamExclude {
            for u in excludes where dataModel.apiMethodPath.contains(u) {
                isExcluded = true
                break
            }
        }
        if !isExcluded, let common = service.model.commonParameter {
            common.forEach { mergedParams[$0.key] = $0.value }
        }
        if let params = dataModel.parameters {
            params.forEach { mergedParams[$0.key] = $0.value }
        }
        if let dynBlock = service.model.dynamicParamsBlock, let dynParams = dynBlock() {
            dynParams.forEach { mergedParams[$0.key] = $0.value }
        }

        // Resolve URL
        var urlString: String
        if dataModel.requestType != .getDownload && dataModel.needBaseURL {
            guard let resolved = buildURLString(base: service.model.apiBaseUrl, path: dataModel.apiMethodPath) else { return nil }
            urlString = resolved
        } else {
            urlString = dataModel.apiMethodPath
        }

        // Build request
        var request: URLRequest?
        switch dataModel.requestType {
        case .get:
            request = buildGETRequest(urlString: urlString, parameters: mergedParams)
        case .post:
            request = buildJSONRequest(method: "POST", urlString: urlString, parameters: mergedParams)
        case .put:
            request = buildJSONRequest(method: "PUT", urlString: urlString, parameters: mergedParams)
        case .delete:
            request = buildJSONRequest(method: "DELETE", urlString: urlString, parameters: mergedParams)
        case .update:
            request = buildJSONRequest(method: "UPDATE", urlString: urlString, parameters: mergedParams)
        case .postFormData:
            request = buildFormDataRequest(urlString: urlString, parameters: mergedParams)
        case .postUpload:
            request = buildMultipartRequest(urlString: urlString, parameters: mergedParams, dataModel: dataModel)
        case .getDownload:
            if let url = URL(string: urlString) { request = URLRequest(url: url) }
        @unknown default:
            return nil
        }

        guard var req = request else { return nil }

        // Timeout
        if dataModel.requestType == .postUpload || dataModel.requestType == .getDownload {
            req.timeoutInterval = 0  // Transfer session handles its own timeout
        } else if dataModel.requestTimeout > 0 {
            req.timeoutInterval = dataModel.requestTimeout
        } else {
            req.timeoutInterval = service.model.requestTimeout > 0 ? service.model.requestTimeout : DefaultTimeout
        }

        // Headers
        var headerParams: [String: String] = [:]
        if let common = service.model.commonHeaders {
            common.forEach { headerParams[$0.key] = $0.value }
        }
        if let dynBlock = service.model.dynamicHeadersBlock, let dynHeaders = dynBlock() {
            dynHeaders.forEach { headerParams[$0.key] = $0.value }
        }
        if let paramsBlock = service.model.headersWithRequestParamsBlock {
            var impDic: [AnyHashable: Any] = mergedParams
            impDic["_url_"] = urlString
            if let extraHeaders = paramsBlock(impDic) {
                extraHeaders.forEach { headerParams[$0.key] = $0.value }
            }
        }
        for (field, value) in headerParams {
            req.addValue(value, forHTTPHeaderField: field)
        }

        // Body data override
        if let body = dataModel.bodyData {
            req.httpBody = body
        }

#if DEBUG
        print("=====请求数据开始=====")
        print("URL: \(urlString)")
        print("参数: \(mergedParams)")
        print("headers: \(req.allHTTPHeaderFields ?? [:])")
        print("=====请求数据结束=====")
#endif

        return req
    }

    // MARK: - Private builders

    private func buildGETRequest(urlString: String, parameters: [AnyHashable: Any]) -> URLRequest? {
        guard var components = URLComponents(string: urlString) else { return nil }
        if !parameters.isEmpty {
            var queryItems = components.queryItems ?? []
            for (k, v) in parameters {
                let ek = "\(k)".addingPercentEncoding(withAllowedCharacters: xsURLQueryAllowedCharacters) ?? "\(k)"
                let ev = "\(v)".addingPercentEncoding(withAllowedCharacters: xsURLQueryAllowedCharacters) ?? "\(v)"
                queryItems.append(URLQueryItem(name: ek, value: ev))
            }
            components.queryItems = queryItems
        }
        guard let url = components.url else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        return req
    }

    private func buildJSONRequest(method: String, urlString: String, parameters: [AnyHashable: Any]) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        if !parameters.isEmpty {
            guard let body = try? JSONSerialization.data(withJSONObject: parameters) else { return nil }
            req.httpBody = body
        }
        return req
    }

    private func buildFormDataRequest(urlString: String, parameters: [AnyHashable: Any]) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if !parameters.isEmpty {
            let parts: [String] = parameters.compactMap { (k, v) in
                guard let ek = "\(k)".addingPercentEncoding(withAllowedCharacters: xsURLQueryAllowedCharacters),
                      let ev = "\(v)".addingPercentEncoding(withAllowedCharacters: xsURLQueryAllowedCharacters) else { return nil }
                return "\(ek)=\(ev)"
            }
            req.httpBody = parts.joined(separator: "&").data(using: .utf8)
        }
        return req
    }

    private func buildMultipartRequest(urlString: String, parameters: [AnyHashable: Any], dataModel: XSAPIBaseRequestDataModel) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        let boundary = "----XSNetworkBoundary\(UUID().uuidString)"
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        func appendString(_ s: String) { if let d = s.data(using: .utf8) { body.append(d) } }

        for (k, v) in parameters {
            appendString("--\(boundary)\r\n")
            appendString("Content-Disposition: form-data; name=\"\(k)\"\r\n\r\n")
            appendString("\(v)\r\n")
        }

        let filePath = dataModel.dataFilePath ?? ""
        if !filePath.isEmpty || dataModel.dataFileURL != nil {
            let fileURL = dataModel.dataFileURL ?? URL(fileURLWithPath: filePath)
            let name = dataModel.dataName ?? "data"
            let fn = dataModel.fileName ?? "data.zip"
            let mime = dataModel.mimeType ?? "application/zip"
            if let fileData = try? Data(contentsOf: fileURL) {
                appendString("--\(boundary)\r\n")
                appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fn)\"\r\n")
                appendString("Content-Type: \(mime)\r\n\r\n")
                body.append(fileData)
                appendString("\r\n")
            }
        }

        if let imgData = dataModel.imageData {
            let name = dataModel.dataName ?? "image"
            let fn = dataModel.fileName ?? "image.png"
            let mime = dataModel.mimeType ?? "image/png"
            appendString("--\(boundary)\r\n")
            appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fn)\"\r\n")
            appendString("Content-Type: \(mime)\r\n\r\n")
            body.append(imgData)
            appendString("\r\n")
        }

        appendString("--\(boundary)--\r\n")
        req.httpBody = body
        return req
    }

    private func buildURLString(base: String, path: String) -> String? {
        let combined = base + path
        // Remove duplicate slashes while preserving the scheme (e.g. "https://")
        var result: String
        if let schemeRange = combined.range(of: "://") {
            let scheme = String(combined[combined.startIndex..<schemeRange.upperBound])
            let rest = String(combined[schemeRange.upperBound...])
            result = scheme + rest.replacingOccurrences(of: "//", with: "/")
        } else {
            result = combined.replacingOccurrences(of: "//", with: "/")
        }
        return URL(string: result) != nil ? result : nil
    }
}
