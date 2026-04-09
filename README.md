# XSNetwork

[![CI Status](https://img.shields.io/travis/shun/XSNetwork.svg?style=flat)](https://travis-ci.org/shun/XSNetwork)
[![Version](https://img.shields.io/cocoapods/v/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)
[![License](https://img.shields.io/cocoapods/l/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)
[![Platform](https://img.shields.io/cocoapods/p/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## 说明：

这个库是对 Alamofire 的封装，纯 Swift 实现，配置灵活，使用方便，满足中小企业的大部分需求。

特点：

1. 可配置多换环境，可随时切换环境
2. VC销毁时自动取消没完成的网络请求
3. 可设置公共参数，可设置不要公共参数的URL
4. 静态方法调用，使用方便
5. 支持全局配置超时时间和单个请求设置超时时间
6. 支持各个模块可以独立配置baseurl等，便于模块化开发
7. 支持POST请求的JSON和multipart/form-data两种格式

###### POST请求格式说明：

```swift
// JSON格式 (默认，Content-Type: application/json)
networkTools.postRequest(self, param: params, path: "/api/login", loadingMsg: "登录中...", complete: responseBlock)

// multipart/form-data格式 (Content-Type: application/x-www-form-urlencoded)
networkTools.postFormDataRequest(self, param: params, path: "/api/login", loadingMsg: "登录中...", complete: responseBlock)
```

## Requirements

依赖的第三方库：

- 'Alamofire', '~> 5.11'

## Installation

XSNetwork is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XSNetwork'
```

## 使用：

###### 1.简单用法，无需任何配置

```swift
import XSNetwork

// JSON POST请求 (默认)
XSNetworkTools.singleInstance().postRequest(self, param: nil,
                                             path: "https://api.abc.com/user",
                                             loadingMsg: "loading") { data, error in
    print("---data:\(String(describing: data))")
}

// multipart/form-data POST请求
let params: [AnyHashable: Any] = ["username": "test", "password": "123456"]
XSNetworkTools.singleInstance().postFormDataRequest(self, param: params,
                                                     path: "https://api.abc.com/login",
                                                     loadingMsg: "登录中...") { data, error in
    print("---data:\(String(describing: data))")
}
```



###### 2.高级用法

```swift
// 高级用法（可以参考demo）
// 1. 新建一个类，继承 XSNetworkTools：
import XSNetwork

class XSNet: XSNetworkTools {
    private static let _instance: XSNet = {
        let instance = XSNet()
        instance.config()
        return instance
    }()

    static func share() -> XSNet { return _instance }

    // 必须重写这个方法，这个名字用于区分各个模块，使各个模块的请求和配置互不影响
    override func serverName() -> String { return "server1" }

    private func config() {
        // 配置 baseURL，最好是配置，不然每次请求都要写全量 url
        server.model.releaseApiBaseUrl = "https://api.abc.com"
        server.model.developApiBaseUrl = "https://devapi.abc.com"

        // 自定义错误处理逻辑（参考 Example 中的 ErrorHandler1）
        server.model.errHander = ErrorHandler1()

        // 通用参数
        server.model.commonParameter = ["key": "value"]

        // 动态通用参数（每次请求都会执行一次）
        server.model.dynamicParamsBlock = {
            return ["test_uuid": UUID().uuidString]
        }

        // 错误提示（统一配置），如果单个请求中设置了，以单个请求优先
        server.model.errMessageKey = "message"
        server.model.errorAlerType = .toast
    }
}


// 2. 使用
override func viewDidLoad() {
    super.viewDidLoad()

    // 切换环境（默认是 .release）
    XSNet.share().server.model.environmentType = .develop

    // 来一个请求试试：
    XSNet.share().postRequest(self, param: nil, path: "/login",
                              loadingMsg: "ooooo") { data, error in
        print("----data:\(String(describing: data))")
    }
}
```



## Author

向顺, 113648883@qq.com

## 版本更新记录

#### 1.0.6

1. 全部改为 Swift 实现，删除旧的 .h/.m 文件
2. Example 项目改为纯 Swift


------

#### 1.0.0

1. 去掉AFNetworking, 改用Alamofire


------


#### 0.3.2

1. 支持m系列电脑


------

#### 0.3.1

1. post请求支持form-data方式传参数，示例：

   ```swift
   let params: [AnyHashable: Any] = ["name": "test", "age": 18]
   XSNet.singleInstance().postFormDataRequest(self, param: params,
                                              path: "http://localhost:48081/app-api/test/form",
                                              loadingMsg: "发送FormData请求...") { data, error in
       print("----FormData data:\(String(describing: data))")
       if let error = error { print("----FormData error:\(error)") }
   }
   ```

   


------

#### 

#### 0.2.21

1. baseURL支持任意字符串


------

#### 0.2.20

1. 支持图片以nsdata的方式上传，在XSBaseDataEngine里面加了一个方法


------

#### 0.2.17

1. 下载支持自定义文件名和保存路径，详见XSNetworkTools的downloadFile方法


------


#### 0.2.16

1. 修复环境的名字标签不显示


------

#### 

#### 0.2.15

1.在左上角显示当前环境的名字（可配置是否显示）---样式调整


------

#### 0.2.14

1.在左上角显示当前环境的名字（可配置是否显示）


------

#### 0.2.12

1.hub弹出放在主线程执行


------

#### 

#### 0.2.10

1.在headersWithRequestParamsIMP参数里面加一个当前请求的URL，key是：_url_


------

#### 0.2.9

1.修复参数为空的时候header没加进去


------

#### 0.2.8

1.修复XSNetworkTools里面uploadFile没有上传进度


------

#### 0.2.7

1.把AFHTTPRequestSerializer改成AFJSONRequestSerializer


------

#### 0.2.6

1.修改添加header参数的方式，setValue改成addValue，这样不会改变原来header的数据


------

#### 0.2.5

1.支持text/html，解决这个错误failed: unacceptable content-type: text/html


------


#### 0.2.4

1. `XSServerModel` 中增加 `headersWithRequestParamsBlock`，作用是处理请求参数并放在header里面，例如：

```swift
// params 就是请求的所有参数
server.model.headersWithRequestParamsBlock = { params in
    let str = XSNet1.dataTOjsonString(params) ?? ""
    return ["sign": XSNet1.getMd5Str(str)]
}
```

------

#### 0.2.3

1.XSServerModel中增加commonHeaders，dynamicHeadersIMP用于添加header参数


------

#### 0.2.2

1.XSNetworkTools调整


------

#### 0.2.1



1.上传文件设置为不超时

------

#### 0.2.0


1.大调整，支持各个模块可以独立配置baseurl等，便于模块化开发


------

#### 0.1.19



1. `XSNetworkTools` 中增加带 `loadingMsg` 参数的请求方法：

```swift
/// 网络请求
/// - Parameters:
///   - control: self
///   - param: 参数
///   - path: URL
///   - requestType: .get / .post / ...
///   - loadingMsg: 不为 nil 时显示 loading，请求完成后自动消失
///   - responseBlock: 回调
func request(_ control: NSObject, param: [AnyHashable: Any]?, path: String,
             requestType: XSAPIRequestType, loadingMsg: String?,
             complete responseBlock: CompletionDataBlock?) -> XSBaseDataEngine?
```



------

#### 0.1.13



1. 增加动态参数支持（`dynamicParamsBlock`）：

```swift
// 在配置中设置动态参数闭包（每次请求都会调用一次）
server.model.dynamicParamsBlock = {
    return ["time": Int(Date().timeIntervalSince1970)]
}
```





------

#### 0.1.12


1. 增加错误提示配置：

```swift
// 请求错误时弹出消息的方式，默认不弹出
server.model.errorAlerType = .toast

// 设置获取错误消息的 key，默认是 "message"
server.model.errMessageKey = "message"
```


------

#### 0.1.11


1. 增加 toast 视图配置：

```swift
// 设置弹出 toast 的视图（不设置则使用当前 VC 的 view）
server.model.toastView = someView
```


------

#### 0.1.10



1. 增加可以往 body 里面传一个 `Data`：

```swift
networkTools.request(self, bodyData: someData, param: nil, path: "/upload", complete: responseBlock)
```

------

#### 0.1.5



1.增加全局设置超时时间（[XSNetworkTools setRequesTimeout:10];）

2.增加单个请求设置超时时间


------
## License

XSNetwork is available under the MIT license. See the LICENSE file for more info.
