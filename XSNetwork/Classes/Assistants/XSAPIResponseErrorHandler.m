//
//  YAAPIResponseErrorHandler.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSAPIResponseErrorHandler.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "XSNetworkTools.h"
//#import "APPConfig.h"
//#import "XSCommonParamsGenerator.h"

@implementation XSAPIResponseErrorHandler
//- (void)errorHandlerWithRequestDataModel:(XSAPIBaseRequestDataModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error errorHandler:(void(^)(NSError *newError))errorHandler{
//    if (error) {
//        if (errorHandler) {
//             errorHandler(error);
//        }
//    } else {
//        NSInteger errorCode = 200;
//        NSString *message = @"网络错误";
//        if (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]]) {
//            errorCode = -800;
//        } else {
//            if([responseObject isKindOfClass:[NSDictionary class]]){
//                errorCode=[[responseObject objectForKey:@"code"] intValue];
//            }
//            //其他的错误解析逻辑，包含重新暂时不返回回调重新发起网络请求
//            //注意只修改errorCode和message就行了，下面会统一生成新的error
//            //如果是重新发起网络请求，发起网络请求后就直接return，不再执行下面的逻辑
//        }
//
//        if (errorCode != 0) {
//            if([responseObject isKindOfClass:[NSDictionary class]]){
//                message = responseObject[@"message"];
//            }
//            //统一生成新的error
//            if(message){
//                error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:message,@"data":responseObject?responseObject:@{},@"URL":responseURL.URL.absoluteString}];
//            }
//            if (errorHandler) {
//                errorHandler(error);
//            }
//        } else {
//            if (errorHandler) {
//                errorHandler(nil);
//            }
//        }
//    }
//}

- (XSErrorHanderResult *)errorHandlerWithRequestDataModel:(XSAPIBaseRequestDataModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error {
    
    XSErrorHanderResult *xsResult = [XSErrorHanderResult new];
    
    if (error) {
        xsResult.error = error;
        return xsResult;
    } else {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            int errorCode = [[responseObject objectForKey:@"code"] intValue];
            if (errorCode == 0) {
                return xsResult;
            } else {
                NSString *message = @"请求失败";
                if ([responseObject isKindOfClass:[NSDictionary class]]){
                    message = responseObject[@"message"];
                }
                NSError *newError = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:message,@"data":responseObject?responseObject:@{},@"URL":responseURL.URL.absoluteString}];
                
                xsResult.error = newError;
                return xsResult;
            }
        } else {
            xsResult.error = error;
            return xsResult;
        }
    }
}

@end
