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

+ (void)setBaseURLWithRelease:(NSString *_Nullable)release dev:(NSString *_Nullable)dev preRelease:(NSString *_Nullable)preRelease {
    releaseURL = release ? release : @"";
    preReleaseURL = preRelease ? preRelease : @"";
    devURL = dev ? dev : @"";
}

@end
