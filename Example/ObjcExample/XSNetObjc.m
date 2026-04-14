//  XSNetObjc.m
//  ObjcExample — 演示如何在 Objective-C 项目中使用 XSNetwork

#import "XSNetObjc.h"
#import "ErrorHandlerObjc.h"

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

// 必须重写，用于区分各个模块，使各个模块的请求和配置互不影响
- (NSString *)serverName {
    return @"XSNetObjc";
}

- (void)setupConfig {
    // 配置 baseURL（可选，不配置则每次请求都传完整 URL）
    self.server.model.releaseApiBaseUrl  = @"https://api.abc.com";
    self.server.model.developApiBaseUrl  = @"https://devapi.abc.com";

    // 自定义错误处理逻辑
    self.server.model.errHander = [[ErrorHandlerObjc alloc] init];

    // 公共参数（每个请求都会带上）
    self.server.model.commonParameter = @{@"version": @"1.0"};

    // 动态公共参数（每次请求时执行一次，适合带时间戳等场景）
    self.server.model.dynamicParamsBlock = ^NSDictionary * _Nullable {
        return @{@"timestamp": @((NSInteger)[[NSDate date] timeIntervalSince1970])};
    };

    // 错误提示配置
    self.server.model.errMessageKey   = @"message";   // 从响应 JSON 里取错误文案的 key
    self.server.model.errorAlerType   = XSAPIAlertTypeToast;
}

@end
