//  ErrorHandlerObjc.m
//  ObjcExample — 自定义错误处理器示例

#import "ErrorHandlerObjc.h"

@implementation ErrorHandlerObjc

// ObjC 调用名由 Swift @objc(errorHandlerWithRequestDataModel:responseURL:responseObject:error:) 决定
- (XSErrorHanderResult *)errorHandlerWithRequestDataModel:(XSAPIBaseRequestDataModel *)requestDataModel
                                              responseURL:(NSURLResponse * _Nullable)responseURL
                                           responseObject:(id _Nullable)responseObject
                                                    error:(NSError * _Nullable)error {
    XSErrorHanderResult *result = [[XSErrorHanderResult alloc] init];

    if (error) {
        result.error = error;
        return result;
    }

    NSDictionary *dict = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : nil;
    if (!dict) {
        return result;
    }

    NSInteger code = [dict[@"code"] integerValue];
    if (code == 0) {
        return result;  // 成功
    }

    NSString *message = dict[@"message"] ?: @"请求失败";
    result.error = [NSError errorWithDomain:NSCocoaErrorDomain
                                       code:code
                                   userInfo:@{
        NSLocalizedDescriptionKey: message,
        @"data": responseObject,
        @"URL": responseURL.URL.absoluteString ?: @""
    }];
    return result;
}

@end
