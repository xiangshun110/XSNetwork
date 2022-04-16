//
//  XSNetworkSingle.h
//  XSNetwork
//
//  Created by shun on 2021/7/30.
//  这个类弃用了

#import <Foundation/Foundation.h>
#import "XSServerConfig.h"
#import "XSServerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XSNetworkSingle : NSObject

@property (nonatomic, assign) NSTimeInterval        requestTimeout;

/// 用于显示提示框
@property (nonatomic, strong) UIView                *toastView;


/// 请求错误提示方式，默认不提示 XSAPIAlertType_None
@property (nonatomic, assign) XSAPIAlertType        errorAlerType;


@property (nonatomic, strong) NSString              *errMessageKey;


/// 动态参数IMP
@property (nonatomic, assign) IMP                   dynamicParamsIMP;


- (XSServerModel *)getServerConfig:(NSString *)serviceName;

- (void)setDynamicParamsIMP:(IMP)dynamicParamsIMP serviceName:(NSString *)serviceName;

- (void)setErrMessageKey:(NSString *)errMessageKey serviceName:(NSString *)serviceName;

- (void)setErrorAlerType:(XSAPIAlertType)errorAlerType serviceName:(NSString *)serviceName;

- (void)setToastView:(UIView *)toastView serviceName:(NSString *)serviceName;

- (void)setRequestTimeout:(NSTimeInterval)requestTimeout serviceName:(NSString *)serviceName;


+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
