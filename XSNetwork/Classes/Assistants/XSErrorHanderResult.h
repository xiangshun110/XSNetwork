//
//  XSErrorHanderResult.h
//  XSNetwork
//
//  Created by shun on 2021/5/24.
//

#import <Foundation/Foundation.h>



@interface XSErrorHanderResult : NSObject

@property (nonatomic, strong) NSError       *error;

/// 是否要阻止执行回调函数，使用场景：比如在一次请求中token过期了，可以刷新token后再次请求，利用这个可以防止请求那边的回调执行两次
@property (nonatomic, assign) BOOL          blockResponse;

@end


