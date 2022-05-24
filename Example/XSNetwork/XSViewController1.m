//
//  XSViewController1.m
//  XSNetwork_Example
//
//  Created by shun on 2022/4/18.
//  Copyright © 2022 shun. All rights reserved.
//

#import "XSViewController1.h"
#import "XSNet1.h"


@interface XSViewController1 ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSArray       *data;

@end

@implementation XSViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"高级用法";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.data = @[@"post请求",@"get请求",@"切换环境",@"单个请求不显示错误提示",@"aaa",@"aaab"];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.data[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [[XSNet1 share] postRequest:self param:nil path:@"/v1/login" loadingMsg:@"ooooo" complete:^(id  _Nullable data, NSError *error) {
                NSLog(@"----data:%@",data);
            }];
        }
            break;
        case 1:
        {
            [[XSNet1 share] getRequest:self param:nil path:@"/time" loadingMsg:@"ooooo" complete:^(id  _Nullable data, NSError *error) {
                NSLog(@"----data:%@",data);
            }];
        }
            break;
        case 2:
        {
            if ([XSNet1 share].server.model.environmentType == XSEnvTypeRelease) {
                [XSNet1 share].server.model.environmentType = XSEnvTypeDevelop;
                NSLog(@"切换dev成功");
            } else {
                [XSNet1 share].server.model.environmentType = XSEnvTypeRelease;
                NSLog(@"切换release成功");
            }
        }
            break;
        case 3:
        {
            [[XSNet1 share] hideErrorAlert:self param:nil path:@"/v1/login" requestType:XSAPIRequestTypePost loadingMsg:@"ss" complete:^(id  _Nullable data, NSError * _Nullable error) {
                NSLog(@"----data:%@",data);
            }];
        }
            break;
        case 4:
        {
            NSDictionary *dic = @{
                @"actionenum":@(5),
                @"param" :     @{
                    @"category" :@(1),
                    @"id" : @(1930),
                    @"meetingid" : @(2707),
                    @"type" : @(3)
                }
            };
            [[XSNet1 share] hideErrorAlert:self param:dic path:@"/admin/common/geturl" requestType:XSAPIRequestTypePost loadingMsg:@"ss" complete:^(id  _Nullable data, NSError * _Nullable error) {
                NSLog(@"----data:%@",data);
            }];
        }
            break;
        case 5:
        {
            NSMutableDictionary *body = @{@"username":@"aa",
                                   @"password":@"123456"
                                   }.mutableCopy;

//            NSMutableDictionary *loginuserinfo = [NSMutableDictionary dictionary];
//            loginuserinfo[@"logintype"] = @"用户登录";
//            loginuserinfo[@"devicetype"] = @(2);
//            loginuserinfo[@"deviceinfo"] = [self getDeviceInfo];
//            body[@"loginuserinfo"] = loginuserinfo;
            [[XSNet1 share] hideErrorAlert:self param:body path:@"/admin/account/userlogin" requestType:XSAPIRequestTypePost loadingMsg:@"ss" complete:^(id  _Nullable data, NSError * _Nullable error) {
                NSLog(@"----data:%@",data);
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
