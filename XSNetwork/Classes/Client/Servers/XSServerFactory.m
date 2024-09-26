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
//+ (NSString *)YABaseAPI{
//    return [[XSServerFactory sharedInstance] serviceWithType:XSServiceMain].apiBaseUrl;
//}
//+ (XSEnvType)getEnvironmentType{
//    return [[XSServerFactory sharedInstance] serviceWithType:XSServiceMain].environmentType;
//}


+ (void)changeEnvironmentType:(XSEnvType)environmentType{
    XSBaseServers *server = [[XSServerFactory sharedInstance] serviceWithName:DefaultServerName];
    server.model.environmentType = environmentType;
}


- (XSBaseServers *)serviceWithType:(XSServiceType)type
{
    return [self serviceWithName:DefaultServerName];
}

- (XSBaseServers *)serviceWithName:(NSString *)serverName {
    if (self.serviceStorage[serverName] == nil) {
        self.serviceStorage[serverName] = [self newServiceWithName:serverName];
    }
    return self.serviceStorage[serverName];
}

#pragma mark - private methods
- (XSBaseServers *)newServiceWithType:(XSServiceType)type
{
    XSBaseServers *service = nil;
    switch (type) {
        case XSServiceMain:
            service= [[XSMainServer alloc] init];
            break;
        default:
            break;
    }
    return service;
}

- (XSBaseServers *)newServiceWithName:(NSString *)serverName
{
    XSBaseServers *service = [[XSBaseServers alloc] initWithServerName:serverName];
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
