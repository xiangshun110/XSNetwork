//
//  XSViewController2.m
//  XSNetwork_Example
//
//  Created by shun on 2022/4/18.
//  Copyright © 2022 shun. All rights reserved.
//

#import "XSViewController2.h"
#import <XSNetworkTools.h>

@interface XSViewController2 ()

//@property (nonatomic, strong) XSNet2 *net;

@end

@implementation XSViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"what";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[XSNetworkTools singleInstance] postRequest:self param:nil path:@"https://api.weixin.qq.com/sns/userinfo" loadingMsg:@"ss" complete:^(id  _Nullable data, NSError * _Nullable error) {
        NSLog(@"---data:%@",data);
    }];
}

- (void)dealloc
{
    NSLog(@"-----dealloc:%@",[self class]);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
