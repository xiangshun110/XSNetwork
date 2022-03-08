//
//  XSNetworkSingle.h
//  XSNetwork
//
//  Created by shun on 2021/7/30.
//

#import <Foundation/Foundation.h>
#import "XSServerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface XSNetworkSingle : NSObject

@property (nonatomic, assign) NSTimeInterval        requestTimeout;

/// 用于显示提示框
@property (nonatomic, strong) UIView                *toastView;


/// 请求错误提示方式，默认不提示 XSAPIAlertType_None
@property (nonatomic, assign) XSAPIAlertType        errorAlerType;


@property (nonatomic, strong) NSString              *errMessageKey;


+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
