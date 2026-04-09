import UIKit
import XSNetwork

class XSViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let items = [
        "模块1(高级用法)",
        "模块2(返回后自动取消请求)",
        "post请求",
        "post请求(multipart/form-data)",
        "get请求",
        "切换环境",
        "不用baseURL的请求",
        "文件下载"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "demo"

        XSNet.singleInstance().server.model.releaseApiBaseUrl = "https://api.talkmed.com/api/v1"
        XSNet.singleInstance().server.model.developApiBaseUrl = "http://api.sandbox.talkmed.com/api/v1"
        XSNet.singleInstance().server.model.environmentType = .develop

        print("XSNet.singleInstance():\(XSNet.singleInstance())")

        if let window = UIApplication.shared.windows.first {
            XSNet.singleInstance().showEnvTagView(window)
        }

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
            let vc1 = XSViewController1()
            navigationController?.pushViewController(vc1, animated: true)
        case 1:
            let vc2 = XSViewController2()
            navigationController?.pushViewController(vc2, animated: true)
        case 2:
            let params: [AnyHashable: Any] = ["name": "test", "age": 18]
            XSNet.singleInstance().postRequest(self, param: params,
                                               path: "http://localhost:48081/app-api/test/json",
                                               loadingMsg: "ooooo") { data, error in
                print("----data:\(String(describing: data))")
            }
        case 3:
            let params: [AnyHashable: Any] = ["name": "test", "age": 18]
            XSNet.singleInstance().postFormDataRequest(self, param: params,
                                                       path: "http://localhost:48081/app-api/test/form",
                                                       loadingMsg: "发送FormData请求...") { data, error in
                print("----FormData data:\(String(describing: data))")
                if let error = error { print("----FormData error:\(error)") }
            }
        case 4:
            XSNet.singleInstance().getRequest(self, param: nil, path: "/time",
                                              loadingMsg: "ooooo") { data, error in
                print("----data:\(String(describing: data))")
            }
        case 5:
            if XSNet.singleInstance().server.model.environmentType == .release {
                XSNet.singleInstance().server.model.environmentType = .develop
                print("切换dev成功")
            } else {
                XSNet.singleInstance().server.model.environmentType = .release
                print("切换release成功")
            }
        case 6:
            XSNet.singleInstance().getRequest(self, param: nil,
                                              path: "https://api.weixin.qq.com/sns/userinfo",
                                              loadingMsg: "lll") { data, error in
                print("----data:\(String(describing: data))")
            }
        case 7:
            let url = "https://cdn.sandbox.edstatic.com/202311122246/a7c470d9e9859480e6612b88dfbcf05f/2023/01/18/92070ab7-2b19-bd06-b980-77d4b5ca63f6.svga"
            XSNet.singleInstance().downloadFile(self, url: url, fileName: "test1/01.pdf",
                                               progress: { taskProgress in
                print("--------:\(Float(taskProgress.completedUnitCount) / Float(taskProgress.totalUnitCount))")
            }) { data, error in
                print("aaa")
            }
        default:
            break
        }
    }
}
