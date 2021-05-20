//
//  NSObject+XSNetWorkingAutoCancel.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "NSObject+XSNetWorkingAutoCancel.h"
#import <objc/runtime.h>
@implementation NSObject (XSNetWorkingAutoCancel)
- (XSNetworkingAutoCancelRequests *)networkingAutoCancelRequests{
    XSNetworkingAutoCancelRequests *requests = objc_getAssociatedObject(self, @selector(networkingAutoCancelRequests));
    if (requests == nil) {
        requests = [[XSNetworkingAutoCancelRequests alloc]init];
        objc_setAssociatedObject(self, @selector(networkingAutoCancelRequests), requests, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return requests;
}

@end
