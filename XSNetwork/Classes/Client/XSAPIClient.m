//
//  YAAPIClient.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSAPIClient.h"
#import "AFURLSessionManager.h"
#import "XSAPIURLRequestGenerator.h"
#import "XSAPIResponseErrorHandler.h"
#import "XSCustomResponseSerializer.h"

@interface XSAPIClient()

//AFNetworking stuff
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) AFURLSessionManager *uploadSessionManager;
// 根据 requestid，存放 task
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
// 根据 requestID，存放 requestModel
@property (nonatomic, strong) NSMutableDictionary *requestModelDict;



@property (nonatomic, strong) XSAPIResponseErrorHandler *errHandler;

@end
@implementation XSAPIClient
#pragma mark - life cycle
#pragma mark - public methods
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static XSAPIClient *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSAPIClient alloc] init];
        [sharedInstance initOther];
    });
    return sharedInstance;
}

- (void)initOther {
    self.errHandler = [XSAPIResponseErrorHandler new];
}

- (void)setErrorHander:(XSAPIResponseErrorHandler *_Nullable)errHander {
    self.errHandler = errHander;
}

/**
 *  根据dataModel发起网络请求，并根据dataModel发起回调
 *
 *
 *  @return 网络请求task哈希值
 */
- (NSNumber *)callRequestWithRequestModel:(XSAPIBaseRequestDataModel *)requestModel{
    NSURLRequest *request = [[XSAPIURLRequestGenerator sharedInstance] generateWithRequestDataModel:requestModel];
    typeof(self) __weak weakSelf = self;
    AFURLSessionManager *sessionManager;
    NSNumber *requestID;
    if (requestModel.requestType == XSAPIRequestTypeGETDownload || requestModel.requestType == XSAPIRequestTypePostUpload) {
        sessionManager = [self getUploadSessionManager];
    }else{
        sessionManager = [self getSessionManager];
    }
    if(requestModel.requestType == XSAPIRequestTypeGETDownload){
        __block NSURLSessionDownloadTask *dtask = [sessionManager downloadTaskWithRequest:request progress:requestModel.downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            //NSLog(@"下载完成====:%@，%@",filePath,error);
            requestModel.responseBlock(filePath, error);
        }];
        [dtask resume];
        requestID = [NSNumber numberWithUnsignedInteger:dtask.hash];
        [self.dispatchTable setObject:dtask forKey:requestID];
    }else{
        __block NSURLSessionDataTask *task = [sessionManager
                                      dataTaskWithRequest:request
                                      uploadProgress:requestModel.uploadProgressBlock
                                      downloadProgress:requestModel.downloadProgressBlock
                                      completionHandler:^(NSURLResponse * _Nonnull response,
                                                          id  _Nullable responseObject,
                                                          NSError * _Nullable error)
        {
            if (task.state == NSURLSessionTaskStateCanceling) {
                // 如果这个operation是被cancel的，那就不用处理回调了。
            } else {
                NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
                [weakSelf.dispatchTable removeObjectForKey:requestID];
                
                //在这里做网络错误的解析，只是整理成error(包含重新发起请求，比如重新获取签名后再次请求),不做任何UI处理(包含reload，常规reload不在这里处理)，
                //解析完成后通过调用requestModel.responseBlock进行回调
                if (weakSelf.errHandler) {
                    error = [weakSelf.errHandler errorHandlerWithRequestDataModel:requestModel responseURL:response responseObject:responseObject error:error];
                    
                }
                requestModel.responseBlock(responseObject, error);
            }
        }];
        [task resume];
        requestID = [NSNumber numberWithUnsignedInteger:task.hash];
        [self.dispatchTable setObject:task forKey:requestID];
    }
    return requestID;
}

/**
 *  取消网络请求
 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    NSURLSessionDataTask *task = [self.dispatchTable objectForKey:requestID];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList{
    typeof(self) __weak weakSelf = self;
    [requestIDList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *task = [weakSelf.dispatchTable objectForKey:obj];
        [task cancel];
    }];
    [self.dispatchTable removeObjectsForKeys:requestIDList];
}

#pragma mark - UITableViewDelegate
#pragma mark - CustomDelegate
#pragma mark - event response
#pragma mark - private methods
- (AFURLSessionManager *)getCommonSessionManager
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForResource = 15;
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return sessionManager;
}

- (AFURLSessionManager *)getNoTimeoutSessionManager
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForResource = 0;
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return sessionManager;
}

#pragma mark - getters and setters
- (AFURLSessionManager *)getSessionManager{
    if (_sessionManager == nil) {
        _sessionManager = [self getCommonSessionManager];
        _sessionManager.responseSerializer = [XSCustomResponseSerializer serializer];
        //_sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _sessionManager;
    
}
- (AFURLSessionManager *)getUploadSessionManager{
    if (_uploadSessionManager == nil) {
        _uploadSessionManager = [self getNoTimeoutSessionManager];
        _uploadSessionManager.responseSerializer = [XSCustomResponseSerializer serializer];
        //_sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _uploadSessionManager;
    
}
//- (AFURLSessionManager *)sessionManager
//{
//    if (_sessionManager == nil) {
//        _sessionManager = [self getCommonSessionManager];
//        _sessionManager.responseSerializer = [AFCustomResponseSerializer serializer];
//        //_sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//    }
//    return _sessionManager;
//}
- (NSMutableDictionary *)dispatchTable{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}
@end
