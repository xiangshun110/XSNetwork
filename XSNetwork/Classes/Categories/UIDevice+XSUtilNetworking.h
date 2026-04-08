//
//  UIDevice+UtilNetworking.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

@interface UIDevice (XSUtilNetworking)
- (NSString *)platform;
-(NSString *)correspondVersion;
@end

#endif // TARGET_OS_IPHONE
