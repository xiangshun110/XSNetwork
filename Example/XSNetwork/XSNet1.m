//
//  XSNet1.m
//  XSNetwork_Example
//
//  Created by shun on 2022/4/18.
//  Copyright © 2022 shun. All rights reserved.
//

#import "XSNet1.h"
#import "ErrorHandler1.h"

@implementation XSNet1

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    static XSNet1 *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSNet1 alloc] init];
        [sharedInstance config];
    });
    return sharedInstance;
}

- (NSString *)serverName {
    return @"XSNet1";
}

- (void)config {
    //配置baseURL，最好是配置，不然每次请求都要写全量url
    self.server.model.releaseApiBaseUrl = @"https://apimeeting.talkmed.com";
    self.server.model.developApiBaseUrl = @"https://devapimeeting.talkmed.com";
    
    //自定义错误处理逻辑
    self.server.model.errHander = [ErrorHandler1 new];
    
    //通用参数
    self.server.model.commonParameter = @{
        @"fuck":@"you"
    };
    
    //动态通用参数：
    SEL sel = @selector(dynamicParams);
    IMP imp = [self methodForSelector:sel];
    self.server.model.dynamicParamsIMP = imp;
    
    //错误提示(统一配置)：
    self.server.model.errMessageKey = @"message";
    //如果单个请求中设置了，以单个请求优先
    self.server.model.errorAlerType = XSAPIAlertType_Toast;
    
    
    self.server.model.commonHeaders = @{
        @"token":@"aaaaa123"
    };
}

- (NSDictionary *)dynamicParams {
    return @{
        @"test_uuid":[[NSUUID UUID] UUIDString]
    };
}


- (nullable XSBaseDataEngine *)hideErrorAlert:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType loadingMsg:(NSString * _Nonnull)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock {
    return [XSBaseDataEngine control:control serverName:[self serverName] path:path param:param bodyData:nil dataFilePath:nil dataFileURL:nil image:nil dataName:nil fileName:nil requestType:requestType alertType:XSAPIAlertType_None mimeType:nil timeout:0 loadingMsg:loadingMsg complete:responseBlock uploadProgressBlock:nil downloadProgressBlock:nil errorButtonSelectIndex:nil];
}


- (XSBaseDataEngine *)uploadImage:(NSObject *)control path:(NSString *)path image:(UIImage *)image params:(NSDictionary * _Nullable)params  dataName:(NSString *)dataName progress:(ProgressBlock)progress complete:(CompletionDataBlock _Nullable)responseBlock {
    
    return [XSBaseDataEngine control:control serverName:[self serverName] path:path param:params bodyData:nil dataFilePath:nil dataFileURL:nil image:image dataName:dataName fileName:@"img.png" requestType:XSAPIRequestTypePostUpload alertType:XSAPIAlertType_Unknown mimeType:@"image/png" timeout:0 loadingMsg:nil complete:responseBlock uploadProgressBlock:progress downloadProgressBlock:nil errorButtonSelectIndex:nil];
}


- (XSBaseDataEngine *)downloadImage:(NSObject *)control imgPath:(NSString *)imgPath progress:(ProgressBlock _Nullable)progress complete:(CompletionDataBlock)responseBlock {
    return [XSBaseDataEngine control:self serverName:[self serverName] path:imgPath param:nil bodyData:nil dataFilePath:nil dataFileURL:nil image:nil dataName:nil fileName:nil requestType:XSAPIRequestTypeGETDownload alertType:XSAPIAlertType_None mimeType:nil timeout:0 loadingMsg:nil complete:responseBlock uploadProgressBlock:nil downloadProgressBlock:progress errorButtonSelectIndex:nil];
}




@end
