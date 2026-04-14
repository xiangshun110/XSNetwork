//  XSNetObjc.h
//  ObjcExample — 演示如何在 Objective-C 项目中使用 XSNetwork

@import XSNetwork;

NS_ASSUME_NONNULL_BEGIN

/// 模块1：继承 XSNetworkTools，配置 baseURL、错误处理等
@interface XSNetObjc : XSNetworkTools

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
