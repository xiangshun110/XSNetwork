#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import <XSNetwork/XSAPIBaseRequestDataModel.h>
#import <XSNetwork/XSAPIResponseErrorHandler.h>
#import <XSNetwork/XSAPIURLRequestGenerator.h>
#import <XSNetwork/XSAppContext.h>
#import <XSNetwork/XSErrorHanderResult.h>
#import <XSNetwork/XSignatureGenerator.h>
#import <XSNetwork/XSNetworkingAutoCancelRequests.h>
#import <XSNetwork/XSBaseDataEngine.h>
#import <XSNetwork/NSObject+XSNetWorkingAutoCancel.h>
#import <XSNetwork/NSString+XSUtilNetworking.h>
#import <XSNetwork/UIDevice+XSUtilNetworking.h>
#import <XSNetwork/XSMainServer.h>
#import <XSNetwork/XSBaseServers.h>
#import <XSNetwork/XSServerFactory.h>
#import <XSNetwork/XSAPIClient.h>
#import <XSNetwork/XSServerModel.h>
#import <XSNetwork/XSCustomResponseSerializer.h>
#import <XSNetwork/XSNetwork.h>
#import <XSNetwork/XSNetworkTools.h>
#import <XSNetwork/XSServerConfig.h>

FOUNDATION_EXPORT double XSNetworkVersionNumber;
FOUNDATION_EXPORT const unsigned char XSNetworkVersionString[];

