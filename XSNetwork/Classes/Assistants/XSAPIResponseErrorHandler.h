//
//  YAAPIResponseErrorHandler.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSAPIBaseRequestDataModel.h"
@interface XSAPIResponseErrorHandler : NSObject
//- (void)errorHandlerWithRequestDataModel:(XSAPIBaseRequestDataModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error errorHandler:(void(^)(NSError *newError))errorHandler;


/// 对返回数据进行自定义逻辑处理
/// @param requestDataModel 请求的数据
/// @param responseURL 请求的URL
/// @param responseObject  返回的数据
/// @param error 返回的错误
- (NSError *)errorHandlerWithRequestDataModel:(XSAPIBaseRequestDataModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error;
@end
