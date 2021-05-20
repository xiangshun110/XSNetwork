//
//  YABaseServers.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSBaseServers.h"
#import "XSServerConfig.h"
@interface XSBaseServers()
@property (nonatomic, weak) id<YABaseServiceProtocol> child;
@property (nonatomic, strong) NSString *customApiBaseUrl;
@end
@implementation XSBaseServers
@synthesize privateKey = _privateKey,apiBaseUrl = _apiBaseUrl;


- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(YABaseServiceProtocol)]) {
            self.child = (id<YABaseServiceProtocol>)self;
            //优先宏定义正式环境
            self.environmentType = EnvironmentTypeRelease;
            //手动切换环境后会把设置保存
            NSNumber *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"environmentType"];
            if (type) {
                self.environmentType = (EnvironmentType)[type integerValue];
            }
        } else {
            NSAssert(NO,@"子类没有实现协议");
        }
    }
    return self;
}

#pragma mark - getters and setters
- (void)setEnvironmentType:(EnvironmentType)environmentType{
    if (environmentType == EnvironmentTypeCustom) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])]) {
            [[NSUserDefaults standardUserDefaults] setObject:self.apiBaseUrl forKey:NSStringFromClass([self class])];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSStringFromClass([self class])];
    }
    _environmentType = environmentType;
    _apiBaseUrl = nil;
}
- (NSString *)privateKey
{
    if (!_privateKey) {
        _privateKey = @"abcdefghijklmn";
    }
    return _privateKey;
}

- (NSString *)apiBaseUrl
{
    if (_apiBaseUrl == nil) {
        switch (self.environmentType) {
            case EnvironmentTypeDevelop:
                _apiBaseUrl = self.child.developApiBaseUrl;
                break;
//            case EnvironmentTypeTest:
//                _apiBaseUrl = self.child.testApiBaseUrl;
//                break;
            case EnvironmentTypePreRelease:
                _apiBaseUrl = self.child.prereleaseApiBaseUrl;
                break;
//            case EnvironmentTypeHotFix:
//                _apiBaseUrl = self.child.hotfixApiBaseUrl;
//                break;
            case EnvironmentTypeRelease:
                _apiBaseUrl = self.child.releaseApiBaseUrl;
                break;
            case EnvironmentTypeCustom:
                _apiBaseUrl = self.customApiBaseUrl;
                break;
            default:
                break;
        }
    }
    return _apiBaseUrl;
}


- (NSString *)customApiBaseUrl{
    if (!_customApiBaseUrl) {
        _customApiBaseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])];
    }
    return _customApiBaseUrl;
}
@end
