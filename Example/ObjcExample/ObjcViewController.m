//  ObjcViewController.m
//  ObjcExample — 演示在 Objective-C ViewController 中发起网络请求

#import "ObjcViewController.h"
#import "XSNetObjc.h"
@import XSNetwork;

@interface ObjcViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *items;
@end

@implementation ObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ObjC Demo";
    self.view.backgroundColor = [UIColor whiteColor];

    self.items = @[
        @"POST 请求（JSON）",
        @"POST 请求（multipart/form-data）",
        @"GET 请求",
        @"切换环境",
        @"不使用 baseURL 的请求",
        @"文件下载",
        @"简单用法（无需配置）"
    ];

    // 配置模块的环境（在第一次使用前设置）
    [XSNetObjc shared].server.model.environmentType = XSEnvTypeDevelop;

    // 可选：在 window 左上角显示当前环境标签
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window) {
        [[XSNetObjc shared] showEnvTagView:window];
    }

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.frame;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {

        // ── POST（JSON）请求 ──────────────────────────────────────────────
        case 0: {
            NSDictionary *params = @{@"name": @"test", @"age": @18};
            [[XSNetObjc shared] postRequest:self
                                      param:params
                                       path:@"/api/user"
                                 loadingMsg:@"请求中..."
                                   complete:^(id _Nullable data, NSError * _Nullable error) {
                NSLog(@"POST data: %@", data);
            }];
            break;
        }

        // ── POST（multipart/form-data）请求 ──────────────────────────────
        case 1: {
            NSDictionary *params = @{@"username": @"test", @"password": @"123456"};
            [[XSNetObjc shared] postFormDataRequest:self
                                              param:params
                                               path:@"/api/login"
                                         loadingMsg:@"登录中..."
                                           complete:^(id _Nullable data, NSError * _Nullable error) {
                NSLog(@"FormData data: %@", data);
            }];
            break;
        }

        // ── GET 请求 ──────────────────────────────────────────────────────
        case 2: {
            [[XSNetObjc shared] getRequest:self
                                     param:nil
                                      path:@"/api/time"
                                loadingMsg:@"请求中..."
                                  complete:^(id _Nullable data, NSError * _Nullable error) {
                NSLog(@"GET data: %@", data);
            }];
            break;
        }

        // ── 切换环境 ──────────────────────────────────────────────────────
        case 3: {
            XSServerModel *model = [XSNetObjc shared].server.model;
            if (model.environmentType == XSEnvTypeRelease) {
                model.environmentType = XSEnvTypeDevelop;
                NSLog(@"已切换到 develop 环境");
            } else {
                model.environmentType = XSEnvTypeRelease;
                NSLog(@"已切换到 release 环境");
            }
            break;
        }

        // ── 不使用 baseURL（传完整 URL）─────────────────────────────────
        case 4: {
            [[XSNetObjc shared] getRequest:self
                                     param:nil
                                      path:@"https://api.weixin.qq.com/sns/userinfo"
                                loadingMsg:nil
                                  complete:^(id _Nullable data, NSError * _Nullable error) {
                NSLog(@"data: %@", data);
            }];
            break;
        }

        // ── 文件下载 ──────────────────────────────────────────────────────
        case 5: {
            NSString *url = @"https://example.com/file.pdf";
            [[XSNetObjc shared] downloadFile:self
                                         url:url
                                    fileName:@"downloads/file.pdf"
                                    progress:^(NSProgress *progress) {
                float ratio = (float)progress.completedUnitCount / (float)progress.totalUnitCount;
                NSLog(@"下载进度: %.0f%%", ratio * 100);
            } complete:^(id _Nullable data, NSError * _Nullable error) {
                NSLog(@"下载完成，保存路径: %@", data);
            }];
            break;
        }

        // ── 简单用法，无需任何配置（直接传完整 URL）─────────────────────
        case 6: {
            [[XSNetworkTools singleInstance]
                postRequest:self
                      param:nil
                       path:@"https://api.abc.com/user"
                 loadingMsg:@"loading"
                   complete:^(id _Nullable data, NSError * _Nullable error) {
                NSLog(@"data: %@", data);
            }];
            break;
        }

        default:
            break;
    }
}

@end
