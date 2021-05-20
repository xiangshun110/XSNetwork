//
//  YAServerFactory.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSServerFactory.h"
#import "XSMainServer.h"

@interface XSServerFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end
@implementation XSServerFactory
#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static XSServerFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSServerFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
+ (NSString *)YABaseAPI{
    return [[XSServerFactory sharedInstance] serviceWithType:XSServiceMain].apiBaseUrl;
}
+ (EnvironmentType)getEnvironmentType{
    return [[XSServerFactory sharedInstance] serviceWithType:XSServiceMain].environmentType;
}
+ (void)changeEnvironmentType:(EnvironmentType)environmentType{
    XSServerFactory *factory = [self sharedInstance];
    [factory.serviceStorage.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XSBaseServers *service = obj;
        service.environmentType = environmentType;
    }];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:environmentType] forKey:@"environmentType"];
}
- (XSBaseServers<YABaseServiceProtocol> *)serviceWithType:(XSServiceType)type
{
    if (self.serviceStorage[@(type)] == nil) {
        self.serviceStorage[@(type)] = [self newServiceWithType:type];
    }
    return self.serviceStorage[@(type)];
}

#pragma mark - private methods
- (XSBaseServers<YABaseServiceProtocol> *)newServiceWithType:(XSServiceType)type
{
    XSBaseServers<YABaseServiceProtocol> *service = nil;
    switch (type) {
        case XSServiceMain:
            service= [[XSMainServer alloc] init];
            break;
        default:
            break;
    }
    return service;
}
#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

@end
