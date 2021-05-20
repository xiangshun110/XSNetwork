//
//  TMDMainServer.m
//  TalkMed
//
//  Created by shun on 2017/8/24.
//  Copyright © 2017年 edoctor. All rights reserved.
//

#import "XSMainServer.h"

static NSString *releaseURL = @"";
static NSString *preReleaseURL = @"";
static NSString *devURL = @"";

@implementation XSMainServer
//@synthesize developApiBaseUrl = _developApiBaseUrl,testApiBaseUrl = _testApiBaseUrl,prereleaseApiBaseUrl = _prereleaseApiBaseUrl,releaseApiBaseUrl = _releaseApiBaseUrl,hotfixApiBaseUrl = _hotfixApiBaseUrl;

@synthesize developApiBaseUrl = _developApiBaseUrl,prereleaseApiBaseUrl = _prereleaseApiBaseUrl,releaseApiBaseUrl = _releaseApiBaseUrl;

- (NSString *)developApiBaseUrl {
    if (_developApiBaseUrl == nil) {
        _developApiBaseUrl = devURL;
    }
    return _developApiBaseUrl;
}

//- (NSString *)testApiBaseUrl {
//    if (_testApiBaseUrl == nil) {
//        _testApiBaseUrl = @"";
//    }
//    return _testApiBaseUrl;
//}

- (NSString *)prereleaseApiBaseUrl {
    if (_prereleaseApiBaseUrl == nil) {
        _prereleaseApiBaseUrl = preReleaseURL;
    }
    return _prereleaseApiBaseUrl;
}
//
//- (NSString *)hotfixApiBaseUrl{
//    if (_hotfixApiBaseUrl == nil) {
//        _hotfixApiBaseUrl = @"";
//    }
//    return _hotfixApiBaseUrl;
//}

- (NSString *)releaseApiBaseUrl {
    if (_releaseApiBaseUrl == nil) {
        _releaseApiBaseUrl = releaseURL;
    }
    return _releaseApiBaseUrl;
}


+ (void)setBaseURLWithRelease:(NSString *_Nullable)release dev:(NSString *_Nullable)dev preRelease:(NSString *_Nullable)preRelease {
    releaseURL = release ? release : @"";
    preReleaseURL = preRelease ? preRelease : @"";
    devURL = dev ? dev : @"";
}

@end
