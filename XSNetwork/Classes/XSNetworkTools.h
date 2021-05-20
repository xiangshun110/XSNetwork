//
//  NetworkTools.h
//  talkmed
//
//  Created by shun on 2018/4/12.
//  Copyright © 2018年 xiangshun. All rights reserved.
//  Version: 0.1.0

#import <Foundation/Foundation.h>
#import "XSBaseDataEngine.h"
#import "XSBaseServers.h"

@interface XSNetworkTools : NSObject


///// 获取group ID，用于和扩展程序之前共享数据
//+ (nullable NSString *)getAppSCGroupID;
//
///// 设置group ID，用于和扩展程序之前共享数据
///// @param appGroupID group id
//+ (void)setAppSCGroupID:(NSString * _Nonnull)appGroupID;
//
//
//
//+ (nullable NSString *)getAppVersion;
//+ (nullable NSString *)getPlatfrom;
//
//+ (nullable NSString *)getToken;
//+ (void)setToken:(nullable NSString *)token;
//
//+ (nullable NSString *)getUserID;


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


/// 切换开发环境, 如果你的URL都是带http的，可以不用设置，默认EnvironmentTypeRelease
/// @param environmentType 环境
+ (void)changeEnvironmentType:(EnvironmentType)environmentType;



/// 设置baseURL, 如果你的URL都是带http的，可以不用设置
/// @param release  对应EnvironmentTypeRelease
/// @param dev 对应EnvironmentTypeDevelop
/// @param preRelease 对应EnvironmentTypePreRelease
+ (void)setBaseURLWithRelease:(NSString *_Nullable)release dev:(NSString *_Nullable)dev preRelease:(NSString *_Nullable)preRelease;


/**
 *  如果参数是nil，返回@""
 *  @param str 要判断的字符串
 *  @return 返回str或者""
 */
+ (nullable NSString *)strOrEmpty:(nonnull NSString *)str;


typedef void(^HSResponseSuccessBlock)(NSDictionary * _Nullable responseObject);
typedef void(^HSResponseFailBlock)(NSError * _Nullable error);


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
 * @author  yuancan
 
 * @param relativePath 接口名称
 * @param params 请求参数
 * @param successBlock 请求成功回调
 * @param failBlock 请求失败回调
 */
+ (void)requestGET:(NSString *_Nonnull)relativePath params:(NSDictionary *_Nullable)params successBlock:(HSResponseSuccessBlock _Nullable )successBlock failBlock:(HSResponseFailBlock _Nullable )failBlock;

/**
 * @brief   原生POST请求方法
 * @author  yuancan
 
 * @param relativePath 接口名称
 * @param params 请求参数
 * @param successBlock 请求成功回调
 * @param failBlock 请求失败回调
 */
+ (void)requestPOST:(NSString *_Nonnull)relativePath params:(NSDictionary *_Nullable)params successBlock:(HSResponseSuccessBlock _Nullable)successBlock failBlock:(HSResponseFailBlock _Nullable)failBlock;

/**
 * @brief   原生JSON格式网络接口请求方法
 * @author  yuancan
 *
 * @param relativePath 接口名称
 * @param params 请求参数
 * @param successBlock 请求成功回调
 * @param failBlock 请求失败回调
 */
+ (void)requestJsonPost:(NSString *_Nonnull)relativePath params:(NSDictionary *_Nullable)params successBlock:(HSResponseSuccessBlock _Nullable)successBlock failBlock:(HSResponseFailBlock _Nullable)failBlock;

@end
