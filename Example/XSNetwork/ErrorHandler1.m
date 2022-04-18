//
//  ErrorHandler1.m
//  XSNetwork_Example
//
//  Created by shun on 2022/4/18.
//  Copyright © 2022 shun. All rights reserved.
//

#import "ErrorHandler1.h"

@implementation ErrorHandler1

- (XSErrorHanderResult *)errorHandlerWithRequestDataModel:(XSAPIBaseRequestDataModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error {
    XSErrorHanderResult *xsResult = [XSErrorHanderResult new];
    
    if (error) {
        xsResult.error = error;
        return xsResult;
    } else {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            int errorCode = [[responseObject objectForKey:@"code"] intValue];
            if (errorCode == 0) {
                return xsResult;
            } else {
                NSString *message = @"请求失败";
                if ([responseObject isKindOfClass:[NSDictionary class]]){
                    message = responseObject[@"message"];
                }
                NSError *newError = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:message,@"data":responseObject?responseObject:@{},@"URL":responseURL.URL.absoluteString}];

                xsResult.error = newError;
                return xsResult;
            }
        } else {
            xsResult.error = error;
            return xsResult;
        }
    }
}

@end
