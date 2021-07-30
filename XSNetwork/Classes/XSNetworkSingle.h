//
//  XSNetworkSingle.h
//  XSNetwork
//
//  Created by shun on 2021/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XSNetworkSingle : NSObject

@property (nonatomic, assign) NSTimeInterval        requestTimeout;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
