//
//  XSNet1.h
//  XSNetwork_Example
//
//  Created by shun on 2022/4/18.
//  Copyright © 2022 shun. All rights reserved.
//

#import <XSNetworkTools.h>

NS_ASSUME_NONNULL_BEGIN

@interface XSNet1 : XSNetworkTools

+ (instancetype _Nonnull )share;


- (nullable XSBaseDataEngine *)hideErrorAlert:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType loadingMsg:(NSString * _Nonnull)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock;



/// 上传图片
/// @param control control description
/// @param path path description
/// @param image image description
/// @param params params description
/// @param dataName dataName description
/// @param progress progress description
/// @param responseBlok responseBlok description
- (XSBaseDataEngine *)uploadImage:(NSObject *)control path:(NSString *)path image:(UIImage *)image params:(NSDictionary * _Nullable)params dataName:(NSString *)dataName progress:(ProgressBlock)progress complete:(CompletionDataBlock _Nullable)responseBlok;



/// 下载图片
/// @param control control description
/// @param imgPath imgPath description
/// @param progress progress description
/// @param responseBlock responseBlock description
- (XSBaseDataEngine *)downloadImage:(NSObject *)control imgPath:(NSString *)imgPath progress:(ProgressBlock _Nullable)progress complete:(CompletionDataBlock)responseBlock;

@end

NS_ASSUME_NONNULL_END
