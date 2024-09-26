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

//+ (NSString *)YABaseAPI;

//+ (XSEnvType)getEnvironmentType;

+ (void)changeEnvironmentType:(XSEnvType)environmentType;

- (XSBaseServers *)serviceWithType:(XSServiceType)type;


/// 创建或者返回一个已有的server
/// @param serverName name
- (XSBaseServers *)serviceWithName:(NSString *)serverName;

@end
