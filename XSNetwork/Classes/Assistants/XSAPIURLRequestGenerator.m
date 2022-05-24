//
//  YAAPIURLRequestGenerator.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSAPIURLRequestGenerator.h"
#import "AFURLRequestSerialization.h"
#import "XSServerFactory.h"
#import "XSignatureGenerator.h"
#import "NSString+XSUtilNetworking.h"
#import "XSNetworkTools.h"

//static NSTimeInterval kYANetworkingTimeoutSeconds = 25.0f;
@interface XSAPIURLRequestGenerator()
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
//@property (nonatomic, strong) AFJSONRequestSerializer *jsonRequestSerializer;
@end
@implementation XSAPIURLRequestGenerator
#pragma mark - life cycle
/**
 *  生成一个单例
 */
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static XSAPIURLRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSAPIURLRequestGenerator alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSURLRequest *)generateWithRequestDataModel:(XSAPIBaseRequestDataModel *)dataModel{
    //XSBaseServers *service = [[XSServerFactory sharedInstance] serviceWithType:dataModel.serviceType];
    
    XSBaseServers *service = [[XSServerFactory sharedInstance] serviceWithName:dataModel.serverName];
    
    NSMutableDictionary *commonParams = [NSMutableDictionary new];
    NSArray *exclude = service.model.comParamExclude;

    BOOL isIn = NO;
    if (exclude && exclude.count) {
        for (NSString *u in exclude) {
            if ([dataModel.apiMethodPath containsString:u]) {
                isIn = YES;
                break;
            }
        }
    }
    if (!isIn) {
        if (service.model.commonParameter) {
            [commonParams addEntriesFromDictionary:service.model.commonParameter];
        }
    }
    
    [commonParams addEntriesFromDictionary:dataModel.parameters];
    
    //动态通用参数
    
    if (service.model) {
        if (service.model.dynamicParamsIMP) {
            NSDictionary* (*dyFunc)(void) = (void *)service.model.dynamicParamsIMP;
            NSDictionary *dyParams = dyFunc();
            if (dyParams) {
                [commonParams addEntriesFromDictionary:dyParams];
            }
        }
    }
    
    NSString *urlString = nil;
    if (dataModel.requestType != XSAPIRequestTypeGETDownload && dataModel.needBaseURL) {
        urlString = [self URLStringWithServiceUrl:service.apiBaseUrl path:dataModel.apiMethodPath];
    } else {
        urlString = dataModel.apiMethodPath;
    }
    NSError *error = nil;
    NSMutableURLRequest *request = nil;

    // @param method The HTTP method for the request, such as `GET`, `POST`, `PUT`, or `DELETE`. This parameter must not be `nil`.
    if (dataModel.requestType == XSAPIRequestTypeGet) {
        request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:commonParams error:&error];
    } else if (dataModel.requestType == XSAPIRequestTypePost) {
        request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:commonParams error:&error];
    } else if (dataModel.requestType == XSAPIRequestTypePut) {
        request = [self.httpRequestSerializer requestWithMethod:@"PUT" URLString:urlString parameters:commonParams error:&error];
    } else if (dataModel.requestType == XSAPIRequestTypeDelete) {
        request = [self.httpRequestSerializer requestWithMethod:@"DELETE" URLString:urlString parameters:commonParams error:&error];
    } else if (dataModel.requestType == XSAPIRequestTypeUpdate) {
        request = [self.httpRequestSerializer requestWithMethod:@"UPDATE" URLString:urlString parameters:commonParams error:&error];
    } else if (dataModel.requestType == XSAPIRequestTypePostUpload) {
        request = [self.httpRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:commonParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            /**
             *  这里的参数配置也可以根据自己的设计修改默认值.
             *  为什么没有直接使用NSData?
             */
            if (![NSString isEmptyString:dataModel.dataFilePath] || dataModel.dataFileURL) {
                NSURL *fileURL = nil;
                if(dataModel.dataFileURL) {
                    fileURL = dataModel.dataFileURL;
                }else {
                    fileURL = [NSURL fileURLWithPath:dataModel.dataFilePath];
                }
                NSString *name = dataModel.dataName?dataModel.dataName:@"data";
                NSString *fileName = dataModel.fileName?dataModel.fileName:@"data.zip";
                NSString *mimeType = dataModel.mimeType?dataModel.mimeType:@"application/zip";
                NSError *error;
                
                [formData appendPartWithFileURL:fileURL
                                           name:name
                                       fileName:fileName
                                       mimeType:mimeType
                                          error:&error];
            }
            
            if(dataModel.image){
                [formData appendPartWithFileData:UIImagePNGRepresentation(dataModel.image) name:dataModel.dataName fileName:dataModel.fileName mimeType:dataModel.mimeType];
            }
            
        } error:&error];
    } else if(dataModel.requestType == XSAPIRequestTypeGETDownload) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    }
    if (error || request == nil) {
        DELog(@"NSMutableURLRequests生成失败：\n---------------------------\n\
              urlString:%@\n\
              \n---------------------------\n",urlString);
        return nil;
    }
    
    if (dataModel.requestType == XSAPIRequestTypePostUpload) {
        request.timeoutInterval = 0;
    } else {
        if (dataModel.requestTimeout > 0) {
            request.timeoutInterval = dataModel.requestTimeout;
        } else {
            XSBaseServers *server = [[XSServerFactory sharedInstance] serviceWithName:dataModel.serverName];
            if (server.model) {
                request.timeoutInterval = server.model.requestTimeout;
            } else {
                request.timeoutInterval = DefaultTimeout;
            }
        }
    }
    
    if (service.model) {
        NSMutableDictionary *hParams = [NSMutableDictionary new];
        if (service.model.commonHeaders) {
            [hParams addEntriesFromDictionary:service.model.commonHeaders];
        }
        if (service.model.dynamicHeadersIMP) {
            NSDictionary* (*dyFunc)(void) = (void *)service.model.dynamicHeadersIMP;
            NSDictionary *dyParams = dyFunc();
            if (dyParams) {
                [hParams addEntriesFromDictionary:dyParams];
            }
        }
        
        if (service.model.headersWithRequestParamsIMP) { //根据参数获取header参数
            NSDictionary *headers =  ((id(*)(id, SEL, NSDictionary *))service.model.headersWithRequestParamsIMP)(nil, nil, commonParams);
            if (headers && commonParams.allKeys.count) {
                [hParams addEntriesFromDictionary:headers];
            }
        }
        
//        [hParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            [request setValue:obj forHTTPHeaderField:key];
//        }];

        for (NSString *headerField in hParams.keyEnumerator) {
            [request addValue:hParams[headerField] forHTTPHeaderField:headerField];
        }
    }
    
    if (dataModel.bodyData) {
        [request setHTTPBody:dataModel.bodyData];
    }
    
    
