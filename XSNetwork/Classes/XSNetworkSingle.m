//
//  XSNetworkSingle.m
//  XSNetwork
//
//  Created by shun on 2021/7/30.
//

#import "XSNetworkSingle.h"

static NSTimeInterval kYANetworkingTimeoutSeconds = 25.0f;

@implementation XSNetworkSingle

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static XSNetworkSingle *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSNetworkSingle alloc] init];
        [sharedInstance initOther];
    });
    return sharedInstance;
}

- (void)initOther {
    self.requestTimeout = kYANetworkingTimeoutSeconds;
    self.errMessageKey = @"message";
    self.errorAlerType = XSAPIAlertType_None;
}

@end
