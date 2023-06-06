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
#import "MBProgressHUD.h"
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
    NSData *imageData = nil;
    if (image) {
        imageData = UIImagePNGRepresentation(image);
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
    
    __block MBProgressHUD *hud = nil;
    if (loadingMsg && ([control isKindOfClass:[UIViewController class]] || [control isKindOfClass:[UIView class]])) {
        UIView *view = nil;
        if ([control isKindOfClass:[UIViewController class]]) {
            UIViewController *uivc = (UIViewController *)control;
            view = uivc.view;
        } else if ([control isKindOfClass:[UIView class]]) {
            view = (UIView *)control;
        }
        if (view) {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
                hud.contentColor = [UIColor whiteColor];
                if (loadingMsg.length) {
                    hud.label.text = loadingMsg;
                }
                hud.removeFromSuperViewOnHide = YES;
                hud.userInteractionEnabled = NO;
            });
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
                        UIView *view = nil;
                        if (server.model.toastView) {
                            view = server.model.toastView;
                        } else {
                            if ([weakControl isKindOfClass:[UIViewController class]]) {
                                UIViewController *vc = (UIViewController *)weakControl;
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
