//
//  XSAPIClient.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSAPIBaseRequestDataModel.h"
#import "XSAPIResponseErrorHandler.h"
/**
 *   Client 负责 计算 request， 发起请求。做出回调,尽量不暴露 底层实现。比如 AF，NSSessionData
 */
@interface XSAPIClient : NSObject

+ (instancetype _Nonnull )sharedInstance;

/**
 *  根据dataModel发起网络请求，并根据dataModel发起回调
 *
 *
 *  @return 网络请求task哈希值
 */
- (NSNumber *_Nonnull)callRequestWithRequestModel:(XSAPIBaseRequestDataModel *_Nonnull)requestModel;

/**
 *  取消网络请求
 */
- (void)cancelRequestWithRequestID:(NSNumber *_Nonnull)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *_Nonnull)requestIDList;

- (void)setErrorHander:(XSAPIResponseErrorHandler *_Nullable)errHander DEPRECATED_MSG_ATTRIBUTE("这个放在了XSServerModel中，跟server走");

@end
