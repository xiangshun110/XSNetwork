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



/// 创建一个请求
/// @param control 宿主，宿主如果被销毁，请求会自动取消，一般是当前的VC
/// @param serverName 服务器名称，不同模块可能有不同的baseURL
/// @param path 请求URL，不带HTTP的话会自动加上baseURL
/// @param parameters 参数，默认nil
/// @param bodyData 放在httpBody里面的二进制数据，默认nil
/// @param dataFilePath 文件的本地完整路径，用于上传文件，默认nil
/// @param dataFileURL 文件的nsurl,用于上传文件，默认nil
/// @param image 图片数据，用于上传图片，默认nil
/// @param dataName 上传用，就是AFMultipartFormData appendPartWithFileURL中的的name，默认nil
/// @param fileName 上传用，就是AFMultipartFormData appendPartWithFileURL中的的fileName，默认nil
/// @param requestType 请求方式，比如get或者post
/// @param alertType 请求错误时的弹出框方式，默认不弹出
/// @param mimeType 上传用，就是AFMultipartFormData appendPartWithFileURL中的的mimeType，默认nil
/// @param timeout 超时时间，传0的话就使用默认值，默认25秒
/// @param loadingMsg 是否显示一个loading菊花，nil的话不显示
/// @param responseBlock 完成回调
/// @param uploadProgressBlock 上传进度回调
/// @param downloadProgressBlock 下载进度回调
/// @param errorButtonSelectIndexBlock 错误弹框选择按钮的回调
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

@end
