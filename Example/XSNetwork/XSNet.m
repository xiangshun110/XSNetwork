//
//  XSNet.m
//  XSNetwork_Example
//
//  Created by shun on 2022/4/18.
//  Copyright © 2022 shun. All rights reserved.
//

#import "XSNet.h"

@implementation XSNet


+ (instancetype)singleInstance
{
    static dispatch_once_t onceToken;
    static XSNet *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSNet alloc] init];
    });
    return sharedInstance;
}

- (NSString *)serverName {
    return @"server1";
}

@end
