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
+ (void)errorHandlerWithRequestDataModel:(XSAPIBaseRequestDataModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error errorHandler:(void(^)(NSError *newError))errorHandler{
    if (error) {
        if (errorHandler) {
             errorHandler(error);
        }
        //API错误上报
//        [YAAPIResponseErrorHandler apiErrorReportWithPath:requestDataModel.apiMethodPath parm:requestDataModel.parameters msg:error];
    } else {
        NSInteger errorCode = 200;
        NSString *message = @"网络错误";
        if (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]]) {
            errorCode = -800;
        } else {
            if([responseObject isKindOfClass:[NSDictionary class]]){
                errorCode=[[responseObject objectForKey:@"code"] intValue];
            }
            //其他的错误解析逻辑，包含重新暂时不返回回调重新发起网络请求
            //注意只修改errorCode和message就行了，下面会统一生成新的error
            //如果是重新发起网络请求，发起网络请求后就直接return，不再执行下面的逻辑
        }
        
        if (errorCode != 0) {
            if([responseObject isKindOfClass:[NSDictionary class]]){
                message = responseObject[@"message"];
            }
            //统一生成新的error
            if(message){
                error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:message,@"data":responseObject?responseObject:@{},@"URL":responseURL.URL.absoluteString}];
            }
            if (errorHandler) {
                errorHandler(error);
            }
            if (errorCode==200203){
                //accesstoken过期||accesstoken错误
//                [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_REFRESH_TOKEN_FAILED object:nil];
            }
//            [YAAPIResponseErrorHandler apiErrorReportWithPath:requestDataModel.apiMethodPath parm:requestDataModel.parameters msg:error];
        } else {
            if (errorHandler) {
                errorHandler(nil);
            }
        }
    }
}

//+ (void)apiErrorReportWithPath:(NSString *)path parm:(NSDictionary *)parm msg:(NSError *)error{
//    NSMutableDictionary *dd=[NSMutableDictionary new];
//    if(path){
//        [dd setObject:[XSNetworkTools strOrEmpty:path] forKey:@"path"];
//    }
//    if(error){
//        NSMutableDictionary *errDic = [NSMutableDictionary new];
//        [errDic setValue:@(error.code) forKey:@"errorCode"];
//        [errDic setValue:[XSNetworkTools strOrEmpty:error.localizedFailureReason] forKey:@"localizedFailureReason"];
//
////        #ifndef TALKMED_MAIN_APP
////            AppDelegate *adele = (AppDelegate *)[UIApplication sharedApplication].delegate;
////            [errDic setValue:@(adele.netStatus) forKey:@"netStatus"];
////        #endif
//
//        [dd setObject:errDic forKey:@"content"];
//    }
//
//    NSMutableDictionary *parms=[NSMutableDictionary new];
//    NSDictionary *commonParma = [XSCommonParamsGenerator commonParamsDictionary];
//    [parms addEntriesFromDictionary:commonParma];
//    if(parm){
//        [parms addEntriesFromDictionary:parm];
//    }
//    [dd setObject:parms forKey:@"param"];
//
//    [dd setObject:[XSNetworkTools getAppVersion] forKey:@"appversion"];
//    [dd setObject:[XSNetworkTools getPlatfrom] forKey:@"platform"];
//
//
//    if([XSNetworkTools getUserID]){
//        [dd setObject:[XSNetworkTools getUserID] forKey:@"uasid"];
//    }
//
//
//    [NetworkTools requestPOST:API_ERROR_REPORT params:dd successBlock:^(NSDictionary *responseObject) {
//
//    } failBlock:^(NSError *error) {
//
//    }];
//}

@end
