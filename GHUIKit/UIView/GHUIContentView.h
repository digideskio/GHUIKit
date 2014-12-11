//
//  GHUIContentView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 4/1/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

typedef NS_ENUM (NSUInteger, GHUIContentViewPresentationMode) {
  GHUIContentViewPresentationModeDefault = 0,
  GHUIContentViewPresentationModeModal = 1 << 0,
  GHUIContentViewPresentationModeModalSplash = 1 << 1,
};

@class GHUIContentView;

@protocol GHUIViewNavigationDelegate
- (void)pushView:(GHUIContentView *)view animated:(BOOL)animated;
- (void)popViewAnimated:(BOOL)animated;
- (void)swapView:(GHUIContentView *)view animated:(BOOL)animated;
- (void)setViews:(NSArray *)views animated:(BOOL)animated;
- (void)popToRootViewAnimated:(BOOL)animated;
- (UINavigationItem *)navigationItem;
- (UIInterfaceOrientation)interfaceOrientation;
- (UIViewController *)viewController;
- (GHUIContentView *)contentView;

- (void)pushView:(GHUIContentView *)view animation:(id<UIViewControllerAnimatedTransitioning>)animation;

- (void)presentView:(GHUIContentView *)view animation:(id<UIViewControllerAnimatedTransitioning>)animation completion:(void (^)(void))completion;
- (void)presentView:(GHUIContentView *)view modalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle completion:(void (^)(void))completion;

- (id<GHUIViewNavigationDelegate>)presentNavigationView:(GHUIContentView *)contentView animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)dismissViewAnimated:(BOOL)animated completion:(void (^)(void))completion;
@end


@interface GHUIContentView : GHUIView

@property (weak) id<GHUIViewNavigationDelegate> navigationDelegate;

/*!
 Check if view is visible.
 Only available if the contentView in GHUIViewController.
 */
@property (readonly, getter=isVisible) BOOL visible;

/*!
 Title for view.
 Only available if the contentView in GHUIViewController.
 */
@property (nonatomic) NSString *navigationTitle;
@property (nonatomic) NSString *navigationBackTitle;

+ (GHUIContentView *)contentViewForView:(UIView *)view;

#pragma mark -

@property GHUIContentViewPresentationMode presentationMode;

/*!
 Dismisses view if it was presented.
 */
- (void)dismiss;

#pragma mark View Callbacks

- (void)viewWillAppear:(BOOL)animated;

- (void)viewDidAppear:(BOOL)animated;

- (void)viewWillDisappear:(BOOL)animated;

- (void)viewDidDisappear:(BOOL)animated;

- (void)viewDidBecomeActive;
- (void)viewWillResign;

- (void)viewDidLayoutSubviews;
- (void)viewDidLoad;
- (void)viewDidLoadWithLayout;

- (void)viewWillAppearAfterLoad:(BOOL)animated;
- (void)viewDidAppearAfterLoad:(BOOL)animated;

#pragma mark -

- (void)enableActivity;
- (void)disableActivity;
- (void)setError:(NSError *)error;

- (void)setNeedsRefresh;

/*!
 Get top layout guide (from view controller).
 */
- (id<UILayoutSupport>)topLayoutGuide;

@end


@interface GHUICView : GHUIContentView

@property UIView *view;

- (id)initWithView:(UIView *)view;

@end
