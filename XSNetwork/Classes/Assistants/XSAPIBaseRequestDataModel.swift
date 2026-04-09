//  XSAPIBaseRequestDataModel.swift
//  XSNetwork

import Foundation

@objcMembers
@objc public class XSAPIBaseRequestDataModel: NSObject {
    public var apiMethodPath: String = ""

    @available(*, deprecated, message: "Use serverName instead")
    public var serviceType: XSServiceType = .main

    public var parameters: [AnyHashable: Any]?
    public var requestType: XSAPIRequestType = .get
    public var responseBlock: CompletionDataBlock?
    public var needBaseURL: Bool = true
    public var dataFilePath: String?
    public var dataFileURL: URL?
    public var dataName: String?
    public var fileName: String?
    public var mimeType: String?
    public var uploadProgressBlock: ProgressBlock?
    public var downloadProgressBlock: ProgressBlock?
    public var imageData: Data?
    public var bodyData: Data?
    /// If <= 0, default timeout from the server model is used
    public var requestTimeout: TimeInterval = 0

    private var _serverName: String?
    public var serverName: String {
        get { _serverName ?? DefaultServerName }
        set { _serverName = newValue }
    }
}
