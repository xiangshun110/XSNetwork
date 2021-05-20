//
//  YABaseDataEngine.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSServerConfig.h"
#import <UIKit/UIKit.h>
@interface XSBaseDataEngine : NSObject
/**
 *  取消self持有的hash的网络请求
 */
- (void)cancelRequest;

/**
 *  下面的区分get/post/upload/download只是为了上层Engine调用方便，实现都是一样的
 */

/// get/post
+ (XSBaseDataEngine *)control:(NSObject *)control
       callAPIWithServiceType:(XSServiceType)serviceType
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                  requestType:(XSAPIRequestType)requestType
                    alertType:(XSAPIAlertType)alertType
                progressBlock:(ProgressBlock)progressBlock
                     complete:(CompletionDataBlock)responseBlock
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;

// upload
+ (XSBaseDataEngine *)control:(NSObject *)control
     uploadAPIWithServiceType:(XSServiceType)serviceType
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                 dataFilePath:(NSString *)dataFilePath
                        image:(UIImage *)image
                     dataName:(NSString *)dataName
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                  requestType:(XSAPIRequestType)requestType
                    alertType:(XSAPIAlertType)alertType
          uploadProgressBlock:(ProgressBlock)uploadProgressBlock
        downloadProgressBlock:(ProgressBlock)downloadProgressBlock
                     complete:(CompletionDataBlock)responseBlock
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;


+ (XSBaseDataEngine *)control:(NSObject *)control
     uploadAPIWithServiceType:(XSServiceType)serviceType
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                  dataFileURL:(NSURL *)dataFileURL
                        image:(UIImage *)image
                     dataName:(NSString *)dataName
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                  requestType:(XSAPIRequestType)requestType
                    alertType:(XSAPIAlertType)alertType
          uploadProgressBlock:(ProgressBlock)uploadProgressBlock
        downloadProgressBlock:(ProgressBlock)downloadProgressBlock
                     complete:(CompletionDataBlock)responseBlock
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;


+ (XSBaseDataEngine *)control:(NSObject *)control
     uploadAPIWithServiceType:(XSServiceType)serviceType
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                 dataFilePath:(NSString *)dataFilePath
                     dataName:(NSString *)dataName
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                  requestType:(XSAPIRequestType)requestType
                    alertType:(XSAPIAlertType)alertType
          uploadProgressBlock:(ProgressBlock)uploadProgressBlock
        downloadProgressBlock:(ProgressBlock)downloadProgressBlock
                     complete:(CompletionDataBlock)responseBlock
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;

// download
@end
