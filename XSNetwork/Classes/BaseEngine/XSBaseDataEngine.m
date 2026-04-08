//
//  XSBaseDataEngine.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSBaseDataEngine.h"
#import "XSAPIBaseRequestDataModel.h"
#import "XSAPIClient.h"
#import "NSObject+XSNetWorkingAutoCancel.h"
#import "XSProgressHUD.h"
#import "XSServerFactory.h"

@interface XSBaseDataEngine ()

@property (nonatomic, strong) NSNumber *requestID;

@end
@implementation XSBaseDataEngine
#pragma mark - life cycle
- (void)dealloc{
    [self cancelRequest];
}
#pragma mark - public methods
/**
 *  取消self持有的hash的网络请求
 */
- (void)cancelRequest{
    [[XSAPIClient sharedInstance] cancelRequestWithRequestID:self.requestID];
}


+ (XSBaseDataEngine *)control:(NSObject *)control
                   serverName:(NSString *)serverName
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                        bodyData:(NSData *)bodyData
                 dataFilePath:(NSString *)dataFilePath
                  dataFileURL:(NSURL *)dataFileURL
                        image:(XSPlatformImage *)image
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
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock {
    NSData *imageData = nil;
    if (image) {
#if TARGET_OS_IPHONE
        imageData = UIImagePNGRepresentation(image);
#else
        CGImageRef cgImage = [image CGImageForProposedRect:NULL context:nil hints:nil];
        NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
        imageData = [bitmapRep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
#endif
    }
    
    return [XSBaseDataEngine control:control serverName:serverName path:path param:parameters bodyData:bodyData dataFilePath:dataFilePath dataFileURL:dataFileURL imageData:imageData dataName:dataName fileName:fileName requestType:requestType alertType:alertType mimeType:mimeType timeout:timeout loadingMsg:loadingMsg complete:responseBlock uploadProgressBlock:uploadProgressBlock downloadProgressBlock:downloadProgressBlock errorButtonSelectIndex:errorButtonSelectIndexBlock];
}


+ (XSBaseDataEngine *)control:(NSObject *)control
                   serverName:(NSString *)serverName
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                        bodyData:(NSData *)bodyData
                 dataFilePath:(NSString *)dataFilePath
                  dataFileURL:(NSURL *)dataFileURL
                    imageData:(NSData *)imageData
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
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock {
    
    __weak typeof(control) weakControl = control;
    XSBaseDataEngine *engine = [[XSBaseDataEngine alloc] init];
    
    XSBaseServers *server = [[XSServerFactory sharedInstance] serviceWithName:serverName];
    
    __block XSProgressHUD *hud = nil;
    if (loadingMsg) {
        XSPlatformView *view = nil;
#if TARGET_OS_IPHONE
        if ([control isKindOfClass:[UIViewController class]]) {
            view = ((UIViewController *)control).view;
        } else if ([control isKindOfClass:[UIView class]]) {
            view = (UIView *)control;
        }
#else
        if ([control isKindOfClass:[NSViewController class]]) {
            view = ((NSViewController *)control).view;
        } else if ([control isKindOfClass:[NSView class]]) {
            view = (NSView *)control;
        }
#endif
        if (view) {
            hud = [XSProgressHUD showLoadingInView:view message:loadingMsg];
        }
    }
    
    XSAPIBaseRequestDataModel *dataModel = [engine dataServerName:serverName
                                                            path:path
                                                           param:parameters
                                                        bodyData:bodyData
                                                    dataFilePath:dataFilePath
                                                     dataFileURL:dataFileURL
                                                           imageData:imageData
                                                        dataName:dataName
                                                        fileName:fileName
                                                        mimeType:mimeType
                                                     requestType:requestType
                                             uploadProgressBlock:uploadProgressBlock
                                           downloadProgressBlock:downloadProgressBlock
                                                        complete:^(id data, NSError *error) {
        if (hud) {
            [hud hideAnimated:YES];
        }
        
        if (responseBlock) {
            //可以在这里做错误的UI处理，或者是在上层engine做
            if (error) {
                NSString *emsg = error.localizedDescription;
                NSString *errKey = server.model.errMessageKey;
                
                if (data[errKey]) {
                    emsg = data[errKey];
                }
                
                
                XSAPIAlertType aType = alertType;
                
                if (aType == XSAPIAlertType_Unknown) {
                    aType = server.model.errorAlerType;
                }
                
                switch (aType) {
                    case XSAPIAlertType_Toast:
                    {
                        XSPlatformView *toastView = nil;
                        if (server.model.toastView) {
                            toastView = server.model.toastView;
                        } else {
#if TARGET_OS_IPHONE
                            if ([weakControl isKindOfClass:[UIViewController class]]) {
                                toastView = ((UIViewController *)weakControl).view;
                            }
#else
                            if ([weakControl isKindOfClass:[NSViewController class]]) {
                                toastView = ((NSViewController *)weakControl).view;
                            }
#endif
                        }
                        if (toastView) {
                            [XSProgressHUD showToast:emsg inView:toastView afterDelay:2.0];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
            responseBlock(data,error);
        }
        [weakControl.networkingAutoCancelRequests removeEngineWithRequestID:engine.requestID];
    }];
    
    if (timeout > 0) {
        dataModel.requestTimeout = timeout;
    }
    
    if ([path hasPrefix:@"http"]) {
        dataModel.needBaseURL = NO;
    } else {
        dataModel.needBaseURL = YES;
    }
    
    [engine callRequestWithRequestModel:dataModel control:control];
    return engine;
}





#pragma mark - UITableViewDelegate
#pragma mark - CustomDelegate
#pragma mark - event response

#pragma mark - private methods
- (XSAPIBaseRequestDataModel *)dataServerName:(NSString *)serverName
                                        path:(NSString *)path
                                       param:(NSDictionary *)parameters
                                    bodyData:(NSData *)bodyData
                                dataFilePath:(NSString *)dataFilePath
                                 dataFileURL:(NSURL *)dataFileURL
                                    imageData:(NSData *)imageData
                                    dataName:(NSString *)dataName
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                 requestType:(XSAPIRequestType)requestType
                         uploadProgressBlock:(ProgressBlock)uploadProgressBlock
                       downloadProgressBlock:(ProgressBlock)downloadProgressBlock
                                    complete:(CompletionDataBlock)responseBlock
{
    XSAPIBaseRequestDataModel *dataModel = [[XSAPIBaseRequestDataModel alloc]init];
    dataModel.serverName = serverName;
    dataModel.apiMethodPath = path;
    dataModel.parameters = parameters;
    dataModel.dataFilePath = dataFilePath;
    dataModel.dataFileURL = dataFileURL;
    dataModel.dataName = dataName;
    dataModel.fileName = fileName;
    dataModel.mimeType = mimeType;
    dataModel.requestType = requestType;
    dataModel.uploadProgressBlock = uploadProgressBlock;
    dataModel.downloadProgressBlock = downloadProgressBlock;
    dataModel.responseBlock = responseBlock;
    dataModel.imageData = imageData;
    dataModel.bodyData = bodyData;
    return dataModel;
}

- (void)callRequestWithRequestModel:(XSAPIBaseRequestDataModel *)dataModel control:(NSObject *)control{
    self.requestID = [[XSAPIClient sharedInstance] callRequestWithRequestModel:dataModel];
    [control.networkingAutoCancelRequests setEngine:self requestID:self.requestID];
}
#pragma mark - getters and setters
@end
