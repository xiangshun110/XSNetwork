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

#import "XSAPIBaseRequestDataModel.h"
#import "XSAPIResponseErrorHandler.h"
#import "XSAPIURLRequestGenerator.h"
#import "XSAppContext.h"
#import "XSErrorHanderResult.h"
#import "XSignatureGenerator.h"
#import "XSNetworkingAutoCancelRequests.h"
#import "XSBaseDataEngine.h"
#import "NSObject+XSNetWorkingAutoCancel.h"
#import "NSString+XSUtilNetworking.h"
#import "UIDevice+XSUtilNetworking.h"
#import "XSMainServer.h"
#import "XSBaseServers.h"
#import "XSServerFactory.h"
#import "XSAPIClient.h"
#import "XSCustomResponseSerializer.h"
#import "XSNetworkTools.h"
#import "XSServerConfig.h"

FOUNDATION_EXPORT double XSNetworkVersionNumber;
FOUNDATION_EXPORT const unsigned char XSNetworkVersionString[];

