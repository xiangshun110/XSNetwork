//
//  YABaseServers.h
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSServerModel.h"

@interface XSBaseServers : NSObject

@property (nonatomic, strong, readonly) XSServerModel      *model;


-(instancetype)initWithServerName:(NSString *)serverName;

@end
