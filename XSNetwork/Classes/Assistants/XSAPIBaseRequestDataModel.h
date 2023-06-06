//
//  YAAPIBaseRequestDataModel.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//
/**
 *  网络请求参数传递类，只在BaseEngine以下的层次传递使用
 */
#import <Foundation/Foundation.h>
#import "XSServerConfig.h"
#import <UIKit/UIKit.h>

@interface XSAPIBaseRequestDataModel : NSObject
/**
 *  请求地址
 */
@property (nonatomic, strong) NSString              *apiMethodPath;

/// 弃用了, 服务器标识
@property (nonatomic, assign) XSServiceType         serviceType DEPRECATED_MSG_ATTRIBUTE("用serverName");
/**
 请求参数
 */
@property (nonatomic, strong) NSDictionary          *parameters;
/**
 get post ...
 */
@property (nonatomic, assign) XSAPIRequestType      requestType;
/**
 callback
 */
@property (nonatomic, copy)   CompletionDataBlock   responseBlock;

/**
 是否需要baseURL
 */
@property (nonatomic, assign) BOOL                  needBaseURL;


/// 上传文件的完整路径
@property (nonatomic, strong) NSString              *dataFilePath;

/// 上传文件的nsurl
@property (nonatomic, strong) NSURL                 *dataFileURL;

/// 上传用，就是AFMultipartFormData appendPartWithFileURL中的的name，默认nil
@property (nonatomic, strong) NSString              *dataName;

/// 上传时，就是AFMultipartFormData appendPartWithFileURL中的的fileName，默认nil
/// 下载时，代表下载后存储在本地的文件名，可以带目录，比如: test/20150101/test.pdf，默认nil
@property (nonatomic, strong) NSString              *fileName;

@property (nonatomic, strong) NSString              *mimeType;

/// 上传的 progressBlock
@property (nonatomic, copy) ProgressBlock           uploadProgressBlock;

/// 下载进度
@property (nonatomic, copy) ProgressBlock           downloadProgressBlock;

/// 要传的图片
//@property (nonatomic, strong) UIImage               *image;
@property (nonatomic, strong) NSData               *imageData;

/// 
@property (nonatomic, strong) NSData                *bodyData;

/// 如果小于等于0，就用默认的kYANetworkingTimeoutSeconds
@property (nonatomic, assign) NSTimeInterval        requestTimeout;


/// 服务器名字
@property (nonatomic, strong) NSString              *serverName;

@end
