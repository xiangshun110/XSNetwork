//
//  XSServerModel.h
//  XSNetwork
//
//  Created by shun on 2022/4/15.
//

#import <Foundation/Foundation.h>
#import "XSServerConfig.h"
#import "XSAPIResponseErrorHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface XSServerModel : NSObject

/// 请求超时时间，0是默认值25秒
@property (nonatomic, assign) NSTimeInterval        requestTimeout;

/// 用于显示提示框
@property (nonatomic, strong) UIView                *toastView;


/// 请求错误提示方式，默认不提示 XSAPIAlertType_None
@property (nonatomic, assign) XSAPIAlertType        errorAlerType;


/// 用于解析接口返回数据的错误信息,用于XSAPIAlertType_Toast弹出错误信息
@property (nonatomic, strong) NSString              *errMessageKey;

/// 这里可以设置一个动态参数的方法，与setComparam不同的是，setComparam设置后，里面的key和value是不能改变的，除非你再调用setComparam方法，这个是每次请求都会调用一次生成参数的方法
/// 比如要在所有的请求都是一个时间戳参数，就可以这样：
/// 在你的某个类中写个实例方式：
/// - (NSDictionary *)generateParams {
///     return @{
///         @"time":@([[NSDate date] timeIntervalSince1970])
///     };
/// }
/// SEL sel = @selector(generateParams);
/// IMP imp = [self methodForSelector:sel];
/// 这样就得到了一个IMP,注意实例方法的返回一定要是NSDictionary，并且不能有参数
/// 返回值NSDictionary里面所有的key都会被家都请求里面的参数
/// 动态参数IMP
@property (nonatomic, assign) IMP                   dynamicParamsIMP;


/// 通用参数，每个请求都会加上
@property (nonatomic, strong) NSDictionary          *commonParameter;


/// 不需要加通用参数的URL
@property (nonatomic, strong) NSArray               *comParamExclude;

/// 设置返回数据的公共处理，比如服务器返回code==0算成功，就需要配置这个
/// errHander XSAPIResponseErrorHandler的子类，自己实现，如果是null，则不对返回数据进行处理，默认是XSAPIResponseErrorHandler
@property (nonatomic, strong) XSAPIResponseErrorHandler *errHander;


@property (nonatomic, strong) NSString              *developApiBaseUrl;
@property (nonatomic, strong) NSString              *prereleaseApiBaseUrl;
@property (nonatomic, strong) NSString              *releaseApiBaseUrl;

/// 自定义的URL，这个会落地缓存，重启后还会有，一般用于局网联调
@property (nonatomic, strong) NSString              *customApiBaseUrl;
@property (nonatomic, assign) XSEnvType             environmentType;
@property (nonatomic, strong) NSString              *publicKey;
@property (nonatomic, strong) NSString              *privateKey;

@property (nonatomic, strong, readonly) NSString    *apiBaseUrl;
@property (nonatomic, strong, readonly) NSString    *serverName;


-(instancetype)initWithServerName:(NSString *)serverName;

@end

NS_ASSUME_NONNULL_END
