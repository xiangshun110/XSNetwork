//
//  XSNet1.m
//  XSNetwork_Example
//
//  Created by shun on 2022/4/18.
//  Copyright © 2022 shun. All rights reserved.
//

#import "XSNet1.h"
#import "ErrorHandler1.h"
#import <CommonCrypto/CommonDigest.h>

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
    
    //公共参数，每次请求都会加上
    self.server.model.commonParameter = @{
        @"fuck":@"you"
    };
    
    //动态通用参数，每次请求都会执行一次，与commonParameter可以同时存在
    SEL sel = @selector(dynamicParams);
    IMP imp = [self methodForSelector:sel];
    self.server.model.dynamicParamsIMP = imp;
    
    //错误提示(统一配置)：
    self.server.model.errMessageKey = @"message";
    //如果单个请求中设置了，以单个请求优先
    self.server.model.errorAlerType = XSAPIAlertType_Toast;
    
    
    //公共header参数，每次请求都会加上
    self.server.model.commonHeaders = @{
        @"token":@"aaaaa123",
//        @"Content-Type":@"application/json"
    };
    
    
    //这个是用于把请求参数进行签名或者其他处理后放在header请求头里面
    SEL selHeader = NSSelectorFromString(@"dynamicParamsHeader:");
    IMP impHeader = [self methodForSelector:selHeader];
    self.server.model.headersWithRequestParamsIMP = impHeader;
}


/// 动态参数，每次请求都会执行一次
- (NSDictionary *)dynamicParams {
    return @{
        @"test_uuid":[[NSUUID UUID] UUIDString]
    };
}


///  处理请求参数，并放进请求头，这个方法每次都会执行一次
/// @param params 请求参数，这个里面包含commonParameter和dynamicParamsIMP返回的公用参数
- (NSDictionary *)dynamicParamsHeader:(NSDictionary *)params {
    NSString *str = [XSNet1 dataTOjsonString:params]; //注意这里的dataTOjsonString，因为IMP的目标方法体里面不能有self
    return @{
        @"sign" : [XSNet1 getMd5Str:str] //模拟加密
    };
}

+(NSString *)getMd5Str:(NSString *)str{
    // 判断传入的字符串是否为空
    if (! str) return nil;
    // 转成utf-8字符串
    const char *cStr = str.UTF8String;
    // 设置一个接收数组
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    // 对密码进行加密
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result);
    NSMutableString *md5Str = [NSMutableString string];
    // 转成32字节的16进制
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}

+ (NSString *)dataTOjsonString:(id)object{
    if (!object) {
        return nil;
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
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
