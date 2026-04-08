//
//  XSProgressHUD.m
//  XSNetwork
//

#import "XSProgressHUD.h"

static const CGFloat kXSHUDBezelPadding       = 16.0;
static const CGFloat kXSHUDCornerRadius        = 10.0;
static const CGFloat kXSHUDIndicatorSize       = 37.0;
static const CGFloat kXSHUDLabelFontSize       = 14.0;
static const CGFloat kXSHUDMaxBezelWidth       = 200.0;
static const CGFloat kXSHUDAnimationDuration   = 0.25;
static const CGFloat kXSHUDToastBottomOffset   = 60.0;

@interface XSProgressHUD ()
@property (nonatomic, strong) XSPlatformView *containerView;
@end

@implementation XSProgressHUD

+ (instancetype)showLoadingInView:(XSPlatformView *)view message:(NSString *)message {
    if (!view) return nil;
    XSProgressHUD *hud = [[XSProgressHUD alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud _showLoadingInView:view message:message];
    });
    return hud;
}

- (void)hideAnimated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _hideAnimated:animated];
    });
}

+ (void)showToast:(NSString *)message inView:(XSPlatformView *)view afterDelay:(NSTimeInterval)delay {
    if (!view || message.length == 0) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _showToast:message inView:view afterDelay:delay];
    });
}

// ---------------------------------------------------------------------------
#pragma mark - Platform-specific implementation
// ---------------------------------------------------------------------------

#if TARGET_OS_IPHONE

- (void)_showLoadingInView:(UIView *)view message:(NSString *)message {
    UIView *overlay = [[UIView alloc] initWithFrame:view.bounds];
    overlay.backgroundColor = [UIColor clearColor];
    // Match original MBProgressHUD behaviour: does not consume touches
    overlay.userInteractionEnabled = NO;
    overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.containerView = overlay;

    UIView *bezel = [self _makeBezelWithMessage:message boundsSize:view.bounds.size offsetX:0 offsetY:0];
    [overlay addSubview:bezel];

    overlay.alpha = 0;
    [view addSubview:overlay];
    [UIView animateWithDuration:kXSHUDAnimationDuration animations:^{
        overlay.alpha = 1.0;
    }];
}

- (UIView *)_makeBezelWithMessage:(NSString *)message
                        boundsSize:(CGSize)boundsSize
                           offsetX:(CGFloat)offsetX
                           offsetY:(CGFloat)offsetY {
    UIView *bezel = [[UIView alloc] init];
    bezel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    bezel.layer.cornerRadius = kXSHUDCornerRadius;
    bezel.clipsToBounds = YES;

    UIActivityIndicatorView *indicator;
    if (@available(iOS 13.0, *)) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        indicator.color = [UIColor whiteColor];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
#pragma clang diagnostic pop
    }
    [indicator startAnimating];

    CGFloat bezelWidth  = kXSHUDBezelPadding * 2 + kXSHUDIndicatorSize;
    CGFloat bezelHeight = kXSHUDBezelPadding * 2 + kXSHUDIndicatorSize;

    UILabel *label = nil;
    if (message.length > 0) {
        label = [[UILabel alloc] init];
        label.text = message;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:kXSHUDLabelFontSize];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;

        CGFloat maxW = kXSHUDMaxBezelWidth - kXSHUDBezelPadding * 2;
        CGSize ts = [message boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName: label.font}
                                          context:nil].size;
        CGFloat labelW = ceil(ts.width);
        CGFloat labelH = ceil(ts.height);

        bezelWidth  = MIN(MAX(bezelWidth, labelW + kXSHUDBezelPadding * 2), kXSHUDMaxBezelWidth);
        bezelHeight += kXSHUDBezelPadding / 2 + labelH;

        label.frame = CGRectMake(kXSHUDBezelPadding,
                                 kXSHUDBezelPadding + kXSHUDIndicatorSize + kXSHUDBezelPadding / 2,
                                 bezelWidth - kXSHUDBezelPadding * 2,
                                 labelH);
        [bezel addSubview:label];
    }

    bezel.frame = CGRectMake(0, 0, bezelWidth, bezelHeight);
    indicator.frame = CGRectMake((bezelWidth - kXSHUDIndicatorSize) / 2,
                                 kXSHUDBezelPadding,
                                 kXSHUDIndicatorSize,
                                 kXSHUDIndicatorSize);
    [bezel addSubview:indicator];

    bezel.center = CGPointMake(boundsSize.width / 2 + offsetX, boundsSize.height / 2 + offsetY);
    bezel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleRightMargin |
                             UIViewAutoresizingFlexibleTopMargin   | UIViewAutoresizingFlexibleBottomMargin;
    return bezel;
}

