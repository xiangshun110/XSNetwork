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
or
pod 'XSNetwork' , :git => 'http://nasxs.cn:32769/xiangshun/XSNetwork.git'
```

## 使用：
```objective-c
//配置base URL
[XSNetworkTools setBaseURLWithRelease:@"https://api.abc.com" dev:@"https://devapi.abc.com" preRelease:@"https://preapi.abc.com"];

//切换环境，EXSEnvTypeDevelop对应上面的https://devapi.abc.com，这个切换是存在NSUserDefaults里面的
[XSNetworkTools changeEnvironmentType:XSEnvTypeDevelop];

//设置公共参数
[XSNetworkTools setComparam:@{
    @"token":@"dasdasdas"
}];

//设置数据回调的统一处理（可以不设置）TestAPIErrorHander需要自己创建，下面有示例代码
[XSNetworkTools setErrorHander:[TestAPIErrorHander new]];


//设置不要加公共参数的API
[XSNetworkTools setComparamExclude:@[@"http://itunes.apple.com/lookup?id=1148546631"]];

//设置全局超时时间（不设置默认25秒）
[XSNetworkTools setRequesTimeout:10];

//-------------  以上配置只需要配置一次  --------------

//GET请求
[XSNetworkTools request:self param:nil path:@"http://itunes.apple.com/lookup?id=1148546631" requestType:XSAPIRequestTypeGet complete:^(id data, NSError *error) {
    NSLog(@"======:%@",data);
}];

//注意，上面方法的第一个参数，可以使任何Object, 当这个参数被销毁时，如果请求还没完成，会自动取消请求，所以最好传当前VC



----------分割线--------------


//TestAPIErrorHander类示例：
  

//============== h文件开始 ==============

#import <Foundation/Foundation.h>
#import "XSAPIResponseErrorHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestAPIErrorHander : XSAPIResponseErrorHandler

@end

NS_ASSUME_NONNULL_END
  
//---------- h文件结束 -------------
 

  
//============== m文件开始 ==============
#import "TestAPIErrorHander.h"

@interface TestAPIErrorHander()

@end

@implementation TestAPIErrorHander

- (XSErrorHanderResult *)errorHandlerWithRequestDataModel:(XSAPIBaseRequestDataModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error {
    
    XSErrorHanderResult *xsResult = [XSErrorHanderResult new];
    
    if (error) {
        xsResult.error = error;
        return xsResult;
    } else {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            int errorCode = [[responseObject objectForKey:@"code"] intValue];
            if (errorCode == 0) { 
                return xsResult;
            } else { 
              	//不等于0就生成一个新的error
                NSString *message = @"请求失败";
                if ([responseObject isKindOfClass:[NSDictionary class]]){
                    message = responseObject[@"message"];
                }
                NSError *newError = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:message,@"data":responseObject?responseObject:@{},@"URL":responseURL.URL.absoluteString}];
                xsResult.error = newError;
                //----------其他逻辑
                return xsResult;
            }
        } else {
            xsResult.error = error;
            return xsResult;
        }
    }
}

@end
//---------- m文件结束 -------------
  
```

## Author

向顺, 113648883@qq.com



## 版本更新记录

#### 0.1.15

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
