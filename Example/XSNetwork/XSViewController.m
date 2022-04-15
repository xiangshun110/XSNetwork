//
//  XSViewController.m
//  XSNetwork
//
//  Created by shun on 05/20/2021.
//  Copyright (c) 2021 shun. All rights reserved.
//

#import "XSViewController.h"
#import <XSNetworkTools.h>
#import "XSAppDelegate.h"

@interface XSViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

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
    
    
    //超时
    //[XSNetworkTools setRequesTimeout:10];
    
    //GET请求
//    [XSNetworkTools request:self param:nil path:@"http://itunes.apple.com/lookup?id=1148546631" requestType:XSAPIRequestTypeGet complete:^(id data, NSError *error) {
//        NSLog(@"======aaaaaa:%@",error);
//    }];
//
//    //单独设置超时的
//    [XSNetworkTools request:self param:nil path:@"http://itunes.apple.com/lookup?id=1148546631&d=1" requestType:XSAPIRequestTypeGet timeout:1 complete:^(id data, NSError *error) {
//        NSLog(@"======:%@",data);
//        NSLog(@"======:%@",error);
//    }];
    
    
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [XSNetworkTools request:self param:nil path:@"http://itunes.apple.com/lookup?id=1148546631&d=1" requestType:XSAPIRequestTypeGet loadingMsg:@"loading" complete:^(id data, NSError *error) {
                NSLog(@"----err:%@",error);
            }];
        }
            break;
            
        default:
            break;
    }
}


@end
