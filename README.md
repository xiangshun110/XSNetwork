# XSNetwork

[![CI Status](https://img.shields.io/travis/shun/XSNetwork.svg?style=flat)](https://travis-ci.org/shun/XSNetwork)
[![Version](https://img.shields.io/cocoapods/v/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)
[![License](https://img.shields.io/cocoapods/l/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)
[![Platform](https://img.shields.io/cocoapods/p/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## 说明：

这个库也是在别人的基本上改的（原作者貌似也没维护了），是对AF对AFNetworking 4.0.x的封装，配置灵活，使用方便，满足中小企业的大部分需求。



## Requirements

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

//设置数据回调的统一处理（可以不设置）TestAPIErrorHander需要自己创建，下面我会给个示例
[XSNetworkTools setErrorHander:[TestAPIErrorHander new]];


//设置不要加公共参数的API
[XSNetworkTools setComparamExclude:@[@"http://itunes.apple.com/lookup?id=1148546631"]];

//GET请求
[XSNetworkTools request:self param:nil path:@"http://itunes.apple.com/lookup?id=1148546631" requestType:XSAPIRequestTypeGet complete:^(id data, NSError *error) {
    NSLog(@"======:%@",data);
}];




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

shun, 113648883@qq.com

## License

XSNetwork is available under the MIT license. See the LICENSE file for more info.