- (void)_hideAnimated:(BOOL)animated {
    UIView *view = self.containerView;
    if (!view) return;
    self.containerView = nil;
    if (animated) {
        [UIView animateWithDuration:kXSHUDAnimationDuration animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    } else {
        [view removeFromSuperview];
    }
}

+ (void)_showToast:(NSString *)message inView:(UIView *)view afterDelay:(NSTimeInterval)delay {
    UIView *toastView = [[UIView alloc] init];
    toastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    toastView.layer.cornerRadius = kXSHUDCornerRadius;
    toastView.clipsToBounds = YES;
    toastView.userInteractionEnabled = NO;

    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:kXSHUDLabelFontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;

    CGFloat maxW = MIN(view.bounds.size.width - 40.0, kXSHUDMaxBezelWidth);
    CGSize ts = [message boundingRectWithSize:CGSizeMake(maxW - kXSHUDBezelPadding * 2, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: label.font}
                                      context:nil].size;
    CGFloat toastW = ceil(ts.width) + kXSHUDBezelPadding * 2;
    CGFloat toastH = ceil(ts.height) + kXSHUDBezelPadding * 2;
    CGFloat toastX = (view.bounds.size.width - toastW) / 2;
    CGFloat toastY = view.bounds.size.height - toastH - kXSHUDToastBottomOffset;

    toastView.frame = CGRectMake(toastX, toastY, toastW, toastH);
    label.frame = CGRectMake(kXSHUDBezelPadding, kXSHUDBezelPadding,
                             toastW - kXSHUDBezelPadding * 2, toastH - kXSHUDBezelPadding * 2);
    [toastView addSubview:label];

    toastView.alpha = 0;
    [view addSubview:toastView];
    [UIView animateWithDuration:kXSHUDAnimationDuration animations:^{
        toastView.alpha = 1.0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:kXSHUDAnimationDuration animations:^{
                toastView.alpha = 0;
            } completion:^(BOOL f) {
                [toastView removeFromSuperview];
            }];
        });
    }];
}

#else // macOS

- (void)_showLoadingInView:(NSView *)view message:(NSString *)message {
    NSView *overlay = [[NSView alloc] initWithFrame:view.bounds];
    overlay.wantsLayer = YES;
    overlay.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    self.containerView = overlay;

    NSView *bezel = [self _makeBezelWithMessage:message boundsSize:view.bounds.size offsetX:0 offsetY:0];
    [overlay addSubview:bezel];

    overlay.alphaValue = 0;
    [view addSubview:overlay];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = kXSHUDAnimationDuration;
        overlay.animator.alphaValue = 1.0;
    }];
}