#ifdef DEBUG
    NSLog(@"=====请求数据开始=====");
    NSLog(@"URL: \n%@",urlString);
    NSLog(@"参数: \n%@",commonParams);
    NSLog(@"headers: \n%@",request.allHTTPHeaderFields);
    NSLog(@"=====请求数据结束=====");
#endif
    
    return request;
}
#pragma mark - private methods
- (NSString *)URLStringWithServiceUrl:(NSString *)serviceUrl path:(NSString *)path{
    NSURL *fullURL = [NSURL URLWithString:serviceUrl];
    if (![NSString isEmptyString:path]) {
        fullURL = [NSURL URLWithString:path relativeToURL:fullURL];
    }
    if (fullURL == nil) {
        DELog(@"YAAPIURLRequestGenerator--URL拼接错误:\n---------------------------\n\
              apiBaseUrl:%@\n\
              urlPath:%@\n\
              \n---------------------------\n",serviceUrl,path);
        return nil;
    }
    return [fullURL absoluteString];
}

//- (AFHTTPRequestSerializer *)serializerWithModel:(XSAPIBaseRequestDataModel *)dataModel {
//    if (dataModel.requestTimeout > 0) {
//        self.httpRequestSerializer.timeoutInterval = dataModel.requestTimeout;
//    } else {
//        XSBaseServers *server = [[XSServerFactory sharedInstance] serviceWithName:dataModel.serverName];
//        if (server.model) {
//            self.httpRequestSerializer.timeoutInterval = server.model.requestTimeout;
//        } else {
//            self.httpRequestSerializer.timeoutInterval = DefaultTimeout;
//        }
//    }
//    return self.httpRequestSerializer;
//}

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = DefaultTimeout;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}
@end
