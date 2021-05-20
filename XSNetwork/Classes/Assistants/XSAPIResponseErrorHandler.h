//
//  YAAPIResponseErrorHandler.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSAPIBaseRequestDataModel.h"
@interface XSAPIResponseErrorHandler : NSObject
+ (void)errorHandlerWithRequestDataModel:(XSAPIBaseRequestDataModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error errorHandler:(void(^)(NSError *newError))errorHandler;
@end