- (NSView *)_makeBezelWithMessage:(NSString *)message
                        boundsSize:(CGSize)boundsSize
                           offsetX:(CGFloat)offsetX
                           offsetY:(CGFloat)offsetY {
    NSView *bezel = [[NSView alloc] init];
    bezel.wantsLayer = YES;
    bezel.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    bezel.layer.cornerRadius = kXSHUDCornerRadius;

    NSProgressIndicator *indicator = [[NSProgressIndicator alloc] init];
    indicator.style = NSProgressIndicatorStyleSpinning;
    indicator.controlSize = NSControlSizeRegular;
    [indicator startAnimation:nil];

    CGFloat bezelWidth  = kXSHUDBezelPadding * 2 + kXSHUDIndicatorSize;
    CGFloat bezelHeight = kXSHUDBezelPadding * 2 + kXSHUDIndicatorSize;

    NSTextField *label = nil;
    if (message.length > 0) {
        label = [NSTextField labelWithString:message];
        label.textColor = [NSColor whiteColor];
        label.font = [NSFont systemFontOfSize:kXSHUDLabelFontSize];
        label.alignment = NSTextAlignmentCenter;
        label.backgroundColor = [NSColor clearColor];

        CGFloat maxW = kXSHUDMaxBezelWidth - kXSHUDBezelPadding * 2;
        CGSize ts = [message boundingRectWithSize:NSMakeSize(maxW, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName: label.font}
                                          context:nil].size;
        CGFloat labelW = ceil(ts.width);
        CGFloat labelH = ceil(ts.height);

        bezelWidth  = MIN(MAX(bezelWidth, labelW + kXSHUDBezelPadding * 2), kXSHUDMaxBezelWidth);
        // macOS: y origin is bottom-left; label at bottom, indicator above
        label.frame = NSMakeRect(kXSHUDBezelPadding, kXSHUDBezelPadding,
                                 bezelWidth - kXSHUDBezelPadding * 2, labelH);
        [bezel addSubview:label];

        CGFloat indicatorY = kXSHUDBezelPadding + labelH + kXSHUDBezelPadding / 2;
        indicator.frame = NSMakeRect((bezelWidth - kXSHUDIndicatorSize) / 2,
                                     indicatorY,
                                     kXSHUDIndicatorSize, kXSHUDIndicatorSize);
        bezelHeight = indicatorY + kXSHUDIndicatorSize + kXSHUDBezelPadding;
    } else {
        indicator.frame = NSMakeRect((bezelWidth - kXSHUDIndicatorSize) / 2,
                                     kXSHUDBezelPadding,
                                     kXSHUDIndicatorSize, kXSHUDIndicatorSize);
    }
    [bezel addSubview:indicator];

    CGFloat bezelX = boundsSize.width  / 2 + offsetX - bezelWidth  / 2;
    CGFloat bezelY = boundsSize.height / 2 + offsetY - bezelHeight / 2;
    bezel.frame = NSMakeRect(bezelX, bezelY, bezelWidth, bezelHeight);
    bezel.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin |
                             NSViewMinYMargin | NSViewMaxYMargin;
    return bezel;
}

- (void)_hideAnimated:(BOOL)animated {
    NSView *view = self.containerView;
    if (!view) return;
    self.containerView = nil;
    if (animated) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = kXSHUDAnimationDuration;
            view.animator.alphaValue = 0;
        } completionHandler:^{
            [view removeFromSuperview];
        }];
    } else {
        [view removeFromSuperview];
    }
}

+ (void)_showToast:(NSString *)message inView:(NSView *)view afterDelay:(NSTimeInterval)delay {
    NSView *toastView = [[NSView alloc] init];
    toastView.wantsLayer = YES;
    toastView.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    toastView.layer.cornerRadius = kXSHUDCornerRadius;

    NSTextField *label = [NSTextField labelWithString:message];
    label.textColor = [NSColor whiteColor];
    label.font = [NSFont systemFontOfSize:kXSHUDLabelFontSize];
    label.alignment = NSTextAlignmentCenter;
    label.backgroundColor = [NSColor clearColor];

    CGFloat maxW = MIN(view.bounds.size.width - 40.0, kXSHUDMaxBezelWidth);
    CGSize ts = [message boundingRectWithSize:NSMakeSize(maxW - kXSHUDBezelPadding * 2, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: label.font}
                                      context:nil].size;
    CGFloat toastW = ceil(ts.width) + kXSHUDBezelPadding * 2;
    CGFloat toastH = ceil(ts.height) + kXSHUDBezelPadding * 2;
    CGFloat toastX = (view.bounds.size.width - toastW) / 2;
    // macOS: y from bottom-left
    CGFloat toastY = kXSHUDToastBottomOffset;

    toastView.frame = NSMakeRect(toastX, toastY, toastW, toastH);
    label.frame = NSMakeRect(kXSHUDBezelPadding, kXSHUDBezelPadding,
                             toastW - kXSHUDBezelPadding * 2, toastH - kXSHUDBezelPadding * 2);
    [toastView addSubview:label];

    toastView.alphaValue = 0;
    [view addSubview:toastView];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = kXSHUDAnimationDuration;
        toastView.animator.alphaValue = 1.0;
    } completionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                context.duration = kXSHUDAnimationDuration;
                toastView.animator.alphaValue = 0;
            } completionHandler:^{
                [toastView removeFromSuperview];
            }];
        });
    }];
}

#endif // TARGET_OS_IPHONE

@end
