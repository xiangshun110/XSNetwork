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

@property (nonatomic, strong) NSString                  *customApiBaseUrl;
@property (nonatomic, strong) XSServerModel             *model;

@end


@implementation XSBaseServers

-(instancetype)initWithServerName:(NSString *)serverName {
    self = [super init];
    if (self) {
        self.model = [[XSServerModel alloc] initWithServerName:serverName];
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.environmentType = XSEnvTypeRelease;
        NSNumber *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"environmentType"];
        if (type) {
            self.environmentType = (XSEnvType)[type integerValue];
        }
        
        self.environmentType = self.model.environmentType;
    }
    return self;
}

#pragma mark - getters and setters
- (void)setEnvironmentType:(XSEnvType)environmentType{
    self.model.environmentType = environmentType;
}

- (XSEnvType)environmentType {
    return self.model.environmentType;
}

- (void)setPrivateKey:(NSString *)privateKey {
    self.model.privateKey = privateKey;
}

- (NSString *)privateKey {
    return self.model.privateKey;
}

- (void)setPublicKey:(NSString *)publicKey {
    self.model.publicKey = publicKey;
}

- (NSString *)publicKey {
    return self.model.publicKey;
}

- (NSString *)apiBaseUrl
{
    return self.model.apiBaseUrl;
}

- (NSString *)customApiBaseUrl{
    if (!_customApiBaseUrl) {
        _customApiBaseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])];
    }
    return _customApiBaseUrl;
}


- (NSString *)developApiBaseUrl {
    return self.model.developApiBaseUrl;
}

- (NSString *)prereleaseApiBaseUrl {
    return self.model.prereleaseApiBaseUrl;
}

- (NSString *)releaseApiBaseUrl {
    return self.model.releaseApiBaseUrl;
}


@end
