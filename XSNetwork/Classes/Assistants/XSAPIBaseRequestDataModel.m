//
//  YAAPIBaseRequestDataModel.m
//  NetWorking
//
//  Created by Yasin on 16/4/27.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "XSAPIBaseRequestDataModel.h"

@implementation XSAPIBaseRequestDataModel

- (NSString *)serverName {
    if (!_serverName) {
        return DefaultServerName;
    }
    return _serverName;
}

@end
