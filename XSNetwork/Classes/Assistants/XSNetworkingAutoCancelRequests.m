//
//  YANetworkingAutoCancelRequests.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSNetworkingAutoCancelRequests.h"
@interface XSNetworkingAutoCancelRequests()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,XSBaseDataEngine *> *requestEngines;
@end
@implementation XSNetworkingAutoCancelRequests
-(void)dealloc{
    [self.requestEngines enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, XSBaseDataEngine * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj cancelRequest];
    }];
    [self.requestEngines removeAllObjects];
    self.requestEngines = nil;
    //NSLog(@"==-==:YANetworkingAutoCancelRequests");
}
- (NSMutableDictionary *)requestEngines
{
    if (_requestEngines == nil) {
        _requestEngines = [[NSMutableDictionary alloc] init];
    }
    return _requestEngines;
}

- (void)setEngine:(XSBaseDataEngine *)engine requestID:(NSNumber *)requestID
{
    if (engine && requestID) {
        self.requestEngines[requestID] = engine;
    }
}

- (void)removeEngineWithRequestID:(NSNumber *)requestID
{
    if (requestID) {
//        NSArray *keys = self.requestEngines.allKeys;
//        if ([keys containsObject:requestID]) {
            [self.requestEngines removeObjectForKey:requestID];
//        } else {
//            __block NSMutableArray *needRemove = [[NSMutableArray alloc] init];
//            [keys enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([requestID isEqualToNumber:obj]) {
//                    [needRemove addObject:obj];
//                }
//            }];
//            if (needRemove.count > 0) {
//                [self.requestEngines removeObjectsForKeys:needRemove];
//            }
//        }
    }
}

@end
