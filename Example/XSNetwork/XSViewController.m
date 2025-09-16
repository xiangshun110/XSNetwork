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
#import "XSNet.h"
#import "XSViewController1.h"
#import "XSViewController2.h"


@interface XSViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSArray       *data;
@property (nonatomic, strong) UIView        *testView;

@end

@implementation XSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"demo";
    
    
    //配置baseURL，最好是配置，不然每次请求都要写全量url
    [XSNet singleInstance].server.model.releaseApiBaseUrl = @"https://api.talkmed.com/api/v1";
    [XSNet singleInstance].server.model.developApiBaseUrl = @"http://api.sandbox.talkmed.com/api/v1";

    //默认是XSEnvTypeRelease
    [XSNet singleInstance].server.model.environmentType = XSEnvTypeDevelop;
    
    NSLog(@"[XSNet singleInstance]:%@",[XSNet singleInstance]);
    
    
    [[XSNet singleInstance] showEnvTagView:[UIApplication sharedApplication].keyWindow];
    
    self.data = @[@"模块1(高级用法)",@"模块2(返回后自动取消请求)",@"post请求",@"post请求(multipart/form-data)",@"get请求",@"切换环境",@"不用baseURL的请求",@"文件下载"];
    
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    
    
//    self.testView = [UIView new];
//    self.testView.backgroundColor = [UIColor yellowColor];
//    self.testView.frame = CGRectMake(100, 100, 120, 60);
//    [self.view addSubview:self.testView];
//    
//    [[XSNet singleInstance] showEnvTagView:self.testView];
//    
//    [self performSelector:@selector(clearTestView) withObject:nil afterDelay:5];
    
}

- (void)clearTestView {
    [self.testView removeFromSuperview];
    self.testView = nil;
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
            //http://itunes.apple.com/lookup?id=1148546631&d=1
            XSViewController1 *vc1 = [XSViewController1 new];
            [self.navigationController pushViewController:vc1 animated:YES];
            
        }
            break;
        case 1:
        {
            
            XSViewController2 *vc2 = [XSViewController2 new];
            [self.navigationController pushViewController:vc2 animated:YES];
            
            
        }
            break;
        case 2:
        {
            NSDictionary *params = @{
                @"name": @"test",
                @"age": @(18)
            };
            [[XSNet singleInstance] postRequest:self param:params path:@"http://localhost:48081/app-api/test/json" loadingMsg:@"ooooo" complete:^(id  _Nullable data, NSError *error) {
                NSLog(@"----data:%@",data);
            }];
        }
            break;
        case 3:
        {
            NSDictionary *params = @{
                @"name": @"test",
                @"age": @(18)
            };
            [[XSNet singleInstance] postFormDataRequest:self param:params path:@"http://localhost:48081/app-api/test/form" loadingMsg:@"发送FormData请求..." complete:^(id  _Nullable data, NSError *error) {
                NSLog(@"----FormData data:%@",data);
                if (error) {
                    NSLog(@"----FormData error:%@",error);
                }
            }];
        }
            break;
        case 4:
        {
            [[XSNet singleInstance] getRequest:self param:nil path:@"/time" loadingMsg:@"ooooo" complete:^(id  _Nullable data, NSError *error) {
                NSLog(@"----data:%@",data);
            }];
        }
            break;
        case 5:
        {
            if ([XSNet singleInstance].server.model.environmentType == XSEnvTypeRelease) {
                [XSNet singleInstance].server.model.environmentType = XSEnvTypeDevelop;
                NSLog(@"切换dev成功");
            } else {
                [XSNet singleInstance].server.model.environmentType = XSEnvTypeRelease;
                NSLog(@"切换release成功");
            }
        }
            break;
        case 6:
            [[XSNet singleInstance] getRequest:self param:nil path:@"https://api.weixin.qq.com/sns/userinfo" loadingMsg:@"lll" complete:^(id  _Nullable data, NSError * _Nullable error) {
                NSLog(@"----data:%@",data);
            }];
            break;
        case 7:
        {
            NSString *url = @"https://cdn.sandbox.edstatic.com/202311122246/a7c470d9e9859480e6612b88dfbcf05f/2023/01/18/92070ab7-2b19-bd06-b980-77d4b5ca63f6.svga";
            [[XSNet singleInstance] downloadFile:self url:url fileName:@"test1/01.pdf" progress:^(NSProgress * _Nonnull taskProgress) {
                NSLog(@"--------:%f",(float)taskProgress.completedUnitCount/taskProgress.totalUnitCount);
            } complete:^(id  _Nullable data, NSError * _Nullable error) {
                NSLog(@"aaa");
            }];
        }
            break;
            
        default:
            break;
    }
}


@end
