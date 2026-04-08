//
//  YAAppContext.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSAppContext.h"
//#import "UIDevice+XSUtilNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

static BOOL XSIsNetworkReachable(void) {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len    = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(
        kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    if (!ref) { return NO; }

    SCNetworkReachabilityFlags flags = 0;
    BOOL got = SCNetworkReachabilityGetFlags(ref, &flags);
    CFRelease(ref);

    if (!got) { return YES; } // unknown → assume reachable (mirrors original behaviour)
    BOOL reachable   = (flags & kSCNetworkFlagsReachable)          != 0;
    BOOL needsConn   = (flags & kSCNetworkFlagsConnectionRequired)  != 0;
    return reachable && !needsConn;
}

@implementation XSAppContext
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (NSString *)user_id {
//    if (/* DISABLES CODE */ (!@"APP_DELEGATE.user.userID")) {
//        _user_id = @"APP_DELEGATE.user.userID";
//    } else {
//        _user_id = @"loginUser.userID";
//    }
    return _user_id;
}

- (NSString *)qtime
{
    NSString *time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    return time;
}

- (BOOL)isReachable
{
    return XSIsNetworkReachable();
}

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static XSAppContext *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSAppContext alloc] init];
    });
    return sharedInstance;
}

#pragma mark - overrided methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
        self.channelID = @"App Store";
        _device_id = @"[OpenUDID value]";
        _os_name = @"mac os";//[[UIDevice currentDevice] systemName];
        _os_version = @"10.2";//[[UIDevice currentDevice] systemVersion];
        _bundle_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _app_client_id = @"1";
        _device_model = @"";//[[UIDevice currentDevice] platform];
        _device_name = @"";//[[UIDevice currentDevice] name];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutAction) name:@"LogoutNotification" object:nil];
    }
    return self;
}

- (void)logoutAction
{
    _user_id = nil;
}
@end
