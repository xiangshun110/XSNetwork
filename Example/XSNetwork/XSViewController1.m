//
//  XSViewController1.m
//  XSNetwork_Example
//
//  Created by shun on 2022/4/18.
//  Copyright © 2022 shun. All rights reserved.
//

#import "XSViewController1.h"
#import "XSNet1.h"
#import "ErrorHandler1.h"

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
    
    //配置baseURL，最好是配置，不然每次请求都要写全量url
    [XSNet1 singleInstance].server.model.releaseApiBaseUrl = @"https://apimeeting.talkmed.com";
    [XSNet1 singleInstance].server.model.developApiBaseUrl = @"https://devapimeeting.talkmed.com";
    
    //自定义错误处理逻辑
    [XSNet1 singleInstance].server.model.errHander = [ErrorHandler1 new];
    
    //通用参数
    [XSNet1 singleInstance].server.model.commonParameter = @{
        @"fuck":@"you"
    };
    
    //动态通用参数：
    SEL sel = @selector(dynamicParams);
    IMP imp = [self methodForSelector:sel];
    [XSNet1 singleInstance].server.model.dynamicParamsIMP = imp;
    
    //错误提示(统一配置)：
    [XSNet1 singleInstance].server.model.errMessageKey = @"message";
    //如果单个请求中设置了，以单个请求优先
    [XSNet1 singleInstance].server.model.errorAlerType = XSAPIAlertType_Toast;
    
    
    self.data = @[@"post请求",@"get请求",@"切换环境",@"单个请求不显示错误提示"];
    
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
}

- (NSDictionary *)dynamicParams {
    return @{
        @"test_uuid":[[NSUUID UUID] UUIDString]
    };
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
            [[XSNet1 singleInstance] postRequest:self param:nil path:@"/v1/login" loadingMsg:@"ooooo" complete:^(id  _Nullable data, NSError *error) {
                NSLog(@"----data:%@",data);
            }];
        }
            break;
        case 1:
        {
            [[XSNet1 singleInstance] getRequest:self param:nil path:@"/time" loadingMsg:@"ooooo" complete:^(id  _Nullable data, NSError *error) {
                NSLog(@"----data:%@",data);
            }];
        }
            break;
        case 2:
        {
            if ([XSNet1 singleInstance].server.model.environmentType == XSEnvTypeRelease) {
                [XSNet1 singleInstance].server.model.environmentType = XSEnvTypeDevelop;
                NSLog(@"切换dev成功");
            } else {
                [XSNet1 singleInstance].server.model.environmentType = XSEnvTypeRelease;
                NSLog(@"切换release成功");
            }
        }
            break;
        case 3:
        {
            [[XSNet1 singleInstance] hideErrorAlert:self param:nil path:@"/v1/login" requestType:XSAPIRequestTypePost loadingMsg:@"ss" complete:^(id  _Nullable data, NSError * _Nullable error) {
                NSLog(@"----data:%@",data);
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
