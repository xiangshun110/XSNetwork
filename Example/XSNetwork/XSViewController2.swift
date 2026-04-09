import UIKit
import XSNetwork

class XSViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "what"
        view.backgroundColor = .white

        XSNetworkTools.singleInstance().postRequest(self,
                                                    param: nil,
                                                    path: "https://api.weixin.qq.com/sns/userinfo",
                                                    loadingMsg: "ss") { data, error in
            print("---data:\(String(describing: data))")
        }
    }

    deinit {
        print("-----dealloc:\(type(of: self))")
    }
}
