# XSNetwork

[![CI Status](https://img.shields.io/travis/shun/XSNetwork.svg?style=flat)](https://travis-ci.org/shun/XSNetwork)
[![Version](https://img.shields.io/cocoapods/v/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)
[![License](https://img.shields.io/cocoapods/l/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)
[![Platform](https://img.shields.io/cocoapods/p/XSNetwork.svg?style=flat)](https://cocoapods.org/pods/XSNetwork)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XSNetwork is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XSNetwork'
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

//设置不要加公共参数的API
[XSNetworkTools setComparamExclude:@[@"http://itunes.apple.com/lookup?id=1148546631"]];

//GET请求
[XSNetworkTools request:self param:nil path:@"http://itunes.apple.com/lookup?id=1148546631" requestType:XSAPIRequestTypeGet complete:^(id data, NSError *error) {
    NSLog(@"======:%@",data);
}];
```

## Author

shun, truma.xiang@edoctor.cn

## License

XSNetwork is available under the MIT license. See the LICENSE file for more info.
