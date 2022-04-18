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


+ (XSBaseDataEngine *)control:(NSObject *)control
                   serverName:(NSString *)serverName
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                        bodyData:(NSData *)bodyData
                 dataFilePath:(NSString *)dataFilePath
                  dataFileURL:(NSURL *)dataFileURL
                        image:(UIImage *)image
                     dataName:(NSString *)dataName
                     fileName:(NSString *)fileName
                  requestType:(XSAPIRequestType)requestType
                    alertType:(XSAPIAlertType)alertType
                     mimeType:(NSString *)mimeType
                      timeout:(NSTimeInterval)timeout
                   loadingMsg:(NSString *)loadingMsg
                     complete:(CompletionDataBlock)responseBlock
          uploadProgressBlock:(ProgressBlock)uploadProgressBlock
        downloadProgressBlock:(ProgressBlock)downloadProgressBlock
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;


//+ (XSBaseDataEngine *)control:(NSObject *)control
//       callAPIWithServiceType:(XSServiceType)serviceType
//                         path:(NSString *)path
//                        param:(NSDictionary *)parameters
//                        bodyData:(NSData *)bodyData
//                 dataFilePath:(NSString *)dataFilePath
//                  dataFileURL:(NSURL *)dataFileURL
//                        image:(UIImage *)image
//                     dataName:(NSString *)dataName
//                     fileName:(NSString *)fileName
//                  requestType:(XSAPIRequestType)requestType
//                    alertType:(XSAPIAlertType)alertType
//                     mimeType:(NSString *)mimeType
//                      timeout:(NSTimeInterval)timeout
//                   loadingMsg:(NSString *)loadingMsg
//                     complete:(CompletionDataBlock)responseBlock
//          uploadProgressBlock:(ProgressBlock)uploadProgressBlock
//        downloadProgressBlock:(ProgressBlock)downloadProgressBlock
//       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock DEPRECATED_MSG_ATTRIBUTE("用第一个方法，带serverName的");
//
//
//+ (XSBaseDataEngine *)control:(NSObject *)control
//       callAPIWithServiceType:(XSServiceType)serviceType
//                         path:(NSString *)path
//                        param:(NSDictionary *)parameters
//                        bodyData:(NSData *)bodyData
//                 dataFilePath:(NSString *)dataFilePath
//                  dataFileURL:(NSURL *)dataFileURL
//                        image:(UIImage *)image
//                     dataName:(NSString *)dataName
//                     fileName:(NSString *)fileName
//                  requestType:(XSAPIRequestType)requestType
//                    alertType:(XSAPIAlertType)alertType
//                     mimeType:(NSString *)mimeType
//                      timeout:(NSTimeInterval)timeout
//                     complete:(CompletionDataBlock)responseBlock
//          uploadProgressBlock:(ProgressBlock)uploadProgressBlock
//        downloadProgressBlock:(ProgressBlock)downloadProgressBlock
//       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;
//
//
///// get/post
//+ (XSBaseDataEngine *)control:(NSObject *)control
//       callAPIWithServiceType:(XSServiceType)serviceType
//                         path:(NSString *)path
//                        param:(NSDictionary *)parameters
//                  requestType:(XSAPIRequestType)requestType
//                    alertType:(XSAPIAlertType)alertType
//                      timeout:(NSTimeInterval)timeout
//                progressBlock:(ProgressBlock)progressBlock
//                     complete:(CompletionDataBlock)responseBlock
//       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;
//
///// get/post
//+ (XSBaseDataEngine *)control:(NSObject *)control
//       callAPIWithServiceType:(XSServiceType)serviceType
//                         path:(NSString *)path
//                        param:(NSDictionary *)parameters
//                  requestType:(XSAPIRequestType)requestType
//                    alertType:(XSAPIAlertType)alertType
//                progressBlock:(ProgressBlock)progressBlock
//                     complete:(CompletionDataBlock)responseBlock
//       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;
//
//// upload
//+ (XSBaseDataEngine *)control:(NSObject *)control
//     uploadAPIWithServiceType:(XSServiceType)serviceType
//                         path:(NSString *)path
//                        param:(NSDictionary *)parameters
//                 dataFilePath:(NSString *)dataFilePath
//                        image:(UIImage *)image
//                     dataName:(NSString *)dataName
//                     fileName:(NSString *)fileName
//                     mimeType:(NSString *)mimeType
//                  requestType:(XSAPIRequestType)requestType
//                    alertType:(XSAPIAlertType)alertType
//          uploadProgressBlock:(ProgressBlock)uploadProgressBlock
//        downloadProgressBlock:(ProgressBlock)downloadProgressBlock
//                     complete:(CompletionDataBlock)responseBlock
//       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;
//
//
//+ (XSBaseDataEngine *)control:(NSObject *)control
//     uploadAPIWithServiceType:(XSServiceType)serviceType
//                         path:(NSString *)path
//                        param:(NSDictionary *)parameters
//                  dataFileURL:(NSURL *)dataFileURL
//                        image:(UIImage *)image
//                     dataName:(NSString *)dataName
//                     fileName:(NSString *)fileName
//                     mimeType:(NSString *)mimeType
//                  requestType:(XSAPIRequestType)requestType
//                    alertType:(XSAPIAlertType)alertType
//          uploadProgressBlock:(ProgressBlock)uploadProgressBlock
//        downloadProgressBlock:(ProgressBlock)downloadProgressBlock
//                     complete:(CompletionDataBlock)responseBlock
//       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;
//
//
//+ (XSBaseDataEngine *)control:(NSObject *)control
//     uploadAPIWithServiceType:(XSServiceType)serviceType
//                         path:(NSString *)path
//                        param:(NSDictionary *)parameters
//                 dataFilePath:(NSString *)dataFilePath
//                     dataName:(NSString *)dataName
//                     fileName:(NSString *)fileName
//                     mimeType:(NSString *)mimeType
//                  requestType:(XSAPIRequestType)requestType
//                    alertType:(XSAPIAlertType)alertType
//          uploadProgressBlock:(ProgressBlock)uploadProgressBlock
//        downloadProgressBlock:(ProgressBlock)downloadProgressBlock
//                     complete:(CompletionDataBlock)responseBlock
//       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock;

@end
