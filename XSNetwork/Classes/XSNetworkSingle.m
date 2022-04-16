//
//  XSNetworkSingle.m
//  XSNetwork
//
//  Created by shun on 2021/7/30.
//

#import "XSNetworkSingle.h"
#import "XSServerFactory.h"

static NSTimeInterval kYANetworkingTimeoutSeconds = 25.0f;

@interface XSNetworkSingle()


@end

@implementation XSNetworkSingle

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static XSNetworkSingle *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSNetworkSingle alloc] init];
        [sharedInstance initOther];
    });
    return sharedInstance;
}

- (void)initOther {
    self.requestTimeout = kYANetworkingTimeoutSeconds;
    self.errMessageKey = @"message";
    self.errorAlerType = XSAPIAlertType_None;
}


- (XSServerModel *)getServerConfig:(NSString *)serviceName {
    return [[XSServerFactory sharedInstance] serviceWithName:serviceName].model;
}

- (void)setDynamicParamsIMP:(IMP)dynamicParamsIMP serviceName:(NSString *)serviceName {
    XSServerModel *config = [self getServerConfig:serviceName];
    config.dynamicParamsIMP = dynamicParamsIMP;
}

- (void)setErrMessageKey:(NSString *)errMessageKey serviceName:(NSString *)serviceName {
    XSServerModel *config = [self getServerConfig:serviceName];
    config.errMessageKey = errMessageKey;
}

- (void)setErrorAlerType:(XSAPIAlertType)errorAlerType serviceName:(NSString *)serviceName {
    XSServerModel *config = [self getServerConfig:serviceName];
    config.errorAlerType = errorAlerType;
}

- (void)setToastView:(UIView *)toastView serviceName:(NSString *)serviceName {
    XSServerModel *config = [self getServerConfig:serviceName];
    config.toastView = toastView;
}

- (void)setRequestTimeout:(NSTimeInterval)requestTimeout serviceName:(NSString *)serviceName {
    XSServerModel *config = [self getServerConfig:serviceName];
    config.requestTimeout = requestTimeout;
}

@end
