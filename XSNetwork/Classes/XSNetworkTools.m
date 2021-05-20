//
//  NetworkTools.m
//  talkmed
//
//  Created by shun on 2018/4/12.
//  Copyright © 2018年 xiangshun. All rights reserved.
//

#import "XSNetworkTools.h"
#import <UIKit/UIKit.h>
#import "XSServerFactory.h"
#import "XSMainServer.h"

static NSString *accessToken = nil;
static NSString *platfrom = nil;
static NSString *scgroupID = nil;

//通用参数
static NSDictionary *commonParameter = nil;

//不需要加通用参数的URL
static NSArray *comParamExcludes = nil;

@implementation XSNetworkTools

/// 获取group ID
+ (nullable NSString *)getAppSCGroupID {
    return scgroupID;
}

/// 设置group ID
/// @param appGroupID group id
+ (void)setAppSCGroupID:(NSString * _Nonnull)appGroupID {
    scgroupID = appGroupID;
}


/// 获取公共参数
+ (nullable NSDictionary *)getComParam {
    return commonParameter;
}

/// 设置公众参数
/// @param comParam     参数
+ (void)setComparam:(nullable NSDictionary *)comParam {
    commonParameter = comParam;
}


/// 获取不要加公共参数的URL
+ (nullable NSArray *)getComParamExclude {
    return comParamExcludes;
}

/// 设置不要加公共参数的URL
/// @param comParamExclude     不要加公共参数的URL
+ (void)setComparamExclude:(nullable NSArray *)comParamExclude {
    comParamExcludes = comParamExclude;
}

+ (void)changeEnvironmentType:(EnvironmentType)environmentType {
    [XSServerFactory changeEnvironmentType:environmentType];
}

+ (void)setBaseURLWithRelease:(NSString *_Nullable)release dev:(NSString *_Nullable)dev preRelease:(NSString *_Nullable)preRelease {
    [XSMainServer setBaseURLWithRelease:release dev:dev preRelease:preRelease];
}


