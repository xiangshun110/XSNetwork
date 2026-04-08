//
//  XSAPIClient.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSAPIClient.h"
#import "XSAPIURLRequestGenerator.h"
#import "XSAPIResponseErrorHandler.h"
#import "XSServerFactory.h"
#import <XSNetwork/XSNetwork-Swift.h>

@interface XSAPIClient()

@property (nonatomic, strong) XSAPIResponseErrorHandler *errHandler;

@end

@implementation XSAPIClient

#pragma mark - public methods

+ (instancetype)sharedInstance {
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

- (void)setErrorHander:(XSAPIResponseErrorHandler *)errHander {
    self.errHandler = errHander;
}

- (NSNumber *)callRequestWithRequestModel:(XSAPIBaseRequestDataModel *)requestModel {
    NSURLRequest *request = [[XSAPIURLRequestGenerator sharedInstance] generateWithRequestDataModel:requestModel];
    if (!request) {
        // URL generation failed; return a dummy ID and immediately fire the callback with an error.
        if (requestModel.responseBlock) {
            NSError *genError = [NSError errorWithDomain:NSURLErrorDomain
                                                    code:NSURLErrorBadURL
                                                userInfo:@{NSLocalizedDescriptionKey: @"Failed to build URLRequest"}];
            requestModel.responseBlock(nil, genError);
        }
        return @(-1);
    }

    typeof(self) __weak weakSelf = self;

    if (requestModel.requestType == XSAPIRequestTypeGETDownload) {
        return [[XSAlamofireSessionManager shared]
                startDownloadRequest:request
                progress:requestModel.downloadProgressBlock
                destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager]
                        URLForDirectory:NSDocumentDirectory
                        inDomain:NSUserDomainMask
                        appropriateForURL:nil
                        create:NO
                        error:nil];
                    NSString *fileName = [response suggestedFilename];
                    if (requestModel.fileName.length) {
                        fileName = requestModel.fileName;
                    }
                    return [documentsDirectoryURL URLByAppendingPathComponent:fileName];
                }
                completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    requestModel.responseBlock(filePath, error);
                }];
    }

    BOOL isUpload = (requestModel.requestType == XSAPIRequestTypePostUpload);
    return [[XSAlamofireSessionManager shared]
            startDataRequest:request
            uploadProgress:requestModel.uploadProgressBlock
            downloadProgress:requestModel.downloadProgressBlock
            isUpload:isUpload
            completion:^(NSURLResponse *response, id responseObject, NSError *error) {
                XSAPIResponseErrorHandler *errorHandler = nil;
                XSBaseServers *server = [[XSServerFactory sharedInstance] serviceWithName:requestModel.serverName];
                if (server.model) {
                    errorHandler = server.model.errHander;
                } else {
                    errorHandler = weakSelf.errHandler;
                }

                if (errorHandler) {
                    XSErrorHanderResult *xsResult = [errorHandler
                        errorHandlerWithRequestDataModel:requestModel
                        responseURL:response
                        responseObject:responseObject
                        error:error];
                    if (!xsResult.blockResponse) {
                        requestModel.responseBlock(responseObject, xsResult.error);
                    }
                } else {
                    requestModel.responseBlock(responseObject, error);
                }
            }];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    [[XSAlamofireSessionManager shared] cancelRequestWithID:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList {
    [[XSAlamofireSessionManager shared] cancelRequestsWithIDs:requestIDList];
}

@end
