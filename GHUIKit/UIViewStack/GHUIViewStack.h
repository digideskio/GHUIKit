//
//  GHUIViewStack.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHSUIView.h"

@interface GHUIViewStack : NSObject {
  NSMutableArray *_stack;
}

/*!
 Default options for push and pop, for pushView:animated: and popViewAnimated:.
 */
@property (assign, nonatomic) GHSUIViewAnimationOptions defaultOptions;

@property (assign, nonatomic, getter=isAnimating) BOOL animating;

/*!
 Default duration.
 */
@property (assign, nonatomic) NSTimeInterval defaultDuration;

@property (readonly, nonatomic) UIView *parentView;


- (id)initWithParentView:(UIView *)parentView;

- (void)pushView:(GHSUIView *)view animated:(BOOL)animated;

- (void)popView:(GHSUIView *)view animated:(BOOL)animated;

- (void)pushView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options;

- (void)setView:(GHSUIView *)view;
- (void)setView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options;

- (void)popView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options;

- (void)popToView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options;

- (void)swapView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options;

- (GHSUIView *)visibleView;

- (BOOL)isRootView:(GHSUIView *)view;

- (BOOL)isVisibleView:(GHSUIView *)view;

- (NSInteger)indexOfView:(GHSUIView *)view;

@end