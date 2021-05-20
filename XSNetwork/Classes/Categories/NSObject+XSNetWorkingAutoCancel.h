//
//  NSObject+XSNetWorkingAutoCancel.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSNetworkingAutoCancelRequests.h"
@interface NSObject (XSNetWorkingAutoCancel)
/**
 将networkingRequestArray绑定到NSObject，当NSObject释放时networkingRequestArray也会释放
 *  networkingRequestArray存放requestid，当networkingRequestArray释放的时候，根据requestid取消没有返回的网络请求
 */
@property(nonatomic, strong, readonly)XSNetworkingAutoCancelRequests *networkingAutoCancelRequests;
@end
