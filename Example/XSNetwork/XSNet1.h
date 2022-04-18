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

+ (instancetype _Nonnull )singleInstance;


- (nullable XSBaseDataEngine *)hideErrorAlert:(NSObject * _Nonnull)control param:(NSDictionary * _Nullable)param path:(NSString * _Nonnull)path requestType:(XSAPIRequestType)requestType loadingMsg:(NSString * _Nonnull)loadingMsg complete:(CompletionDataBlock _Nullable)responseBlock;

@end

NS_ASSUME_NONNULL_END
