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
 *  网络请求参数
 */
@property (nonatomic, strong) NSString              *apiMethodPath;       //网络请求地址

//弃用了
@property (nonatomic, assign) XSServiceType         serviceType DEPRECATED_MSG_ATTRIBUTE("用serverName");          //服务器标识
@property (nonatomic, strong) NSDictionary          *parameters;          //请求参数
@property (nonatomic, assign) XSAPIRequestType      requestType;          //网络请求方式
@property (nonatomic, copy)   CompletionDataBlock   responseBlock;      //请求着陆回调

@property (nonatomic, assign) BOOL                  needBaseURL;          //是否需要baseURL

@property (nonatomic, strong) NSString              *dataFilePath;
@property (nonatomic, strong) NSURL                 *dataFileURL;
@property (nonatomic, strong) NSString              *dataName;
@property (nonatomic, strong) NSString              *fileName;
@property (nonatomic, strong) NSString              *mimeType;

// progressBlock
@property (nonatomic, copy) ProgressBlock           uploadProgressBlock;
@property (nonatomic, copy) ProgressBlock           downloadProgressBlock;

/// 要传的图片
@property (nonatomic, strong) UIImage               *image;


@property (nonatomic, strong) NSData                *bodyData;

/// 如果小于等于0，就用默认的kYANetworkingTimeoutSeconds
@property (nonatomic, assign) NSTimeInterval        requestTimeout;


/// 服务器名字
@property (nonatomic, strong) NSString              *serverName;

@end
