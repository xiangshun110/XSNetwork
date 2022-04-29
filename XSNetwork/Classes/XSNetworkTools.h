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

@protocol XSNetworkToolsProtocol <NSObject>

/// 服务器名字
- (NSString *_Nonnull)serverName;

@end

@interface XSNetworkTools : NSObject<XSNetworkToolsProtocol>

+ (instancetype _Nonnull )singleInstance;

@property (nonatomic, strong, readonly) XSBaseServers * _Nonnull server;



//---------------分割线-------------------

/// 网络请求 -- 常用的，get,post,update,delete
/// @param control control description
/// @param param 参数
/// @param path 路径
/// @param requestType 请求类型
/// @param loadingMsg 不为nil的话会显示一个loading,请求完成后自动消失，loadingView显示在control的view上，如果control不是UIview和UIViewController，就不显示
/// @param responseBlock 回调
- (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType loadingMsg:(NSString * _Nullable)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock;


/// GET请求
/// @param control control description
/// @param param 参数
/// @param path 路径
/// @param loadingMsg 不为nil的话会显示一个loading,请求完成后自动消失，loadingView显示在control的view上，如果control不是UIview和UIViewController，就不显示
/// @param responseBlock 回调
- (nullable XSBaseDataEngine *)getRequest:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path loadingMsg:(NSString * _Nullable)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock;


/// POST请求
/// @param control control description
/// @param param 参数
/// @param path 路径
/// @param loadingMsg 不为nil的话会显示一个loading,请求完成后自动消失，loadingView显示在control的view上，如果control不是UIview和UIViewController，就不显示
/// @param responseBlock 回调
- (nullable XSBaseDataEngine *)postRequest:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path loadingMsg:(NSString * _Nullable)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock;


/// 给body传一个nsdata
/// @param control self
/// @param bodyData nsdata
/// @param path path
/// @param responseBlock 回调
- (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control bodyData:(NSData * _Nullable)bodyData param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path complete:(CompletionDataBlock _Nullable)responseBlock;


/// 网络请求--可以设置超时，这个超时只影响这一个请求，不影响其他请求
/// @param control object
/// @param param 参数
/// @param path 请求URL
/// @param requestType YAAPIManagerRequestTypeGet/YAAPIManagerRequestTypePost
/// @param timeout 超时时间,0的话就是默认，默认是25秒（如果没设置）
/// @param responseBlock 回调
- (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType timeout:(NSTimeInterval)timeout complete:(CompletionDataBlock _Nullable)responseBlock;



/// 上传文件
/// @param control self
/// @param param 参数
/// @param path URL
/// @param fileURL 文件NSURL （fileURL和filePat二选一，如果都有，取fileURL）
/// @param filePath 文件路径 （fileURL和filePat二选一，如果都有，取fileURL）
/// @param fileKey 文件的的字段，服务端定义的
/// @param fileName 文件名
/// @param requestType ya upload
/// @param progress p
/// @param responseBlock c
- (nullable XSBaseDataEngine *)uploadFile:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path fileURL:(NSURL * _Nullable)fileURL filePath:(NSString *_Nullable)filePath fileKey:(NSString *_Nullable)fileKey fileName:(NSString *_Nullable)fileName requestType:(XSAPIRequestType)requestType progress:(ProgressBlock _Nullable)progress complete:(CompletionDataBlock _Nullable)responseBlock;

//--------



//-----------------下面是苹果原生请求，没有用AF框架，也不会带任何公用参数，所有的配置都对他们无效---------------------

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
