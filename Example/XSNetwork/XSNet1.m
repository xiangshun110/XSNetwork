//
//  XSNet1.m
//  XSNetwork_Example
//
//  Created by shun on 2022/4/18.
//  Copyright © 2022 shun. All rights reserved.
//

#import "XSNet1.h"

@implementation XSNet1

+ (instancetype)singleInstance
{
    static dispatch_once_t onceToken;
    static XSNet1 *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSNet1 alloc] init];
    });
    return sharedInstance;
}

- (NSString *)serverName {
    return @"XSNet1";
}


- (nullable XSBaseDataEngine *)hideErrorAlert:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType loadingMsg:(NSString * _Nonnull)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock {
    return [XSBaseDataEngine control:control serverName:[self serverName] path:path param:param bodyData:nil dataFilePath:nil dataFileURL:nil image:nil dataName:nil fileName:nil requestType:requestType alertType:XSAPIAlertType_None mimeType:nil timeout:0 loadingMsg:loadingMsg complete:responseBlock uploadProgressBlock:nil downloadProgressBlock:nil errorButtonSelectIndex:nil];
}

@end
