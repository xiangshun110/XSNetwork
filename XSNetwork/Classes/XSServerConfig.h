//
//  XSServerConfig.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#ifndef XSServerConfig_h
#define XSServerConfig_h

#if (defined(DEBUG) || defined(ADHOC) || !defined YA_BUILD_FOR_RELEASE)
#define DELog(format, ...)  NSLog((@"FUNC:%s\n" "LINE:%d\n" format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DELog(format, ...)
#endif

//默认服务器名字
#define DefaultServerName      @"defaultName"
#define DefaultTimeout         25.0


#define NotiEnvChange          @"environmentTypeChange"


// 服务器类型，这个弃用了，用serverName代替，XSServiceMain就是DefaultServerName
typedef NS_ENUM(NSUInteger, XSServiceType) {
    XSServiceMain,      //主服务器
};


//请求方式
typedef NS_ENUM (NSUInteger, XSAPIRequestType){
    XSAPIRequestTypeGet,                 //get请求
    XSAPIRequestTypePost,                //POST请求
    XSAPIRequestTypePut,                 //PUT请求
    XSAPIRequestTypeDelete,              //DELETE请求
    XSAPIRequestTypeUpdate,              //UPDATE请求
    XSAPIRequestTypePostUpload,          //POST数据请求,传文件，formdata
    XSAPIRequestTypePostFormData,        //POST请求,multipart/form-data格式
    XSAPIRequestTypeGETDownload          //下载文件请求，不做返回值解析
};

//请求失败弹出样式
typedef NS_ENUM(NSInteger, XSAPIAlertType) {
    XSAPIAlertType_Unknown, //默认值，未设置
    XSAPIAlertType_None, //不弹出
    XSAPIAlertType_Toast //toast
};


/**
 *  开发、测试、预发、正式、HotFix和自定义环境,环境的切换是给开发人员和测试人员用的，对于外部正式打包不应该有环境切换的存在
 */
typedef NS_ENUM(NSUInteger,XSEnvType) {
    XSEnvTypeDevelop,
    XSEnvTypePreRelease,
    XSEnvTypeRelease,
    XSEnvTypeCustom,
};

//进度回调，用于上传和下载
typedef void (^ProgressBlock)(NSProgress * _Nonnull taskProgress);
//请求完成回调(包括成功和失败)
typedef void (^CompletionDataBlock)(id _Nullable data, NSError * _Nullable error);
//这个弃用了
typedef void (^ErrorAlertSelectIndexBlock)(NSUInteger buttonIndex);


typedef void(^HSResponseSuccessBlock)(NSDictionary * _Nullable responseObject);
typedef void(^HSResponseFailBlock)(NSError * _Nullable error);


#endif /* XSServerConfig_h */
