//
//  NetworkTools.h
//  talkmed
//
//  Created by shun on 2018/4/12.
//  Copyright © 2018年 xiangshun. All rights reserved.
//  Version: 0.1.4

#import <Foundation/Foundation.h>
#import "XSBaseDataEngine.h"
#import "XSBaseServers.h"
#import "XSAPIResponseErrorHandler.h"

@interface XSNetworkTools : NSObject

/// 获取公共参数
+ (nullable NSDictionary *)getComParam;

/// 设置公众参数
/// @param comParam     参数
+ (void)setComparam:(nullable NSDictionary *)comParam;


/// 获取不要加公共参数的URL
+ (nullable NSArray *)getComParamExclude;

/// 设置不要加公共参数的URL ,用的containsString检查，只要包含就算
/// @param comParamExclude     不要加公共参数的URL
+ (void)setComparamExclude:(nullable NSArray *)comParamExclude;


/// 切换开发环境, 如果你的URL都是带http的，可以不用设置，这个切换是存在NSUserDefaults里面的，默认EnvironmentTypeRelease
/// @param environmentType 环境
+ (void)changeEnvironmentType:(XSEnvType)environmentType;


/// 设置返回数据的公共处理，比如服务器返回code==0算成功，就需要配置这个
/// @param errHander XSAPIResponseErrorHandler的子类，自己实现，如果是null，则不对返回数据进行处理，默认是XSAPIResponseErrorHandler
+ (void)setErrorHander:(XSAPIResponseErrorHandler *_Nullable)errHander;


/// 设置baseURL, 如果你的URL都是带http的，可以不用设置
/// @param release  对应EnvironmentTypeRelease
/// @param dev 对应EnvironmentTypeDevelop
/// @param preRelease 对应EnvironmentTypePreRelease
+ (void)setBaseURLWithRelease:(NSString *_Nullable)release dev:(NSString *_Nullable)dev preRelease:(NSString *_Nullable)preRelease;


/// 设置请求超时时间
/// @param timeout 时间，默认是25秒
+ (void)setRequesTimeout:(NSTimeInterval)timeout;



/// 设置弹出toast的视图
/// @param view UIview
+ (void)setToastView:(UIView *_Nonnull)view;


/// 请求错误时弹出消息的方式,默认不弹出，XSAPIAlertType_None
/// @param errorAlerType type
+ (void)setErrorAlerType:(XSAPIAlertType)errorAlerType;


/// 设置获取错误消息的key,默认是message
/// @param messageKey keu
+ (void)setErrorMessageKey:(NSString *_Nonnull)messageKey;

/**
 *  如果参数是nil，返回@""
 *  @param str 要判断的字符串
 *  @return 返回str或者""
 */
+ (nullable NSString *)strOrEmpty:(nonnull NSString *)str;


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
/// @param imp imp
+ (void)setDynamicParamsIMP:(IMP _Nonnull )imp;


typedef void(^HSResponseSuccessBlock)(NSDictionary * _Nullable responseObject);
typedef void(^HSResponseFailBlock)(NSError * _Nullable error);



/**
 网络请求

 @param control self
 @param param 参数
 @param path URL
 @param requestType YAAPIManagerRequestTypeGet/YAAPIManagerRequestTypePost
 @param loadingMsg 不为nil的话会显示一个loading,请求完成后自动消失，loadingView显示在control的view上，如果control不是UIview和UIViewController，就不显示
 @param responseBlock 回调
 @return 返回
 */
+ (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType loadingMsg:(NSString * _Nonnull)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock;



/**
 网络请求

 @param control self
 @param param 参数
 @param path URL
 @param requestType YAAPIManagerRequestTypeGet/YAAPIManagerRequestTypePost
 @param responseBlock 回调
 @return 返回
 */
+ (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType complete:(CompletionDataBlock _Nullable)responseBlock;



/// 给body传一个nsdata
/// @param control self
/// @param bodyData nsdata
/// @param path path
/// @param requestType type
/// @param responseBlock 回调
+ (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control bodyData:(NSData * _Nullable)bodyData param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType complete:(CompletionDataBlock _Nullable)responseBlock;


/// 网络请求--可以设置超时，这个超时只影响这一个请求，不影响其他请求
/// @param control object
/// @param param 参数
/// @param path 请求URL
/// @param requestType YAAPIManagerRequestTypeGet/YAAPIManagerRequestTypePost
/// @param timeout 超时时间,0的话就是默认，默认是25秒（如果没设置）
/// @param responseBlock 回调
+ (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType timeout:(NSTimeInterval)timeout complete:(CompletionDataBlock _Nullable)responseBlock;

/// 上传文件
/// @param control self
/// @param param 参数
/// @param path URL
/// @param filePath 文件路径
/// @param fileKey 文件的的字段，服务端定义的
/// @param fileName 文件名
/// @param requestType ya upload
/// @param progress p
/// @param responseBlock c
+ (nullable XSBaseDataEngine *)uploadFile:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path filePath:(NSString *_Nonnull)filePath fileKey:(NSString *_Nonnull)fileKey fileName:(NSString *_Nonnull)fileName requestType:(XSAPIRequestType)requestType progress:(ProgressBlock _Nullable)progress complete:(CompletionDataBlock _Nullable)responseBlock;


/// 上传文件 NSURL方式
/// @param control self
/// @param param 参数
/// @param path URL
/// @param fileURL NSURL
/// @param fileKey 文件的的字段，服务端定义的
/// @param fileName 文件名
/// @param requestType ya upload
/// @param progress p
/// @param responseBlock c
+ (nullable XSBaseDataEngine *)uploadFile:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path fileURL:(NSURL * _Nonnull)fileURL fileKey:(NSString * _Nonnull)fileKey fileName:(NSString * _Nonnull)fileName requestType:(XSAPIRequestType)requestType progress:(ProgressBlock _Nullable)progress complete:(CompletionDataBlock _Nullable)responseBlock;



/**
 * @brief   原生GET请求方法  没有框架
 * @author  xiangshun
 
 * @param relativePath 接口名称
 * @param params 请求参数
 * @param successBlock 请求成功回调
 * @param failBlock 请求失败回调
 */
+ (void)requestGET:(NSString *_Nonnull)relativePath params:(NSDictionary *_Nullable)params successBlock:(HSResponseSuccessBlock _Nullable )successBlock failBlock:(HSResponseFailBlock _Nullable )failBlock;

/**
 * @brief   原生POST请求方法
 * @author  xiangshun
 
 * @param relativePath 接口名称
 * @param params 请求参数
 * @param successBlock 请求成功回调
 * @param failBlock 请求失败回调
 */
+ (void)requestPOST:(NSString *_Nonnull)relativePath params:(NSDictionary *_Nullable)params successBlock:(HSResponseSuccessBlock _Nullable)successBlock failBlock:(HSResponseFailBlock _Nullable)failBlock;

/**
 * @brief   原生JSON格式网络接口请求方法
 * @author  xiangshun
 *
 * @param relativePath 接口名称
 * @param params 请求参数
 * @param successBlock 请求成功回调
 * @param failBlock 请求失败回调
 */
+ (void)requestJsonPost:(NSString *_Nonnull)relativePath params:(NSDictionary *_Nullable)params successBlock:(HSResponseSuccessBlock _Nullable)successBlock failBlock:(HSResponseFailBlock _Nullable)failBlock;

@end
