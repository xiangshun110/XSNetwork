//
//  XSAPIURLRequestGenerator.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSAPIURLRequestGenerator.h"
#import "XSServerFactory.h"
#import "XSignatureGenerator.h"
#import "NSString+XSUtilNetworking.h"
#import "XSNetworkTools.h"

/// RFC 3986 unreserved characters – safe to leave un-encoded in a percent-encoded value.
static NSCharacterSet *XSURLQueryValueAllowedCharacterSet(void) {
    static NSCharacterSet *cs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cs = [NSCharacterSet characterSetWithCharactersInString:
              @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"];
    });
    return cs;
}

@implementation XSAPIURLRequestGenerator

#pragma mark - life cycle

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static XSAPIURLRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSAPIURLRequestGenerator alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

- (NSURLRequest *)generateWithRequestDataModel:(XSAPIBaseRequestDataModel *)dataModel {
    XSBaseServers *service = [[XSServerFactory sharedInstance] serviceWithName:dataModel.serverName];

    // Build merged parameter dictionary
    NSMutableDictionary *commonParams = [NSMutableDictionary new];
    NSArray *exclude = service.model.comParamExclude;
    BOOL isExcluded = NO;
    if (exclude.count) {
        for (NSString *u in exclude) {
            if ([dataModel.apiMethodPath containsString:u]) {
                isExcluded = YES;
                break;
            }
        }
    }
    if (!isExcluded && service.model.commonParameter) {
        [commonParams addEntriesFromDictionary:service.model.commonParameter];
    }
    if (dataModel.parameters) {
        [commonParams addEntriesFromDictionary:dataModel.parameters];
    }

    // Dynamic parameters (called on every request)
    if (service.model.dynamicParamsIMP) {
        NSDictionary *(*dyFunc)(void) = (void *)service.model.dynamicParamsIMP;
        NSDictionary *dyParams = dyFunc();
        if (dyParams) {
            [commonParams addEntriesFromDictionary:dyParams];
        }
    }

    // Resolve URL string
    NSString *urlString = nil;
    if (dataModel.requestType != XSAPIRequestTypeGETDownload && dataModel.needBaseURL) {
        urlString = [self URLStringWithServiceUrl:service.model.apiBaseUrl path:dataModel.apiMethodPath];
    } else {
        urlString = dataModel.apiMethodPath;
    }

    // Build NSURLRequest
    NSError *error = nil;
    NSMutableURLRequest *request = nil;

    switch (dataModel.requestType) {
        case XSAPIRequestTypeGet:
            request = [self buildGETRequest:urlString parameters:commonParams error:&error];
            break;
        case XSAPIRequestTypePost:
            request = [self buildJSONRequest:@"POST" urlString:urlString parameters:commonParams error:&error];
            break;
        case XSAPIRequestTypePostFormData:
            request = [self buildFormDataRequest:urlString parameters:commonParams error:&error];
            break;
        case XSAPIRequestTypePut:
            request = [self buildJSONRequest:@"PUT" urlString:urlString parameters:commonParams error:&error];
            break;
        case XSAPIRequestTypeDelete:
            request = [self buildJSONRequest:@"DELETE" urlString:urlString parameters:commonParams error:&error];
            break;
        case XSAPIRequestTypeUpdate:
            request = [self buildJSONRequest:@"UPDATE" urlString:urlString parameters:commonParams error:&error];
            break;
        case XSAPIRequestTypePostUpload:
            request = [self buildMultipartRequest:urlString parameters:commonParams dataModel:dataModel error:&error];
            break;
        case XSAPIRequestTypeGETDownload:
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            break;
    }

    if (error || request == nil) {
        DELog(@"NSMutableURLRequest generation failed:\n---------------------------\n\
              urlString:%@\n\
              \n---------------------------\n", urlString);
        return nil;
    }

    // Apply timeout
    if (dataModel.requestType == XSAPIRequestTypePostUpload ||
        dataModel.requestType == XSAPIRequestTypeGETDownload) {
        request.timeoutInterval = 0;
    } else {
        if (dataModel.requestTimeout > 0) {
            request.timeoutInterval = dataModel.requestTimeout;
        } else {
            if (service.model) {
                request.timeoutInterval = service.model.requestTimeout;
            } else {
                request.timeoutInterval = DefaultTimeout;
            }
        }
    }

    // Apply headers
    if (service.model) {
        NSMutableDictionary *hParams = [NSMutableDictionary new];
        if (service.model.commonHeaders) {
            [hParams addEntriesFromDictionary:service.model.commonHeaders];
        }

        if (service.model.dynamicHeadersIMP) {
            NSDictionary *(*dyFunc)(void) = (void *)service.model.dynamicHeadersIMP;
            NSDictionary *dyParams = dyFunc();
            if (dyParams && dyParams.allKeys.count) {
                [hParams addEntriesFromDictionary:dyParams];
            }
        }

        if (service.model.headersWithRequestParamsIMP) {
            NSMutableDictionary *impDic = [NSMutableDictionary dictionaryWithDictionary:commonParams.copy];
            [impDic setObject:urlString forKey:@"_url_"];
            NSDictionary *headers = ((id(*)(id, SEL, NSDictionary *))service.model.headersWithRequestParamsIMP)(nil, nil, impDic.copy);
            if (headers && headers.allKeys.count) {
                [hParams addEntriesFromDictionary:headers];
            }
        }

        for (NSString *headerField in hParams.keyEnumerator) {
            [request addValue:hParams[headerField] forHTTPHeaderField:headerField];
        }
    }

    // Raw body data override (used by the bodyData: request variant)
    if (dataModel.bodyData) {
        [request setHTTPBody:dataModel.bodyData];
    }

#ifdef DEBUG
    NSLog(@"=====请求数据开始=====");
    NSLog(@"URL: \n%@", urlString);
    NSLog(@"参数: \n%@", commonParams);
    NSLog(@"headers: \n%@", request.allHTTPHeaderFields);
    NSLog(@"=====请求数据结束=====");
#endif

    return request;
}

