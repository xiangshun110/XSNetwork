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

0.1.6：

1.增加可以往body里面传一个NSData,在XSNetworkTools里面：

```objective-c
+ (nullable XSBaseDataEngine *)request:(NSObject * _Nonnull)control bodyData:(NSData * _Nullable)bodyData path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType complete:(CompletionDataBlock _Nullable)responseBlock;
```



0.1.5：

1.增加全局设置超时时间（[XSNetworkTools setRequesTimeout:10];）

2.增加单个请求设置超时时间



## License

XSNetwork is available under the MIT license. See the LICENSE file for more info.
