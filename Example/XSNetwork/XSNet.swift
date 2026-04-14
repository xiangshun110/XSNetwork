import Foundation
import XSNetwork

class XSNet: XSNetworkTools {
    private static let _instance = XSNet()

    @objc static func share() -> XSNet {
        return _instance
    }

    override func serverName() -> String {
        return "server1"
    }
}
