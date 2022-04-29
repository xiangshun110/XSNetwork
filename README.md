# XSNetwork

[![CI Status](https://img.shields.io/travis/shun/XSNetwork.svg?style=flat)](https://travis-ci.org/shun/XSNetwork)
[![Version](https://img.shields.io/cocoapods/v/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)
[![License](https://img.shields.io/cocoapods/l/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)
[![Platform](https://img.shields.io/cocoapods/p/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## 说明：

这个库也是在别人的基本上改的（原作者貌似也没维护了），是对AF对AFNetworking 4.0.x的封装，配置灵活，使用方便，满足中小企业的大部分需求。

特点：

1. 可配置多换环境，可随时切换环境
2. VC销毁时自动取消没完成的网络请求
3. 可设置公共参数，可设置不要公共参数的URL
4. 静态方法调用，使用方便
5. 支持全局配置超时时间和单个请求设置超时时间
5. 支持各个模块可以独立配置baseurl等，便于模块化开发

## Requirements

依赖的第三方库：

- 'AFNetworking', '~> 4.0.1'
- 'MBProgressHUD', '~> 1.2.0'

如果你的项目中有使用者两个库，只要版本大于等于这个版本就可以

## Installation

XSNetwork is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XSNetwork'
```

## 使用：

###### 1.简单用法，无需任何配置

```objective-c
//简单用法：
#import <XSNetworkTools.h>

[[XSNetworkTools singleInstance] postRequest:self param:nil path:@"https://api.abc.com/user" loadingMsg:@"loading" complete:^(id  _Nullable data, NSError * _Nullable error) {
    NSLog(@"---data:%@",data);
}];  
```



###### 2.高级用法

```objective-c
//高级用法（可以参考demo）
1.新建一个类，继承XSNetworkTools：
@interface XSNet : XSNetworkTools
+ (instancetype)share;
@end
    
@implementation XSNet

//必须重写这个方法，这个名字用于区分各个模块，使各个模块的请求和配置互不影响
- (NSString *)serverName {
    return @"server1";
}

//如果要用单例，必须写一个单例方法
+ (instancetype)share
{
    static dispatch_once_t onceToken;
    static XSNet *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XSNet alloc] init];
        [sharedInstance config];
    });
    return sharedInstance;
}

- (void)config {
    //配置baseURL，最好是配置，不然每次请求都要写全量url
    self.server.model.releaseApiBaseUrl = @"https://api.abc.com";
    self.server.model.developApiBaseUrl = @"https://devapi.abc.com";
    
    //自定义错误处理逻辑,ErrorHandler1在example里面有
    self.server.model.errHander = [ErrorHandler1 new];
    
    //通用参数
    [XSNet1 share].server.model.commonParameter = @{
        @"fuck":@"you"
    };
    
    //动态通用参数：
    SEL sel = @selector(dynamicParams);
    IMP imp = [self methodForSelector:sel];
    self.server.model.dynamicParamsIMP = imp;
    
    //错误提示(统一配置)：
    self.server.model.errMessageKey = @"message";
    //如果单个请求中设置了，以单个请求优先
    self.server.model.errorAlerType = XSAPIAlertType_Toast;
}

//动态通用参数
- (NSDictionary *)dynamicParams {
    return @{
        @"test_uuid":[[NSUUID UUID] UUIDString]
    };
}

@end
    
    
2. 使用
- (void)viewDidLoad {
    [super viewDidLoad];

    //切换环境
    //默认是XSEnvTypeRelease
    [XSNet share].server.model.environmentType = XSEnvTypeDevelop;

    //来一个请求试试：
    [[XSNet share] postRequest:self param:nil path:@"/login" loadingMsg:@"ooooo" complete:^(id  _Nullable data, NSError *error) {
        NSLog(@"----data:%@",data);
    }];
}

  
```



## Author

向顺, 113648883@qq.com

## 版本更新记录

#### 0.2.2

------

1.XSNetworkTools调整


## 版本更新记录

#### 0.2.1

------

1.上传文件设置为不超时


#### 0.2.0

------

1.大调整，支持各个模块可以独立配置baseurl等，便于模块化开发



#### 0.1.19

------

1.XSNetworkTools中增加1个方法，多了一个loadingMsg，用于显示loading：

```objective-c
/**
 网络请求

 @param control self
 @param param 参数
 @param path URL
 @param requestType YAAPIManagerRequestTypeGet/YAAPIManagerRequestTypePost
 @param loadingMsg 不为nil的话会显示一个loading,请求完成后自动消失，loadingView显示在control的view上，如果control不是UIview和UIViewController，就不显示
 @param responseBlock 回调
 @return 返回
 */
+ (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType loadingMsg:(NSString * _Nonnull)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock;
```





#### 0.1.13

------

1.增加1个方法（setDynamicParamsIMP）：

```objective-c
/// 这里可以设置一个动态参数的方法，与setComparam不同的是，setComparam设置后，里面的key和value是不能改变的，除非你再调用setComparam方法，这个是每次请求都会调用一次生成参数的方法
/// 比如要在所有的请求都是一个时间戳参数，就可以这样：
/// 在你的某个类中写个实例方式：
/// - (NSDictionary *)generateParams {
///     return @{
///         @"time":@([[NSDate date] timeIntervalSince1970])
///     };
/// }
/// SEL sel = @selector(generateParams);
/// IMP imp = [self methodForSelector:sel];
/// 这样就得到了一个IMP,注意实例方法的返回一定要是NSDictionary，并且不能有参数
/// 返回值NSDictionary里面所有的key都会被家都请求里面的参数
/// @param imp imp
+ (void)setDynamicParamsIMP:(IMP _Nonnull )imp;
```







#### 0.1.12

------

1.增加2个方法（setToastView可以用了）：

```objective-c
/// 请求错误时弹出消息的方式,默认不弹出，XSAPIAlertType_None
/// @param errorAlerType type
+ (void)setErrorAlerType:(XSAPIAlertType)errorAlerType;


/// 设置获取错误消息的key,默认是message
/// @param messageKey keu
+ (void)setErrorMessageKey:(NSString *_Nonnull)messageKey;
```



#### 0.1.11

------

1.增加一个方法(暂时没用到)：

```objective-c
/// 设置弹出toast的视图
/// @param view UIview
+ (void)setToastView:(UIView *_Nonnull)view;
```



#### 0.1.10

------

1.增加可以往body里面传一个NSData,在XSNetworkTools里面：

```objective-c
+ (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control bodyData:(NSData * _Nullable)bodyData path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType complete:(CompletionDataBlock _Nullable)responseBlock;
```



#### 0.1.5

------

1.增加全局设置超时时间（[XSNetworkTools setRequesTimeout:10];）

2.增加单个请求设置超时时间



## License

XSNetwork is available under the MIT license. See the LICENSE file for more info.
