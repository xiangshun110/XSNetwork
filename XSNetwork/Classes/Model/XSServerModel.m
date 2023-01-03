//
//  XSServerModel.m
//  XSNetwork
//
//  Created by shun on 2022/4/15.
//

#import "XSServerModel.h"

@interface XSServerModel()

@property (nonatomic, strong) NSString    *apiBaseUrl;
@property (nonatomic, strong) NSString    *serverName;

@end

@implementation XSServerModel


- (instancetype)initWithServerName:(NSString *)serverName {
    self = [super init];
    if (self) {
        self.serverName = serverName;
        [self initData];
    }
    return self;
}

- (void)initData {
    //初始化数据
    
    NSNumber *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"environmentType"];
    if (type) {
        self.environmentType = (XSEnvType)[type integerValue];
    } else {
        self.environmentType = XSEnvTypeRelease;
    }
    
    self.errorAlerType = XSAPIAlertType_Unknown;
    
    self.privateKey = @"volkhjuss$&^ghhh";
    
    self.errHander = [XSAPIResponseErrorHandler new];
    
    self.requestTimeout = 25.0;
    
    self.errMessageKey = @"message";
    
    NSString *key = [NSString stringWithFormat:@"customApi_%@",self.serverName];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        self.customApiBaseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
}

- (NSString *)apiBaseUrl
{
    if (_apiBaseUrl == nil) {
        switch (self.environmentType) {
            case XSEnvTypeDevelop:
                _apiBaseUrl = self.developApiBaseUrl;
                break;
            case XSEnvTypePreRelease:
                _apiBaseUrl = self.prereleaseApiBaseUrl;
                break;
            case XSEnvTypeRelease:
                _apiBaseUrl = self.releaseApiBaseUrl;
                break;
            case XSEnvTypeCustom:
                _apiBaseUrl = self.customApiBaseUrl;
                break;
            default:
                break;
        }
    }
    return _apiBaseUrl;
}

- (void)setEnvironmentType:(XSEnvType)environmentType {
    _environmentType = environmentType;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:environmentType] forKey:@"environmentType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiEnvChange object:nil];
    //重置APIbase
    _apiBaseUrl = nil;
}

- (void)setCustomApiBaseUrl:(NSString *)customApiBaseUrl {
    _customApiBaseUrl = customApiBaseUrl;
    
    NSString *key = [NSString stringWithFormat:@"customApi_%@",self.serverName];
    if (!customApiBaseUrl) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:customApiBaseUrl forKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDynamicParamsIMP:(IMP)dynamicParamsIMP {
    _dynamicParamsIMP = dynamicParamsIMP;
    //测试一下
//    NSDictionary* (*dyFunc)(void) = (void *)dynamicParamsIMP;
//    NSDictionary *dyParams = dyFunc();
//    NSLog(@"-----dyParams:%@",dyParams);
}

@end
