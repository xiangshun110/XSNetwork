# ObjcExample

演示如何在 **Objective-C** 项目中集成和使用 XSNetwork。

## 项目结构

| 文件 | 说明 |
|---|---|
| `XSNetObjc.h/.m` | 继承 `XSNetworkTools`，配置 baseURL、公共参数、错误处理等 |
| `ErrorHandlerObjc.h/.m` | 自定义响应错误处理器 |
| `ObjcViewController.h/.m` | 演示各种请求方式的 ViewController |

## 如何集成到你自己的 ObjC 项目

### 1. Podfile

```ruby
platform :ios, '12.0'
use_frameworks!

target 'YourApp' do
  pod 'XSNetwork'
end
```

运行 `pod install`，之后用 `.xcworkspace` 打开项目。

### 2. 导入

在 ObjC 文件中使用 `@import XSNetwork;` 即可：

```objc
@import XSNetwork;
```

> 如果项目没有开启 modules，也可以用 `#import <XSNetwork/XSNetwork-Swift.h>`。

### 3. 创建你的网络工具类（参考 XSNetObjc）

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
}
@end
```

### 4. 发起请求

```objc
// POST（JSON）
[[XSNetObjc shared] postRequest:self
                          param:@{@"name": @"test"}
                           path:@"/api/user"
                     loadingMsg:@"请求中..."
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

### 5. 切换环境

```objc
[XSNetObjc shared].server.model.environmentType = XSEnvTypeDevelop;   // 开发环境
[XSNetObjc shared].server.model.environmentType = XSEnvTypeRelease;   // 正式环境
[XSNetObjc shared].server.model.environmentType = XSEnvTypePreRelease; // 预发布环境
```
