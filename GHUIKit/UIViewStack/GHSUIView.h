//
//  GHSUIView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"
#import "GHUINavigationBar.h"
#import "GHUIButton.h"

@class GHUIViewStack;

enum {
  GHSUIViewAnimationOptionTransitionCrossDissolve = 1 << 9,
  GHSUIViewAnimationOptionTransitionSlide = 1 << 12,
  GHSUIViewAnimationOptionTransitionSlideOver = 1 << 13,
};
typedef NSUInteger GHSUIViewAnimationOptions;

@interface GHSUIView : GHUIView

/*!
 Navigation bar.
 */
@property (readonly, nonatomic) GHUINavigationBar *navigationBar;

/*!
 View stack.
 */
@property (assign, nonatomic) GHUIViewStack *stack;

/*!
 @result YES if visible
 */
@property (readonly, nonatomic, getter=isVisible) BOOL visible;

/*!
 View (content). Optional.
 */
@property (retain, nonatomic) UIView *view;

/*!
 Create stack view with sub view.
 @param view
 @result View for stack
 */
+ (GHSUIView *)viewWithView:(UIView *)view;

/*!
 Create stack view with sub view.
 @param view
 @param title Navigation title
 @result View for stack
 */
+ (GHSUIView *)viewWithView:(UIView *)view title:(NSString *)title;

/*!
 Push view.
 @param view
 @param duration
 @param options
 */
- (void)pushView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options;

/*!
 Push view, sliding in.
 @param view
 @param animated
 */
- (void)pushView:(GHSUIView *)view animated:(BOOL)animated;

/*!
 Pop view, sliding out.
 @param animated
 */
- (void)popViewAnimated:(BOOL)animated;

/*!
 Set the main view.
 @param view
 @param duration
 @param options
 */
- (void)setView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options;

/*!
 Swap the current view.
 @param view
 @param animated
 */
- (void)swapView:(GHSUIView *)view animated:(BOOL)animated;

/*!
 Swap the current view with transition.
 @param view
 @param duration
 @param options
 */
- (void)swapView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options;

/*!
 Pop to view.
 @param view
 @param duration
 @param options
 */
- (void)popToView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options;

/*!
 Pop self.
 @param duration
 @param options
 */
- (void)popViewWithDuration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options;

/*!
 @result YES if root view
 */
- (BOOL)isRootView;

/*!
 @result YES if visible view
 */
- (BOOL)isVisibleView;

/*!
 Set navigation title.
 */
- (void)setNavigationTitle:(NSString *)title animated:(BOOL)animated;

/*!
 Set navigation button with title.
 @param title
 @param iconImage
 @param position
 @param style
 @param animated
 */
- (GHUIButton *)setNavigationButtonWithTitle:(NSString *)title iconImage:(UIImage *)iconImage position:(GHUINavigationPosition)position style:(GHUINavigationButtonStyle)style animated:(BOOL)animated targetBlock:(GHUIControlTargetBlock)targetBlock;

/*!
 Apply style for navigation button.
 Subclasses should override.
 */
- (void)applyStyleForNavigationButton:(GHUIButton *)button style:(GHUINavigationButtonStyle)style;

/*!
 Apply style for navigation bar.
 Subclasses should override.
 */
- (void)applyStyleForNavigationBar:(GHUINavigationBar *)navigationBar;

/*!
 View will appear.
 @param animated
 */
- (void)viewWillAppear:(BOOL)animated;

/*!
 View did appear.
 @param animated
 */
- (void)viewDidAppear:(BOOL)animated;

/*!
 View will disappear.
 @param animated
 */
- (void)viewWillDisappear:(BOOL)animated;

/*!
 View did disappear.
 @param animated
 */
- (void)viewDidDisappear:(BOOL)animated;

/*!
 Refresh. On success, you should call self.needsRefresh = NO;
 */
- (void)refresh;

/*!
 Set needs refresh. If visible, will call refresh.
 */
- (void)setNeedsRefresh;

#pragma mark Private

- (void)_viewWillAppear:(BOOL)animated;

- (void)_viewDidAppear:(BOOL)animated;

- (void)_viewWillDisappear:(BOOL)animated;

- (void)_viewDidDisappear:(BOOL)animated;

@end


