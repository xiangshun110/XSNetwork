import UIKit
import XSNetwork

class XSViewController1: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let items = ["post请求", "get请求", "切换环境", "单个请求不显示错误提示", "aaa", "aaab"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "高级用法"
        view.backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = view.frame
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            XSNet1.share().postRequest(self, param: nil, path: "/v1/login",
                                       loadingMsg: "ooooo") { data, error in
                print("----data:\(String(describing: data))")
            }
        case 1:
            XSNet1.share().getRequest(self, param: nil, path: "/time",
                                      loadingMsg: "ooooo") { data, error in
                print("----data:\(String(describing: data))")
            }
        case 2:
            if XSNet1.share().server.model.environmentType == .release {
                XSNet1.share().server.model.environmentType = .develop
                print("切换dev成功")
            } else {
                XSNet1.share().server.model.environmentType = .release
                print("切换release成功")
            }
        case 3:
            XSNet1.share().hideErrorAlert(self, param: nil, path: "/v1/login",
                                          requestType: .post, loadingMsg: "ss") { data, error in
                print("----data:\(String(describing: data))")
            }
        case 4:
            let dic: [AnyHashable: Any] = [
                "actionenum": 5,
                "param": [
                    "category": 1,
                    "id": 1930,
                    "meetingid": 2707,
                    "type": 3
                ]
            ]
            XSNet1.share().hideErrorAlert(self, param: dic, path: "/admin/common/geturl",
                                          requestType: .post, loadingMsg: "ss") { data, error in
                print("----data:\(String(describing: data))")
            }
        case 5:
            let body: [AnyHashable: Any] = ["username": "aa", "password": "123456"]
            XSNet1.share().hideErrorAlert(self, param: body, path: "/admin/account/userlogin",
                                          requestType: .post, loadingMsg: "ss") { data, error in
                print("----data:\(String(describing: data))")
            }
        default:
            break
        }
    }
}
