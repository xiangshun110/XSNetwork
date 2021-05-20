//
//  YAServerFactory.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSBaseServers.h"
#import "XSServerConfig.h"

@interface XSServerFactory : NSObject

+ (instancetype)sharedInstance;

+ (NSString *)YABaseAPI;

+ (EnvironmentType)getEnvironmentType;

+ (void)changeEnvironmentType:(EnvironmentType)environmentType;

- (XSBaseServers<YABaseServiceProtocol> *)serviceWithType:(XSServiceType)type;

@end
