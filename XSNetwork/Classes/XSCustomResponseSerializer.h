//
//  XSCustomResponseSerializer.h
//  XSNetwork
//
//  Created by shun on 2018/1/16.
//  Copyright © 2018年 xiangshun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A response serializer that validates HTTP responses and deserializes JSON response data.
 */
@interface XSCustomResponseSerializer : NSObject

- (instancetype)init;

/**
 Options for reading the response JSON data and creating the Foundation objects.
 For possible values, see the `NSJSONSerialization` documentation section "NSJSONReadingOptions". `0` by default.
 */
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

/**
 Whether to remove keys with `NSNull` values from response JSON. Defaults to `NO`.
 */
@property (nonatomic, assign) BOOL removesKeysWithNullValues;

/**
 The acceptable HTTP status codes. Defaults to 200–299.
 */
@property (nonatomic, strong) NSIndexSet *acceptableStatusCodes;

/**
 The acceptable MIME types for responses. Defaults to JSON-compatible types.
 */
@property (nonatomic, strong) NSSet<NSString *> *acceptableContentTypes;

+ (instancetype)serializer;

/**
 Creates and returns a JSON serializer with the specified reading options.

 @param readingOptions The specified JSON reading options.
 */
+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions;

/**
 Validates an HTTP response and data, returning YES if valid.

 @param response The HTTP response to validate.
 @param data     The response data.
 @param error    On failure, set to an error describing the problem.
 @return YES if the response is valid; NO otherwise.
 */
- (BOOL)validateResponse:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError **)error;

/**
 Deserializes the response data into a Foundation object.

 @param response The HTTP response.
 @param data     The response data.
 @param error    On failure, set to an error describing the problem.
 @return A Foundation object, or nil on failure.
 */
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError **)error;

@end
