//
//  XSProgressHUD.h
//  XSNetwork
//
//  A lightweight HUD implementation that replaces MBProgressHUD,
//  compatible with both iOS and macOS.
//

#import <Foundation/Foundation.h>
#import "XSServerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface XSProgressHUD : NSObject

/// Show an indeterminate spinning indicator on the given view with an optional label.
/// @param view  The view to add the HUD to.
/// @param message  An optional text label. Pass nil or empty string for no label.
/// @return The HUD instance. Call -hideAnimated: when the task completes.
+ (instancetype)showLoadingInView:(XSPlatformView *)view message:(nullable NSString *)message;

/// Hide and remove the HUD from its superview.
- (void)hideAnimated:(BOOL)animated;

/// Show a brief text-only toast near the bottom of the view that auto-hides.
/// @param message  The message to display.
/// @param view  The view to show the toast in.
/// @param delay  Duration in seconds before the toast disappears.
+ (void)showToast:(NSString *)message inView:(XSPlatformView *)view afterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
