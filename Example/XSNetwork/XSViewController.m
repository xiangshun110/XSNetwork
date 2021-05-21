//
//  XSViewController.m
//  XSNetwork
//
//  Created by shun on 05/20/2021.
//  Copyright (c) 2021 shun. All rights reserved.
//

#import "XSViewController.h"
#import <XSNetworkTools.h>

@interface XSViewController ()

@end

@implementation XSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    //配置base URL
    [XSNetworkTools setBaseURLWithRelease:@"https://api.abc.com" dev:@"https://devapi.abc.com" preRelease:@"https://preapi.abc.com"];
    
    //切换环境，EXSEnvTypeDevelop对应上面的https://devapi.abc.com
    [XSNetworkTools changeEnvironmentType:XSEnvTypeDevelop];
    
    //设置公共参数
    [XSNetworkTools setComparam:@{
        @"token":@"dasdasdas"
    }];
    
    //设置不要加公共参数的API
    [XSNetworkTools setComparamExclude:@[@"http://itunes.apple.com/lookup?id=1148546631"]];
    
    //GET请求
    [XSNetworkTools request:self param:nil path:@"http://itunes.apple.com/lookup?id=1148546631" requestType:XSAPIRequestTypeGet complete:^(id data, NSError *error) {
        NSLog(@"======:%@",data);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