//+ (nullable NSString *)getAppVersion{
//    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//}
//
//+ (nullable NSString *)getPlatfrom{
//    if(!platfrom) {
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//            platfrom = @"ios";
//        }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//            platfrom = @"ipad";
//        }else{
//            platfrom = @"unknown";
//        }
//    }
//    return platfrom;
//}
//
//+ (nullable NSString *)getToken{
//    if(accessToken) {
//        return accessToken;
//    }
//    NSString *token;
//    token = [[NSUserDefaults standardUserDefaults] valueForKey:@"Accesstoken"];
//    if(!token && scgroupID){
//        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:scgroupID];
//        token = [userDefaults valueForKey:@"Accesstoken"];
//    }
//    accessToken = token;
//    return token;
//}
//
//
//+ (void)setToken:(nullable NSString *)token {
//    accessToken = token;
//    NSUserDefaults *userDefaults = nil;
//    if (scgroupID) {
//        userDefaults = [[NSUserDefaults alloc] initWithSuiteName:scgroupID];
//    }
//    if (token) {
//        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"Accesstoken"];
//        if (userDefaults) {
//            [userDefaults setValue:token forKey:@"Accesstoken"];
//        }
//    } else {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Accesstoken"];
//        if (userDefaults) {
//            [userDefaults removeObjectForKey:@"Accesstoken"];
//        }
//    }
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    if (userDefaults) {
//        [userDefaults synchronize];
//    }
//}
//
//+ (nullable NSString *)getUserID{
//    NSString *platfrom;
//    platfrom=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
//    return platfrom;
//}

+ (NSString *)strOrEmpty:(NSString *)str{
    return (str==nil||[str isKindOfClass:[NSNull class]]?@"":str);
}

+ (XSBaseDataEngine *)request:(NSObject *)control param:(NSDictionary *)param path:(NSString *)path requestType:(XSAPIRequestType)requestType complete:(CompletionDataBlock)responseBlock{
    return [XSBaseDataEngine control:control callAPIWithServiceType:XSServiceMain path:path param:param requestType:requestType alertType:XSAPIAlertType_None progressBlock:nil complete:responseBlock errorButtonSelectIndex:nil];
}

+ (XSBaseDataEngine *)uploadFile:(NSObject *)control param:(NSDictionary *)param path:(NSString *)path filePath:(NSString *)filePath fileKey:(NSString *)fileKey fileName:(NSString *)fileName requestType:(XSAPIRequestType)requestType progress:(ProgressBlock)progress complete:(CompletionDataBlock)responseBlock{

    return [XSBaseDataEngine control:control uploadAPIWithServiceType:XSServiceMain path:path param:param dataFilePath:filePath image:nil dataName:fileKey fileName:fileName mimeType:nil requestType:XSAPIRequestTypePostUpload alertType:XSAPIAlertType_None uploadProgressBlock:progress downloadProgressBlock:nil complete:responseBlock errorButtonSelectIndex:nil];
}

+ (XSBaseDataEngine *)uploadFile:(NSObject *)control param:(NSDictionary *)param path:(NSString *)path fileURL:(NSURL *)fileURL fileKey:(NSString *)fileKey fileName:(NSString *)fileName requestType:(XSAPIRequestType)requestType progress:(ProgressBlock)progress complete:(CompletionDataBlock)responseBlock {
    
    return [XSBaseDataEngine control:control uploadAPIWithServiceType:XSServiceMain path:path param:param dataFileURL:fileURL image:nil dataName:fileKey fileName:fileName mimeType:nil requestType:XSAPIRequestTypePostUpload alertType:XSAPIAlertType_None uploadProgressBlock:progress downloadProgressBlock:nil complete:responseBlock errorButtonSelectIndex:nil];
}


+ (void)requestHTTPMethod:(NSString *)httpMenthod relativePath:(NSString *)relativePath params:(NSDictionary *)params successBlock:(HSResponseSuccessBlock)successBlock failBlock:(HSResponseFailBlock)failBlock
{
    
    NSMutableString *paramsString = [[NSMutableString alloc] initWithCapacity:0];
    if(params) {
        for (int i=0;i<[params allKeys].count;i++) {
            NSString *key = [[params allKeys] objectAtIndex:i];
            [paramsString appendString:[NSString stringWithFormat:@"%@=%@",key,[params objectForKey:key]]];
            if (i < [params allKeys].count-1) {
                [paramsString appendString:@"&"];
            }
        }
    }
    
    NSString *urlString = relativePath;//[NSString stringWithFormat:@"%@%@", self.requestURL, relativePath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.timeoutInterval = 5;
    request.HTTPMethod = httpMenthod;
    request.HTTPBody = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (successBlock) {
                NSError *jserr  = nil;
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jserr];
                if(jserr){
                    if(failBlock) {
                        failBlock(jserr);
                    }
                }else{
                    successBlock(responseObject);
                }
            }
        } else {
            if (failBlock) {
                failBlock(error);
            }
        }
    }];
    [dataTask resume];
}

+ (void)requestGET:(NSString *)relativePath params:(NSDictionary *)params successBlock:(HSResponseSuccessBlock)successBlock failBlock:(HSResponseFailBlock)failBlock
{
    [self requestHTTPMethod:@"GET" relativePath:relativePath params:params successBlock:^(NSDictionary * _Nonnull responseObject) {
        if (successBlock) {
            return successBlock(responseObject);
        }
    } failBlock:^(NSError * _Nonnull error) {
        if (failBlock) {
            return failBlock(error);
        }
    }];
}

+ (void)requestPOST:(NSString *)relativePath params:(NSDictionary *)params successBlock:(HSResponseSuccessBlock)successBlock failBlock:(HSResponseFailBlock)failBlock
{
    [self requestHTTPMethod:@"POST" relativePath:relativePath params:params successBlock:^(NSDictionary * _Nonnull responseObject) {
        if (successBlock) {
            return successBlock(responseObject);
        }
    } failBlock:^(NSError * _Nonnull error) {
        if (failBlock) {
            return failBlock(error);
        }
    }];
}

+ (void)requestJsonPost:(NSString *)relativePath params:(NSDictionary *)params successBlock:(HSResponseSuccessBlock)successBlock failBlock:(HSResponseFailBlock)failBlock
{
    NSString *urlString = relativePath;//[NSString stringWithFormat:@"%@%@", self.requestURL, relativePath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 5;
    if(params) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    }
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (successBlock) {
                NSError *jserr  = nil;
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jserr];
                if(jserr){
                    if(failBlock) {
                        failBlock(jserr);
                    }
                }else{
                    successBlock(responseObject);
                }
            }
        } else {
            if (failBlock) {
                failBlock(error);
            }
        }
    }];
    [dataTask resume];
}

@end
