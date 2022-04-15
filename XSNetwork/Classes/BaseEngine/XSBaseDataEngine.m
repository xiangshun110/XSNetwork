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
#import "XSNetworkSingle.h"
#import "MBProgressHUD.h"

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
       callAPIWithServiceType:(XSServiceType)serviceType
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
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock {
    
    __weak typeof(control) weakControl = control;
    XSBaseDataEngine *engine = [[XSBaseDataEngine alloc] init];
    
    MBProgressHUD *hud = nil;
    if (loadingMsg && ([control isKindOfClass:[UIViewController class]] || [control isKindOfClass:[UIView class]])) {
        UIView *view = nil;
        if ([control isKindOfClass:[UIViewController class]]) {
            UIViewController *uivc = (UIViewController *)control;
            view = uivc.view;
        } else if ([control isKindOfClass:[UIView class]]) {
            view = (UIView *)control;
        }
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        hud.bezelView.color = [UIColor blackColor];
        hud.contentColor = [UIColor blackColor];
        if (loadingMsg.length) {
            hud.label.text = loadingMsg;
        }
        hud.removeFromSuperViewOnHide = YES;
        hud.userInteractionEnabled = NO;
    }
    
    XSAPIBaseRequestDataModel *dataModel = [engine dataModelWith:serviceType
                                                            path:path
                                                           param:parameters
                                                        bodyData:bodyData
                                                    dataFilePath:dataFilePath
                                                     dataFileURL:dataFileURL
                                                           image:image
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
                NSString *errKey = [XSNetworkSingle sharedInstance].errMessageKey;
                if (data[errKey]) {
                    emsg = data[errKey];
                }
                switch (alertType) {
                    case XSAPIAlertType_Toast:
                    {
                        UIView *view = nil;
                        if ([XSNetworkSingle sharedInstance].toastView) {
                            view = [XSNetworkSingle sharedInstance].toastView;
                        } else {
                            if ([control isKindOfClass:[UIViewController class]]) {
                                UIViewController *vc = (UIViewController *)control;
                                view = vc.view;
                            }
                        }
                        if (view) {
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.label.text = emsg;
                            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                            [hud hideAnimated:YES afterDelay:2.f];
                        }
                    }
                        break;
//                    case XSAPIAlertType_Alert:
//                    case XSAPIAlertType_ErrorView:
//                    {
//                        
//                    }
//                        break;
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


+ (XSBaseDataEngine *)control:(NSObject *)control
       callAPIWithServiceType:(XSServiceType)serviceType
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
                     complete:(CompletionDataBlock)responseBlock
          uploadProgressBlock:(ProgressBlock)uploadProgressBlock
        downloadProgressBlock:(ProgressBlock)downloadProgressBlock
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock {
    return [XSBaseDataEngine control:control callAPIWithServiceType:serviceType path:path param:parameters bodyData:bodyData dataFilePath:dataFilePath dataFileURL:dataFileURL image:image dataName:dataName fileName:fileName requestType:requestType alertType:alertType mimeType:mimeType timeout:timeout loadingMsg:nil complete:responseBlock uploadProgressBlock:uploadProgressBlock downloadProgressBlock:downloadProgressBlock errorButtonSelectIndex:errorButtonSelectIndexBlock];
}


/// get/post
+ (XSBaseDataEngine *)control:(NSObject *)control
       callAPIWithServiceType:(XSServiceType)serviceType
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                  requestType:(XSAPIRequestType)requestType
                    alertType:(XSAPIAlertType)alertType
                      timeout:(NSTimeInterval)timeout
                progressBlock:(ProgressBlock)progressBlock
                     complete:(CompletionDataBlock)responseBlock
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock {
    
    return [XSBaseDataEngine control:control callAPIWithServiceType:serviceType path:path param:parameters bodyData:nil dataFilePath:nil dataFileURL:nil image:nil dataName:nil fileName:nil requestType:requestType alertType:alertType mimeType:nil timeout:0 complete:responseBlock uploadProgressBlock:progressBlock downloadProgressBlock:nil errorButtonSelectIndex:errorButtonSelectIndexBlock];
}


/// get/post
+ (XSBaseDataEngine *)control:(NSObject *)control
       callAPIWithServiceType:(XSServiceType)serviceType
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                  requestType:(XSAPIRequestType)requestType
                    alertType:(XSAPIAlertType)alertType
                progressBlock:(ProgressBlock)progressBlock
                     complete:(CompletionDataBlock)responseBlock
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock {
    
    return [self control:control callAPIWithServiceType:serviceType path:path param:parameters requestType:requestType alertType:alertType timeout:0 progressBlock:progressBlock complete:responseBlock errorButtonSelectIndex:errorButtonSelectIndexBlock];
}

// upload/download
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
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock
{
    
    return [XSBaseDataEngine control:control callAPIWithServiceType:serviceType path:path param:parameters bodyData:nil dataFilePath:dataFilePath dataFileURL:nil image:image dataName:dataName fileName:fileName requestType:requestType alertType:alertType mimeType:mimeType timeout:0 complete:responseBlock uploadProgressBlock:uploadProgressBlock downloadProgressBlock:downloadProgressBlock errorButtonSelectIndex:errorButtonSelectIndexBlock];
}


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
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock
{
    return [XSBaseDataEngine control:control callAPIWithServiceType:serviceType path:path param:parameters bodyData:nil dataFilePath:nil dataFileURL:dataFileURL image:image dataName:dataName fileName:fileName requestType:requestType alertType:alertType mimeType:mimeType timeout:0 complete:responseBlock uploadProgressBlock:uploadProgressBlock downloadProgressBlock:downloadProgressBlock errorButtonSelectIndex:errorButtonSelectIndexBlock];
}





// upload/download
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
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock
{
    
    return [XSBaseDataEngine control:control callAPIWithServiceType:serviceType path:path param:parameters bodyData:nil dataFilePath:dataFilePath dataFileURL:nil image:nil dataName:dataName fileName:fileName requestType:requestType alertType:alertType mimeType:mimeType timeout:0 complete:responseBlock uploadProgressBlock:uploadProgressBlock downloadProgressBlock:downloadProgressBlock errorButtonSelectIndex:errorButtonSelectIndexBlock];
}

#pragma mark - UITableViewDelegate
#pragma mark - CustomDelegate
#pragma mark - event response
#pragma mark - private methods
- (XSAPIBaseRequestDataModel *)dataModelWith:(XSServiceType)serviceType
                                        path:(NSString *)path
                                       param:(NSDictionary *)parameters
                                    bodyData:(NSData *)bodyData
                                dataFilePath:(NSString *)dataFilePath
                                 dataFileURL:(NSURL *)dataFileURL
                                       image:(UIImage *)image
                                    dataName:(NSString *)dataName
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                 requestType:(XSAPIRequestType)requestType
                         uploadProgressBlock:(ProgressBlock)uploadProgressBlock
                       downloadProgressBlock:(ProgressBlock)downloadProgressBlock
                                    complete:(CompletionDataBlock)responseBlock
{
    XSAPIBaseRequestDataModel *dataModel = [[XSAPIBaseRequestDataModel alloc]init];
    dataModel.serviceType = serviceType;
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
    dataModel.image = image;
    dataModel.bodyData = bodyData;
    return dataModel;
}

- (void)callRequestWithRequestModel:(XSAPIBaseRequestDataModel *)dataModel control:(NSObject *)control{
    self.requestID = [[XSAPIClient sharedInstance] callRequestWithRequestModel:dataModel];
    [control.networkingAutoCancelRequests setEngine:self requestID:self.requestID];
}
#pragma mark - getters and setters
@end
