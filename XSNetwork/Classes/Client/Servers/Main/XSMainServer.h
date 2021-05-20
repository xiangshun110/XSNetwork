//
//  TMDMainServer.h
//  TalkMed
//
//  Created by shun on 2017/8/24.
//  Copyright © 2017年 edoctor. All rights reserved.
//

#import "XSBaseServers.h"

@interface XSMainServer : XSBaseServers<YABaseServiceProtocol>

+ (void)setBaseURLWithRelease:(NSString *_Nullable)release dev:(NSString *_Nullable)dev preRelease:(NSString *_Nullable)preRelease;

@end
