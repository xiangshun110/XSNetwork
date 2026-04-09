//  XSServerModel.swift
//  XSNetwork

import Foundation

@objc public class XSServerModel: NSObject {
    /// Request timeout; defaults to 25 seconds
    @objc public var requestTimeout: TimeInterval = 25.0

    /// View used to display toasts
    @objc public var toastView: XSPlatformView?

    /// How to present errors; defaults to .unknown (defer to server default)
    @objc public var errorAlerType: XSAPIAlertType = .unknown

    /// JSON key for extracting error messages from response body
    @objc public var errMessageKey: String = "message"

    /// Called on every request to supply dynamic parameters.
    /// Use [weak self] inside the block to avoid retain cycles.
    @objc public var dynamicParamsBlock: (() -> [AnyHashable: Any]?)?

    /// Static common parameters appended to every request
    @objc public var commonParameter: [AnyHashable: Any]?

    /// Static common headers appended to every request
    @objc public var commonHeaders: [String: String]?

    /// Called on every request to supply dynamic headers
    @objc public var dynamicHeadersBlock: (() -> [String: String]?)?

    /// Called on every request; receives all params (including the "_url_" key).
    /// Use this to compute per-request signatures.
    @objc public var headersWithRequestParamsBlock: (([AnyHashable: Any]) -> [String: String]?)?

    /// URL substrings that should NOT receive common parameters
    @objc public var comParamExclude: [String]?

    /// Custom response/error handler. Defaults to a passthrough handler.
    @objc public var errHander: XSAPIResponseErrorHandler?

    @objc public var developApiBaseUrl: String = ""
    @objc public var prereleaseApiBaseUrl: String = ""
    @objc public var releaseApiBaseUrl: String = ""

    /// Persisted custom base URL (for LAN debugging). Stored in UserDefaults.
    private var _customApiBaseUrl: String?
    @objc public var customApiBaseUrl: String? {
        get { _customApiBaseUrl }
        set {
            _customApiBaseUrl = newValue
            let key = "customApi_\(serverName)"
            if let url = newValue {
                UserDefaults.standard.set(url, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
            UserDefaults.standard.synchronize()
        }
    }

    private var _environmentType: XSEnvType = .release
    @objc public var environmentType: XSEnvType {
        get { _environmentType }
        set {
            _environmentType = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: "environmentType")
            UserDefaults.standard.synchronize()
            _apiBaseUrl = nil
            NotificationCenter.default.post(name: NSNotification.Name(NotiEnvChange), object: nil)
        }
    }

    @objc public var publicKey: String = ""
    @objc public var privateKey: String = "volkhjuss$&^ghhh"

    private var _apiBaseUrl: String?
    @objc public var apiBaseUrl: String {
        if _apiBaseUrl == nil {
            switch _environmentType {
            case .develop:    _apiBaseUrl = developApiBaseUrl
            case .preRelease: _apiBaseUrl = prereleaseApiBaseUrl
            case .release:    _apiBaseUrl = releaseApiBaseUrl
            case .custom:     _apiBaseUrl = _customApiBaseUrl
            @unknown default: break
            }
        }
        return _apiBaseUrl ?? ""
    }

    @objc public private(set) var serverName: String

    @objc public init(serverName: String) {
        self.serverName = serverName
        super.init()
        setupDefaults()
    }

    private func setupDefaults() {
        if let raw = UserDefaults.standard.object(forKey: "environmentType") as? Int,
           let env = XSEnvType(rawValue: raw) {
            _environmentType = env
        } else {
            _environmentType = .release
        }
        errorAlerType = .unknown
        privateKey = "volkhjuss$&^ghhh"
        errHander = XSAPIResponseErrorHandler()
        requestTimeout = 25.0
        errMessageKey = "message"
        // Restore persisted custom URL without triggering UserDefaults write
        let key = "customApi_\(serverName)"
        _customApiBaseUrl = UserDefaults.standard.string(forKey: key)
    }
}
