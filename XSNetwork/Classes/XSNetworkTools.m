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
#import "XSAPIClient.h"

//通用参数
static NSDictionary *commonParameter = nil;

//不需要加通用参数的URL
static NSArray *comParamExcludes = nil;

@interface XSNetworkTools()

@property (nonatomic, strong) XSBaseServers * _Nonnull  server;

@property (nonatomic, strong) UILabel                   *devEnvlabel;

@end

@implementation XSNetworkTools


+ (instancetype)singleInstance
{
   
    NSString *class = NSStringFromClass([self class]);
    
    NSAssert([class isEqualToString:@"XSNetworkTools"], @"子类请自行实现单例方法,或者自己new一个实例");
    
    static dispatch_once_t onceToken;
    static XSNetworkTools *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSNetworkTools alloc] init];
    });
    return sharedInstance;
}

#pragma mark private

- (void)netEnvChange:(NSNotification *)noti {
    switch (self.server.model.environmentType) {
        case XSEnvTypeRelease:
        {
            self.devEnvlabel.hidden = YES;
        }
            break;
        case XSEnvTypeDevelop:
        {
            self.devEnvlabel.hidden = NO;
            self.devEnvlabel.text = @"dev";
        }
            break;
        case XSEnvTypePreRelease:
        {
            self.devEnvlabel.hidden = NO;
            self.devEnvlabel.text = @"pre";
        }
            break;
        case XSEnvTypeCustom:
        {
            self.devEnvlabel.hidden = NO;
            self.devEnvlabel.text = @"cus";
        }
            break;
            
        default:
            break;
    }
}



#pragma mark getter


- (UILabel *)devEnvlabel {
    if (!_devEnvlabel) {
        _devEnvlabel = [UILabel new];
        _devEnvlabel.alpha = 0.8;
        _devEnvlabel.textColor = [UIColor blackColor];
        _devEnvlabel.font = [UIFont systemFontOfSize:10];
        _devEnvlabel.textAlignment = NSTextAlignmentCenter;
        _devEnvlabel.backgroundColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:0.5];
        _devEnvlabel.userInteractionEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netEnvChange:) name:NotiEnvChange object:nil];
    }
    return _devEnvlabel;
}


- (XSBaseServers *)server {
    return [[XSServerFactory sharedInstance] serviceWithName:[self serverName]];
}




- (void)showEnvTagView:(UIView *)container {
    [container addSubview:self.devEnvlabel];
    if (@available(iOS 11.0, *)) {
        self.devEnvlabel.frame = CGRectMake(container.safeAreaInsets.left, container.safeAreaInsets.right, 40, 16);
    } else {
        self.devEnvlabel.frame = CGRectMake(0, 20, 40, 16);
    }
    [self netEnvChange:nil];
}


- (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType loadingMsg:(NSString * _Nullable)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock {
    return [XSBaseDataEngine control:control serverName:[self serverName] path:path param:param bodyData:nil dataFilePath:nil dataFileURL:nil image:nil dataName:nil fileName:nil requestType:requestType alertType:XSAPIAlertType_Unknown mimeType:nil timeout:0 loadingMsg:loadingMsg complete:responseBlock uploadProgressBlock:nil downloadProgressBlock:nil errorButtonSelectIndex:nil];
}


- (nullable XSBaseDataEngine *)getRequest:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path loadingMsg:(NSString * _Nullable)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock {
    return [XSBaseDataEngine control:control serverName:[self serverName] path:path param:param bodyData:nil dataFilePath:nil dataFileURL:nil image:nil dataName:nil fileName:nil requestType:XSAPIRequestTypeGet alertType:XSAPIAlertType_Unknown mimeType:nil timeout:0 loadingMsg:loadingMsg complete:responseBlock uploadProgressBlock:nil downloadProgressBlock:nil errorButtonSelectIndex:nil];
}

- (nullable XSBaseDataEngine *)postRequest:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path loadingMsg:(NSString * _Nullable)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock {
    return [XSBaseDataEngine control:control serverName:[self serverName] path:path param:param bodyData:nil dataFilePath:nil dataFileURL:nil image:nil dataName:nil fileName:nil requestType:XSAPIRequestTypePost alertType:XSAPIAlertType_Unknown mimeType:nil timeout:0 loadingMsg:loadingMsg complete:responseBlock uploadProgressBlock:nil downloadProgressBlock:nil errorButtonSelectIndex:nil];
}

- (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control bodyData:(NSData * _Nullable)bodyData param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path complete:(CompletionDataBlock _Nullable)responseBlock {
    return [XSBaseDataEngine control:control serverName:[self serverName] path:path param:param bodyData:bodyData dataFilePath:nil dataFileURL:nil image:nil dataName:nil fileName:nil requestType:XSAPIRequestTypePostUpload alertType:XSAPIAlertType_Unknown mimeType:nil timeout:0 loadingMsg:nil complete:responseBlock uploadProgressBlock:nil downloadProgressBlock:nil errorButtonSelectIndex:nil];
}

- (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType timeout:(NSTimeInterval)timeout complete:(CompletionDataBlock _Nullable)responseBlock {
    return [XSBaseDataEngine control:control serverName:[self serverName] path:path param:param bodyData:nil dataFilePath:nil dataFileURL:nil image:nil dataName:nil fileName:nil requestType:requestType alertType:XSAPIAlertType_Unknown mimeType:nil timeout:timeout loadingMsg:nil complete:responseBlock uploadProgressBlock:nil downloadProgressBlock:nil errorButtonSelectIndex:nil];
}

- (nullable XSBaseDataEngine *)uploadFile:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path fileURL:(NSURL * _Nullable)fileURL filePath:(NSString *_Nullable)filePath fileKey:(NSString *_Nullable)fileKey fileName:(NSString *_Nullable)fileName requestType:(XSAPIRequestType)requestType progress:(ProgressBlock _Nullable)progress complete:(CompletionDataBlock _Nullable)responseBlock {
    return [XSBaseDataEngine control:control serverName:[self serverName] path:path param:param bodyData:nil dataFilePath:filePath dataFileURL:fileURL image:nil dataName:fileKey fileName:fileName requestType:requestType alertType:XSAPIAlertType_Unknown mimeType:nil timeout:0 loadingMsg:nil complete:responseBlock uploadProgressBlock:progress downloadProgressBlock:nil errorButtonSelectIndex:nil];
}





//-------------原生请求--------------

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



#pragma mark XSNetworkToolsProtocol
- (NSString *)serverName {
    return DefaultServerName;
}




@end
