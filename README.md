# XSNetwork

[![Version](https://img.shields.io/cocoapods/v/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)
[![License](https://img.shields.io/cocoapods/l/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)
[![Platform](https://img.shields.io/cocoapods/p/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)

## 说明

这个库是对 Alamofire 的封装，纯 Swift 实现，同时支持 Swift 和 Objective-C 项目调用，配置灵活，使用方便，满足中小企业的大部分需求。

**特点：**

1. 支持多环境配置，可随时切换（develop / preRelease / release / custom）
2. VC 销毁时自动取消未完成的网络请求
3. 可设置公共参数及动态公共参数，支持排除指定 URL
4. 支持全局配置超时时间和单个请求单独设置超时时间
5. 支持各模块独立配置 baseURL，便于模块化开发
6. 支持 POST 请求的 JSON（application/json）和 multipart/form-data 两种格式
7. 支持文件上传（文件路径 / URL / UIImage / NSData）和文件下载
8. 支持自定义响应错误处理逻辑
9. 支持自定义请求签名（headersWithRequestParamsBlock）
10. Swift 和 Objective-C 均可调用

## Example

克隆仓库后，进入 `Example` 目录执行 `pod install`，用 Xcode 打开 `XSNetwork.xcworkspace` 即可运行 Swift 示例。

Objective-C 示例代码位于 `Example/ObjcExample/` 目录，可直接参考其中的源文件。

## Requirements

- iOS 12.0+
- 依赖：`Alamofire ~> 5.11`

## Installation

```ruby
pod 'XSNetwork'
```

---

## 使用

### 一、简单用法（无需任何配置）

**Swift**

```swift
import XSNetwork

// POST（JSON，默认）
XSNetworkTools.singleInstance().postRequest(self, param: nil,
                                             path: "https://api.abc.com/user",
                                             loadingMsg: "loading") { data, error in
    print(data as Any)
}

// POST（multipart/form-data）
let params: [AnyHashable: Any] = ["username": "test", "password": "123456"]
XSNetworkTools.singleInstance().postFormDataRequest(self, param: params,
                                                     path: "https://api.abc.com/login",
                                                     loadingMsg: "登录中...") { data, error in
    print(data as Any)
}
```

**Objective-C**

```objc
@import XSNetwork;

// POST（JSON）
[[XSNetworkTools singleInstance] postRequest:self
                                       param:nil
                                        path:@"https://api.abc.com/user"
                                  loadingMsg:@"loading"
                                    complete:^(id data, NSError *error) {
    NSLog(@"%@", data);
}];
```

---

### 二、高级用法（推荐，支持模块化）

#### 1. 新建一个类，继承 `XSNetworkTools`

**Swift**

```swift
import XSNetwork

class XSNet: XSNetworkTools {
    private static let _instance: XSNet = {
        let instance = XSNet()
        instance.config()
        return instance
    }()

    static func share() -> XSNet { return _instance }

    // 必须重写，用于区分各个模块，使各模块请求和配置互不影响
    override func serverName() -> String { return "server1" }

    private func config() {
        // 配置 baseURL（建议配置，避免每次请求都写全量 URL）
        server.model.releaseApiBaseUrl = "https://api.abc.com"
        server.model.developApiBaseUrl = "https://devapi.abc.com"

        // 自定义错误处理
        server.model.errHander = ErrorHandler1()

        // 公共参数
        server.model.commonParameter = ["version": "1.0"]

        // 动态公共参数（每次请求都会执行一次）
        server.model.dynamicParamsBlock = {
            return ["timestamp": Int(Date().timeIntervalSince1970)]
        }

        // 错误提示配置
        server.model.errMessageKey = "message"
        server.model.errorAlerType = .toast
    }
}
```

**Objective-C**

```objc
// XSNetObjc.h
@import XSNetwork;
@interface XSNetObjc : XSNetworkTools
+ (instancetype)shared;
@end

// XSNetObjc.m
@implementation XSNetObjc

+ (instancetype)shared {
    static XSNetObjc *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XSNetObjc alloc] init];
        [_instance setupConfig];
    });
    return _instance;
}

- (NSString *)serverName { return @"XSNetObjc"; }

- (void)setupConfig {
    self.server.model.releaseApiBaseUrl = @"https://api.abc.com";
    self.server.model.developApiBaseUrl = @"https://devapi.abc.com";
    self.server.model.errMessageKey     = @"message";
    self.server.model.errorAlerType     = XSAPIAlertTypeToast;

    // 动态公共参数
    self.server.model.dynamicParamsBlock = ^NSDictionary * _Nullable {
        return @{@"timestamp": @((NSInteger)[[NSDate date] timeIntervalSince1970])};
    };
}
@end
```

#### 2. 发起请求

**Swift**

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    // 切换环境（默认 .release）
    XSNet.share().server.model.environmentType = .develop

    // POST
    XSNet.share().postRequest(self, param: nil, path: "/api/login",
                              loadingMsg: "登录中...") { data, error in
        print(data as Any)
    }

    // GET
    XSNet.share().getRequest(self, param: nil, path: "/api/time",
                             loadingMsg: nil) { data, error in
        print(data as Any)
    }
}
```

**Objective-C**

```objc
// 切换环境
[XSNetObjc shared].server.model.environmentType = XSEnvTypeDevelop;

// POST（JSON）
[[XSNetObjc shared] postRequest:self
                          param:@{@"name": @"test"}
                           path:@"/api/login"
                     loadingMsg:@"登录中..."
                       complete:^(id data, NSError *error) {
    NSLog(@"%@", data);
}];

// POST（multipart/form-data）
[[XSNetObjc shared] postFormDataRequest:self
                                  param:@{@"username": @"test", @"password": @"123"}
                                   path:@"/api/login"
                             loadingMsg:@"登录中..."
                               complete:^(id data, NSError *error) {
    NSLog(@"%@", data);
}];

// GET
[[XSNetObjc shared] getRequest:self
                         param:nil
                          path:@"/api/time"
                    loadingMsg:nil
                      complete:^(id data, NSError *error) {
    NSLog(@"%@", data);
}];
```

---

### 三、请求方法说明

| 方法 | 说明 |
|---|---|
| `getRequest(_:param:path:loadingMsg:complete:)` | GET 请求 |
| `postRequest(_:param:path:loadingMsg:complete:)` | POST 请求（JSON body） |
| `postFormDataRequest(_:param:path:loadingMsg:complete:)` | POST 请求（multipart/form-data） |
| `request(_:param:path:requestType:loadingMsg:complete:)` | 通用请求，可指定 HTTP 方法 |
| `request(_:param:path:requestType:timeout:complete:)` | 通用请求，支持单独设置超时时间 |
| `request(_:bodyData:param:path:complete:)` | 传 Data 到 body |
| `uploadFile(_:param:path:fileURL:filePath:fileKey:fileName:requestType:progress:complete:)` | 文件上传 |
| `downloadFile(_:url:fileName:progress:complete:)` | 文件下载 |

---

### 四、XSServerModel 配置项

| 属性 | 类型 | 说明 |
|---|---|---|
| `releaseApiBaseUrl` | String | 正式环境 baseURL |
| `developApiBaseUrl` | String | 开发环境 baseURL |
| `prereleaseApiBaseUrl` | String | 预发布环境 baseURL |
| `customApiBaseUrl` | String? | 自定义 baseURL（持久化到 UserDefaults） |
| `environmentType` | XSEnvType | 当前环境（.develop / .preRelease / .release / .custom） |
| `requestTimeout` | TimeInterval | 请求超时，默认 25 秒 |
| `commonParameter` | [AnyHashable: Any]? | 公共参数 |
| `dynamicParamsBlock` | () -> [AnyHashable: Any]? | 动态公共参数（每次请求执行） |
| `commonHeaders` | [String: String]? | 公共 header |
| `dynamicHeadersBlock` | () -> [String: String]? | 动态公共 header |
| `headersWithRequestParamsBlock` | ([AnyHashable: Any]) -> [String: String]? | 根据请求参数计算签名并放入 header |
| `comParamExclude` | [String]? | 不附带公共参数的 URL 关键字列表 |
| `errHander` | XSAPIResponseErrorHandler? | 自定义响应错误处理器 |
| `errMessageKey` | String | 从响应 JSON 中取错误文案的 key，默认 `"message"` |
| `errorAlerType` | XSAPIAlertType | 错误提示方式（.unknown / .none / .toast） |
| `toastView` | XSPlatformView? | toast 弹出的目标视图，nil 则使用当前 VC 的 view |

---

### 五、签名示例（headersWithRequestParamsBlock）

**Swift**

```swift
server.model.headersWithRequestParamsBlock = { params in
    // params 包含本次请求的全部参数（含内置的 "_url_" key）
    let jsonStr = XSNet1.dataTOjsonString(params) ?? ""
    return ["sign": XSNet1.getMd5Str(jsonStr)]
}
```

**Objective-C**

```objc
self.server.model.headersWithRequestParamsBlock = ^NSDictionary<NSString *, NSString *> * _Nullable(NSDictionary *params) {
    // 根据 params 计算签名
    return @{@"sign": [self calcSign:params]};
};
```

---

## Author

向顺, 113648883@qq.com

## 版本更新记录

#### 1.0.6

1. 全部改为 Swift 实现，删除旧的 .h/.m 文件
2. Example 项目改为纯 Swift
3. 新增 `Example/ObjcExample/` 演示 Objective-C 项目的接入方式

------

#### 1.0.0

1. 去掉 AFNetworking，改用 Alamofire

------

#### 0.3.2

1. 支持 Apple Silicon（M 系列）

------

#### 0.3.1

1. POST 请求支持 multipart/form-data 传参

------

#### 0.2.4

1. `XSServerModel` 新增 `headersWithRequestParamsBlock`，用于根据请求参数计算签名并放入 header

------

#### 0.2.3

1. `XSServerModel` 新增 `commonHeaders`、`dynamicHeadersBlock`，用于添加公共 header

------

#### 0.2.0

1. 支持各模块独立配置 baseURL，便于模块化开发

------

## License

XSNetwork is available under the MIT license. See the LICENSE file for more info.
