//
//  WSAdSpace.h
//  Widespace-SDK-iOS
//  Version: 4.0
//  Copyright (c) 2012 Widespace . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class WSAdSpace;
@class WSAdManager;
@class WSModalViewController;
@protocol WSAdSpaceDelegate;

@interface WSAdSpace: UIView <UIWebViewDelegate>
{
    WSAdManager *adManager;
    id <WSAdSpaceDelegate> delegate;
}
@property (nonatomic, assign) id <WSAdSpaceDelegate> delegate;
- (id)initWithFrame:(CGRect)frame sid:(NSString *)sid autoUpdate:(BOOL)autoUpdate autoStart:(BOOL)autoStart delegate:(id <WSAdSpaceDelegate>)adSpaceDelegate;
- (void)prefetchAd;
- (void)runAd;
- (void)pause;
- (void)resume;
- (void)setSid:(NSString *)sid;
- (NSString *)getSid;
- (void)setAdSpacePosition:(CGPoint)point;
- (void)setAdSpaceFrame:(CGRect)frame;
- (void)setRegulatedMode:(BOOL)RegulatedMode;
- (void)setCustomParameters:(NSDictionary *)keyValue;
- (BOOL)isAutoUpdating;
- (void)clearQueue;
- (void)setQueueSize:(int)size;
- (NSMutableDictionary *)getCurrentAdDescription;
- (NSMutableDictionary *)getNextAdDescription;
- (WSModalViewController *)modalViewController;
@end

@protocol WSAdSpaceDelegate <NSObject>
@required
- (UIViewController *)rootViewController;
@optional
- (void)willCloseAd:(WSAdSpace *)adSpace adType:(NSString *)adType;
- (void)didCloseAd:(WSAdSpace *)adSpace adType:(NSString *)adType;
- (void)willLoadAd:(WSAdSpace *)adSpace;
- (void)didLoadAd:(WSAdSpace *)adSpace adType:(NSString *)adType;
- (void)willStartMedia:(WSAdSpace *)adSpace mediaType:(NSString *)mediaType;
- (void)didStopMedia:(WSAdSpace *)adSpace mediaType:(NSString *)mediaType;
- (void)didCompleteMedia:(WSAdSpace *)adSpace mediaType:(NSString *)mediaType;
- (void)didReceiveNoAd:(WSAdSpace *)adSpace;
- (void)didFailWithError:(WSAdSpace *)adSpace type:(NSString *)type message:(NSString *)message error:(NSError *)error;
- (void)didExpandAd:(WSAdSpace *)adSpace expandDirection:(NSString *)expandDirection finalWidth:(CGFloat)finalWidth finalHeight:(CGFloat)finalHeight;
- (void)didCollapseAd:(WSAdSpace *)adSpace collapsedDirection:(NSString *)collapsedDirection finalWidth:(CGFloat)finalWidth finalHeight:(CGFloat)finalHeight;
- (void)didPrefetchAd:(WSAdSpace *)adSpace mediaStatus:(NSString *)mediaStatus;
- (void)willAnimateOut:(WSAdSpace *)adSpace;
- (void)didAnimateOut:(WSAdSpace *)adSpace;
- (void)willAnimateIn:(WSAdSpace *)adSpace;
- (void)didAnimateIn:(WSAdSpace *)adSpace;
@end
