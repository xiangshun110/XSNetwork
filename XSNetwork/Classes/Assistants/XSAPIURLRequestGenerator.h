//
//  YAAPIURLRequestGenerator.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//
/**
 *  网络请求生成URLRequest
 */
#import <Foundation/Foundation.h>
#import "XSAPIBaseRequestDataModel.h"
@interface XSAPIURLRequestGenerator : NSObject
/**
 *  生成一个单例
 *
 */
+ (instancetype)sharedInstance;

- (NSURLRequest *)generateWithRequestDataModel:(XSAPIBaseRequestDataModel *)dataModel;


@end
