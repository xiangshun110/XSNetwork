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
    

    [XSNetworkTools setComparam:@{
        @"token":@"dasdasdas"
    }];
    
    [XSNetworkTools setComparamExclude:@[@"http://itunes.apple.com/lookup?id=1148546631"]];
    
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
