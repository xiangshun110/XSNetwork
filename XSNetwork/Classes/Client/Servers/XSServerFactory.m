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
+ (XSEnvType)getEnvironmentType{
    return [[XSServerFactory sharedInstance] serviceWithType:XSServiceMain].environmentType;
}


+ (void)changeEnvironmentType:(XSEnvType)environmentType{
    
    XSBaseServers *server = [[XSServerFactory sharedInstance] serviceWithName:DefaultServerName];
    if (server.model) {
        server.model.environmentType = environmentType;
    } else {
        server.environmentType = environmentType;
    }
    
    
//    XSServerFactory *factory = [XSServerFactory sharedInstance];
//    [factory.serviceStorage.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        XSBaseServers *service = obj;
//        service.environmentType = environmentType;
//    }];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:environmentType] forKey:@"environmentType"];
}


- (XSBaseServers<YABaseServiceProtocol> *)serviceWithType:(XSServiceType)type
{
    
    return [self serviceWithName:DefaultServerName];
    
//    if (self.serviceStorage[@(type)] == nil) {
//        self.serviceStorage[@(type)] = [self newServiceWithType:type];
//    }
//    return self.serviceStorage[@(type)];
}

- (XSBaseServers *)serviceWithName:(NSString *)serverName {
    if (self.serviceStorage[serverName] == nil) {
        self.serviceStorage[serverName] = [self newServiceWithName:serverName];
    }
    return self.serviceStorage[serverName];
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
