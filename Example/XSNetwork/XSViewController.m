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
    
    NSLog(@"---------:%@",[XSNetworkTools getAppVersion]);
    
    
    [XSNetworkTools request:self param:nil path:@"http://admin.talkmed.com/live-required-columns?id=427549" requestType:XSAPIRequestTypeGet complete:^(id data, NSError *error) {
        NSLog(@"======:%@",data);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
