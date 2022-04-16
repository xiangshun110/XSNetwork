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

@property (nonatomic, weak) id<YABaseServiceProtocol>   child;
@property (nonatomic, strong) NSString                  *customApiBaseUrl;
@property (nonatomic, strong) XSServerModel             *model;

@end


@implementation XSBaseServers

@synthesize privateKey = _privateKey,apiBaseUrl = _apiBaseUrl, environmentType = _environmentType, publicKey = _publicKey;
@synthesize developApiBaseUrl = _developApiBaseUrl,prereleaseApiBaseUrl = _prereleaseApiBaseUrl,releaseApiBaseUrl = _releaseApiBaseUrl;

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
        
        if ([self conformsToProtocol:@protocol(YABaseServiceProtocol)]) {
            self.child = (id<YABaseServiceProtocol>)self;
        } else {
            NSAssert(NO,@"子类没有实现协议");
        }
    }
    return self;
}

#pragma mark - getters and setters
- (void)setEnvironmentType:(XSEnvType)environmentType{
    if (self.model) {
        self.model.environmentType = environmentType;
    } else {
        if (environmentType == XSEnvTypeCustom) {
            if (![[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.apiBaseUrl forKey:NSStringFromClass([self class])];
            }
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSStringFromClass([self class])];
        }
        _environmentType = environmentType;
        _apiBaseUrl = nil;
    }
}

- (XSEnvType)environmentType {
    if (self.model) {
        return self.model.environmentType;
    } else {
        return _environmentType;
    }
}

- (void)setPrivateKey:(NSString *)privateKey {
    if (self.model) {
        self.model.privateKey = privateKey;
    } else {
        _privateKey = privateKey;
    }
    
}

- (NSString *)privateKey
{
    if (self.model) {
        return self.model.privateKey;
    } else {
        return _privateKey;
    }
}

- (void)setPublicKey:(NSString *)publicKey {
    if (self.model) {
        self.model.publicKey = publicKey;
    } else {
        _publicKey = publicKey;
    }
}

- (NSString *)publicKey {
    if (self.model) {
        return self.model.publicKey;
    } else {
        return _publicKey;
    }
}



- (NSString *)apiBaseUrl
{
    if (self.model) {
        return self.model.apiBaseUrl;
    } else {
        if (_apiBaseUrl == nil) {
            switch (self.environmentType) {
                case XSEnvTypeDevelop:
                    _apiBaseUrl = self.child.developApiBaseUrl;
                    break;
                case XSEnvTypePreRelease:
                    _apiBaseUrl = self.child.prereleaseApiBaseUrl;
                    break;
                case XSEnvTypeRelease:
                    _apiBaseUrl = self.child.releaseApiBaseUrl;
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
