//
//  YANetworkingAutoCancelRequests.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSBaseDataEngine.h"
@interface XSNetworkingAutoCancelRequests : NSObject
- (void)setEngine:(XSBaseDataEngine *)engine requestID:(NSNumber *)requestID;
- (void)removeEngineWithRequestID:(NSNumber *)requestID;
@end