#pragma mark - Private request builders

- (NSMutableURLRequest *)buildGETRequest:(NSString *)urlString
                              parameters:(NSDictionary *)params
                                   error:(NSError **)outError {
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    if (!components) {
        return nil;
    }

    if (params.count) {
        NSMutableArray *queryItems = [NSMutableArray array];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            NSString *encodedKey   = [[key description]
                stringByAddingPercentEncodingWithAllowedCharacters:XSURLQueryValueAllowedCharacterSet()];
            NSString *encodedValue = [[value description]
                stringByAddingPercentEncodingWithAllowedCharacters:XSURLQueryValueAllowedCharacterSet()];
            [queryItems addObject:[NSURLQueryItem queryItemWithName:encodedKey value:encodedValue]];
        }];
        NSMutableArray *existing = [NSMutableArray arrayWithArray:components.queryItems ?: @[]];
        [existing addObjectsFromArray:queryItems];
        components.queryItems = existing;
    }

    NSURL *url = components.URL;
    if (!url) {
        return nil;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}

- (NSMutableURLRequest *)buildJSONRequest:(NSString *)method
                                urlString:(NSString *)urlString
                               parameters:(NSDictionary *)params
                                    error:(NSError **)outError {
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return nil;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    if (params.count) {
        NSError *jsonError = nil;
        NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0 error:&jsonError];
        if (jsonError) {
            if (outError) { *outError = jsonError; }
            return nil;
        }
        request.HTTPBody = body;
    }
    return request;
}

- (NSMutableURLRequest *)buildFormDataRequest:(NSString *)urlString
                                   parameters:(NSDictionary *)params
                                        error:(NSError **)outError {
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return nil;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    if (params.count) {
        NSMutableArray *parts = [NSMutableArray array];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            NSString *encodedKey   = [[key description]
                stringByAddingPercentEncodingWithAllowedCharacters:XSURLQueryValueAllowedCharacterSet()];
            NSString *encodedValue = [[value description]
                stringByAddingPercentEncodingWithAllowedCharacters:XSURLQueryValueAllowedCharacterSet()];
            [parts addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
        }];
        request.HTTPBody = [[parts componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
    }
    return request;
}

- (NSMutableURLRequest *)buildMultipartRequest:(NSString *)urlString
                                    parameters:(NSDictionary *)params
                                     dataModel:(XSAPIBaseRequestDataModel *)dataModel
                                         error:(NSError **)outError {
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return nil;
    }

    NSString *boundary = [NSString stringWithFormat:@"----XSNetworkBoundary%@",
                          [[NSUUID UUID] UUIDString]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
   forHTTPHeaderField:@"Content-Type"];

    NSMutableData *body = [NSMutableData data];

    // Boundary helper macros (local – not exposed outside this method)
    void (^appendString)(NSString *) = ^(NSString *s) {
        [body appendData:[s dataUsingEncoding:NSUTF8StringEncoding]];
    };

    // Add regular parameters as form fields
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        appendString([NSString stringWithFormat:@"--%@\r\n", boundary]);
        appendString([NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                      [key description]]);
        appendString([NSString stringWithFormat:@"%@\r\n", [value description]]);
    }];

    // Add file part (from path or URL)
    if (![NSString isEmptyString:dataModel.dataFilePath] || dataModel.dataFileURL) {
        NSURL *fileURL = dataModel.dataFileURL ?: [NSURL fileURLWithPath:dataModel.dataFilePath];
        NSString *name     = dataModel.dataName  ?: @"data";
        NSString *fileName = dataModel.fileName  ?: @"data.zip";
        NSString *mimeType = dataModel.mimeType  ?: @"application/zip";
        NSError *fileError = nil;
        NSData *fileData   = [NSData dataWithContentsOfURL:fileURL options:0 error:&fileError];
        if (fileData) {
            appendString([NSString stringWithFormat:@"--%@\r\n", boundary]);
            appendString([NSString stringWithFormat:
                          @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                          name, fileName]);
            appendString([NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType]);
            [body appendData:fileData];
            appendString(@"\r\n");
        } else if (fileError && outError) {
            *outError = fileError;
            return;
        }
    }

    // Add image data part
    if (dataModel.imageData) {
        NSString *name     = dataModel.dataName ?: @"image";
        NSString *fileName = dataModel.fileName ?: @"image.png";
        NSString *mimeType = dataModel.mimeType ?: @"image/png";
        appendString([NSString stringWithFormat:@"--%@\r\n", boundary]);
        appendString([NSString stringWithFormat:
                      @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                      name, fileName]);
        appendString([NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType]);
        [body appendData:dataModel.imageData];
        appendString(@"\r\n");
    }

    // Close the multipart boundary
    appendString([NSString stringWithFormat:@"--%@--\r\n", boundary]);
    [request setHTTPBody:body];
    return request;
}

#pragma mark - private methods

- (NSString *)URLStringWithServiceUrl:(NSString *)serviceUrl path:(NSString *)path {
    NSString *mStr = [NSString stringWithFormat:@"%@%@", serviceUrl, path];
    mStr = [mStr stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    NSURL *fullURL = [NSURL URLWithString:mStr];

    if (fullURL == nil) {
        DELog(@"XSAPIURLRequestGenerator -- URL concat error:\n---------------------------\n\
              apiBaseUrl:%@\n\
              urlPath:%@\n\
              \n---------------------------\n", serviceUrl, path);
        return nil;
    }

    return [fullURL absoluteString];
}

@end
