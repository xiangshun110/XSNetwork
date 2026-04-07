//
//  XSCustomResponseSerializer.m
//  XSNetwork
//
//  Created by shun on 2018/1/16.
//  Copyright © 2018年 xiangshun. All rights reserved.
//

#import "XSCustomResponseSerializer.h"

static NSString * const XSURLResponseSerializationErrorDomain = @"com.xsnetwork.error.serialization.response";

static id XSJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:XSJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = XSJSONObjectByRemovingKeysWithNullValues(value, readingOptions);
            }
        }
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    return JSONObject;
}


@implementation XSCustomResponseSerializer

+ (instancetype)serializer {
    return [self serializerWithReadingOptions:(NSJSONReadingOptions)0];
}

+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions {
    XSCustomResponseSerializer *serializer = [[self alloc] init];
    serializer.readingOptions = readingOptions;
    return serializer;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
    self.acceptableContentTypes = [NSSet setWithObjects:
                                   @"application/json",
                                   @"text/json",
                                   @"text/javascript",
                                   @"text/plain",
                                   @"text/html",
                                   nil];
    return self;
}

#pragma mark - Validation

- (BOOL)validateResponse:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError **)error {
    if (!response) {
        return YES;
    }

    if (![self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode]) {
        NSString *description = [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode];
        NSDictionary *userInfo = @{
            NSLocalizedDescriptionKey: description,
            NSURLErrorFailingURLErrorKey: response.URL ?: [NSNull null]
        };
        if (error) {
            *error = [NSError errorWithDomain:NSURLErrorDomain
                                         code:response.statusCode
                                     userInfo:userInfo];
        }
        return NO;
    }

    if (response.MIMEType && self.acceptableContentTypes &&
        ![self.acceptableContentTypes containsObject:response.MIMEType]) {
        NSString *description = [NSString stringWithFormat:
                                 @"Request failed: unacceptable content-type: %@", response.MIMEType];
        NSDictionary *userInfo = @{
            NSLocalizedDescriptionKey: description,
            NSURLErrorFailingURLErrorKey: response.URL ?: [NSNull null]
        };
        if (error) {
            *error = [NSError errorWithDomain:XSURLResponseSerializationErrorDomain
                                         code:NSURLErrorCannotDecodeContentData
                                     userInfo:userInfo];
        }
        return NO;
    }

    return YES;
}

#pragma mark - Response Object

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError **)error {
    NSError *validationError = nil;
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:&validationError]) {
        if (error) {
            *error = validationError;
        }
        return nil;
    }

    // Treat a single space (Rails head :ok workaround) as empty response
    BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
    if (data.length == 0 || isSpace) {
        return nil;
    }

    NSError *serializationError = nil;
    id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:self.readingOptions
                                                          error:&serializationError];

    if (self.removesKeysWithNullValues && responseObject) {
        responseObject = XSJSONObjectByRemovingKeysWithNullValues(responseObject, self.readingOptions);
    }

    if (serializationError && error) {
        *error = serializationError;
    }

    return responseObject;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    XSCustomResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.readingOptions = self.readingOptions;
    serializer.removesKeysWithNullValues = self.removesKeysWithNullValues;
    serializer.acceptableStatusCodes = [self.acceptableStatusCodes copy];
    serializer.acceptableContentTypes = [self.acceptableContentTypes copy];
    return serializer;
}

@end
