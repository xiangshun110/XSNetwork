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
//#import "MBProgressHUD+TMD.h"
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

/// get/post
+ (XSBaseDataEngine *)control:(NSObject *)control
       callAPIWithServiceType:(XSServiceType)serviceType
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                  requestType:(XSAPIRequestType)requestType
                    alertType:(XSAPIAlertType)alertType
                progressBlock:(ProgressBlock)progressBlock
                     complete:(CompletionDataBlock)responseBlock
       errorButtonSelectIndex:(ErrorAlertSelectIndexBlock)errorButtonSelectIndexBlock{
    XSBaseDataEngine *engine = [[XSBaseDataEngine alloc]init];
    __weak typeof(control) weakControl = control;
    XSAPIBaseRequestDataModel *dataModel = [engine dataModelWith:serviceType path:path param:parameters dataFilePath:nil image:nil dataName:nil fileName:nil mimeType:nil requestType:requestType uploadProgressBlock:progressBlock downloadProgressBlock:nil complete:^(id data, NSError *error) {
        if (responseBlock) {
            //可以在这里做错误的UI处理，或者是在上层engine做
            if(error){
                NSString *emsg=error.localizedDescription;
                if(data[@"error_msg"]){
                    emsg=data[@"error_msg"];
                }
                switch (alertType) {
                    case XSAPIAlertType_Toast:
                        //[MBProgressHUD showError:emsg];
                        break;
                    case XSAPIAlertType_Alert:
                    case XSAPIAlertType_ErrorView:
                    {
                        //[[XSSingleton getInstance] showAlertWithContent:emsg];
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
    
    if ([path hasPrefix:@"http"]) {
        dataModel.needBaseURL = NO;
    } else {
        dataModel.needBaseURL = YES;
    }
    
    [engine callRequestWithRequestModel:dataModel control:control];
    return engine;
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
    XSBaseDataEngine *engine = [[XSBaseDataEngine alloc]init];
    __weak typeof(control) weakControl = control;
    XSAPIBaseRequestDataModel *dataModel = [engine dataModelWith:serviceType path:path param:parameters dataFilePath:dataFilePath image:image dataName:dataName fileName:fileName mimeType:mimeType requestType:requestType uploadProgressBlock:uploadProgressBlock downloadProgressBlock:downloadProgressBlock complete:^(id data, NSError *error) {
        if (responseBlock) {
            //可以在这里做错误的UI处理，或者是在上层engine做
            responseBlock(data,error);
        }
        [weakControl.networkingAutoCancelRequests removeEngineWithRequestID:engine.requestID];
    }];
    if([path hasPrefix:@"http"]){
        dataModel.needBaseURL=NO;
    }else{
        dataModel.needBaseURL=YES;
    }
    [engine callRequestWithRequestModel:dataModel control:control];
    return engine;
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
    XSBaseDataEngine *engine = [[XSBaseDataEngine alloc]init];
    __weak typeof(control) weakControl = control;
    XSAPIBaseRequestDataModel *dataModel = [engine dataModelWith:serviceType path:path param:parameters dataFileURL:dataFileURL image:image dataName:dataName fileName:fileName mimeType:mimeType requestType:requestType uploadProgressBlock:uploadProgressBlock downloadProgressBlock:downloadProgressBlock complete:^(id data, NSError *error) {
        if (responseBlock) {
            //可以在这里做错误的UI处理，或者是在上层engine做
            responseBlock(data,error);
        }
        [weakControl.networkingAutoCancelRequests removeEngineWithRequestID:engine.requestID];
    }];
    if([path hasPrefix:@"http"]){
        dataModel.needBaseURL=NO;
    }else{
        dataModel.needBaseURL=YES;
    }
    [engine callRequestWithRequestModel:dataModel control:control];
    return engine;
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
    XSBaseDataEngine *engine = [[XSBaseDataEngine alloc]init];
    __weak typeof(control) weakControl = control;
    XSAPIBaseRequestDataModel *dataModel = [engine dataModelWith:serviceType path:path param:parameters dataFilePath:dataFilePath dataName:dataName fileName:fileName mimeType:mimeType requestType:requestType uploadProgressBlock:uploadProgressBlock downloadProgressBlock:downloadProgressBlock complete:^(id data, NSError *error) {
        if (responseBlock) {
            //可以在这里做错误的UI处理，或者是在上层engine做
            responseBlock(data,error);
        }
        [weakControl.networkingAutoCancelRequests removeEngineWithRequestID:engine.requestID];
    }];
    if([path hasPrefix:@"http"]){
        dataModel.needBaseURL=NO;
    }else{
        dataModel.needBaseURL=YES;
    }
    [engine callRequestWithRequestModel:dataModel control:control];
    return engine;
}

#pragma mark - UITableViewDelegate
#pragma mark - CustomDelegate
#pragma mark - event response
#pragma mark - private methods
- (XSAPIBaseRequestDataModel *)dataModelWith:(XSServiceType)serviceType
                                        path:(NSString *)path
                                       param:(NSDictionary *)parameters
                                dataFilePath:(NSString *)dataFilePath
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
    dataModel.dataName = dataName;
    dataModel.fileName=fileName;
    dataModel.mimeType = mimeType;
    dataModel.requestType = requestType;
    dataModel.uploadProgressBlock = uploadProgressBlock;
    dataModel.downloadProgressBlock = downloadProgressBlock;
    dataModel.responseBlock = responseBlock;
    dataModel.image=image;
    return dataModel;
}


- (XSAPIBaseRequestDataModel *)dataModelWith:(XSServiceType)serviceType
                                        path:(NSString *)path
                                       param:(NSDictionary *)parameters
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
    dataModel.dataFileURL = dataFileURL;
    dataModel.dataName = dataName;
    dataModel.fileName=fileName;
    dataModel.mimeType = mimeType;
    dataModel.requestType = requestType;
    dataModel.uploadProgressBlock = uploadProgressBlock;
    dataModel.downloadProgressBlock = downloadProgressBlock;
    dataModel.responseBlock = responseBlock;
    dataModel.image=image;
    return dataModel;
}

- (XSAPIBaseRequestDataModel *)dataModelWith:(XSServiceType)serviceType
                                        path:(NSString *)path
                                       param:(NSDictionary *)parameters
                                dataFilePath:(NSString *)dataFilePath
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
    dataModel.dataName = dataName;
    dataModel.fileName=fileName;
    dataModel.mimeType = mimeType;
    dataModel.requestType = requestType;
    dataModel.uploadProgressBlock = uploadProgressBlock;
    dataModel.downloadProgressBlock = downloadProgressBlock;
    dataModel.responseBlock = responseBlock;
    return dataModel;
}

- (void)callRequestWithRequestModel:(XSAPIBaseRequestDataModel *)dataModel control:(NSObject *)control{
    self.requestID = [[XSAPIClient sharedInstance] callRequestWithRequestModel:dataModel];
    [control.networkingAutoCancelRequests setEngine:self requestID:self.requestID];
}
#pragma mark - getters and setters
@end
