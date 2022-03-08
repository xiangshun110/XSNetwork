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

typedef NS_ENUM(NSUInteger, XSServiceType) {
    XSServiceMain,      //主服务器
};

typedef NS_ENUM (NSUInteger, XSAPIRequestType){
    XSAPIRequestTypeGet,                 //get请求
    XSAPIRequestTypePost,                //POST请求
    XSAPIRequestTypePut,                 //PUT请求
    XSAPIRequestTypeDelete,              //DELETE请求
    XSAPIRequestTypeUpdate,              //UPDATE请求
    XSAPIRequestTypePostUpload,          //POST数据请求
    XSAPIRequestTypeGETDownload          //下载文件请求，不做返回值解析
};

typedef NS_ENUM(NSInteger, XSAPIAlertType) {
    XSAPIAlertType_None,
    XSAPIAlertType_Toast,
//    XSAPIAlertType_Alert,
//    XSAPIAlertType_ErrorView
};

typedef void (^ProgressBlock)(NSProgress *taskProgress);
typedef void (^CompletionDataBlock)(id data, NSError *error);
typedef void (^ErrorAlertSelectIndexBlock)(NSUInteger buttonIndex);


#endif /* XSServerConfig_h */
