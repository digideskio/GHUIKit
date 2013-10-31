//
//  GHUIViewStack.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIViewStack.h"
#import "GHCGUtils.h"
#import "GHSUIInternalView.h"
#import <QuartzCore/QuartzCore.h>
#import <GHKit/GHKit.h>

@implementation GHUIViewStack

@synthesize defaultOptions=_defaultOptions, defaultDuration=_defaultDuration, animating=_animating;

- (id)init {
  if ((self = [super init])) {
    _stack = [[NSMutableArray alloc] init];
    _defaultOptions = GHSUIViewAnimationOptionTransitionSlide|GHSUIViewAnimationOptionCurveLinear;
    _defaultDuration = 0.25;
  }
  return self;
}

- (id)initWithParentView:(UIView *)parentView {
  if ((self = [self init])) {
    _parentView = parentView;
  }
  return self;
}

- (void)pushView:(GHSUIView *)view animated:(BOOL)animated {
  [self pushView:view duration:(animated ? _defaultDuration : 0) options:(animated ? _defaultOptions : 0)];
}

- (void)popView:(GHSUIView *)view animated:(BOOL)animated {
  [self popView:view duration:(animated ? _defaultDuration : 0) options:(animated ? _defaultOptions : 0)];
}

- (void)pushView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  GHSUIInternalView *fromInternalView = [_stack lastObject];
  [self _addView:view fromInternalView:fromInternalView duration:duration options:options];
}

- (void)_removeInBetweenIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
  // Remove intermediate views
  // TODO(gabe): This seems out of order
  NSInteger intermediateCount = fromIndex - toIndex - 1;
  if (intermediateCount > 0) {
    NSArray *viewsToRemove = [_stack subarrayWithRange:NSMakeRange(toIndex + 1, intermediateCount)];
    for (GHSUIInternalView *viewToRemove in viewsToRemove) {
      [viewToRemove removeFromSuperview];
      [viewToRemove viewWillDisappear:YES];
      [viewToRemove viewDidDisappear:YES];
      viewToRemove.view.stack = nil;
      [_stack removeObject:viewToRemove];
    }
  }
}

- (void)popToView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  NSInteger toIndex = [self indexOfView:view];
  if (toIndex == NSNotFound) return;
  GHSUIInternalView *toInternalView = [_stack gh_objectAtIndex:toIndex];
  NSInteger fromIndex = [_stack count] - 1;
  GHSUIInternalView *fromInternalView = [_stack lastObject];
  [self _removeInBetweenIndex:fromIndex toIndex:toIndex];
  [self _removeInternalView:fromInternalView toInternalView:toInternalView duration:0 options:0 completion:NULL];
}

- (void)popView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  GHSUIInternalView *fromInternalView = [_stack lastObject];
  if (!fromInternalView || ![fromInternalView.view isEqual:view]) return;
  GHSUIInternalView *toInternalView = [_stack gh_objectAtIndex:[_stack count] - 2];
  [self _removeInternalView:fromInternalView toInternalView:toInternalView duration:duration options:options completion:NULL];
}

- (void)swapView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  GHSUIInternalView *fromInternalView = [_stack lastObject];
  
  GHSUIInternalView *toInternalView = [[GHSUIInternalView alloc] init];
  [toInternalView setView:view];
  toInternalView.view.stack = self;
  [_stack addObject:toInternalView];
  
  [self _removeInternalView:fromInternalView toInternalView:toInternalView duration:duration options:options completion:NULL];
}

- (void)setView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  if ([_stack count] == 0) {
    [self _addView:view fromInternalView:nil duration:duration options:options];
  } else {
    NSInteger toIndex = 0;
    GHSUIInternalView *toInternalView = [[GHSUIInternalView alloc] init];
    [toInternalView setView:view];
    toInternalView.view.stack = self;
    [_stack insertObject:toInternalView atIndex:0];
    
    NSInteger fromIndex = [_stack count] - 1;
    GHSUIInternalView *fromInternalView = [_stack lastObject];
    [self _removeInBetweenIndex:fromIndex toIndex:toIndex];
    [self _removeInternalView:fromInternalView toInternalView:toInternalView duration:duration options:options completion:NULL];
  }
}

- (void)_removeAnimationsFromInternalView:(GHSUIInternalView *)fromInternalView toInternalView:(GHSUIInternalView *)toInternalView duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options animations:(void (^)())animations completion:(void (^)(BOOL finished))completion {
  [fromInternalView viewWillDisappear:YES];
  [toInternalView viewWillAppear:YES];
  if (![toInternalView superview]) [_parentView addSubview:toInternalView];
  [UIView animateWithDuration:duration delay:0 options:[self _animationOptions:options motion:NO] animations:animations completion:^(BOOL finished) {
    [fromInternalView removeFromSuperview];
    [fromInternalView viewDidDisappear:YES];
    [toInternalView viewDidAppear:YES];
    fromInternalView.view.stack = nil;
    if (completion) completion(finished);
    if (fromInternalView) [_stack removeObject:fromInternalView];
  }];
}

- (void)_setupToShowInternalView:(GHSUIInternalView *)internalView {
  internalView.frame = CGRectMake(_parentView.frame.size.width, 0, _parentView.frame.size.width, _parentView.frame.size.height);
}

- (void)_showInternalView:(GHSUIInternalView *)internalView {
  internalView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
  internalView.frame = CGRectMake(0, 0, _parentView.frame.size.width, _parentView.frame.size.height);
}

- (void)_removeInternalView:(GHSUIInternalView *)fromInternalView toInternalView:(GHSUIInternalView *)toInternalView duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion {
  
  if (self.isAnimating) {
    options = 0;
    duration = 0;
  }
  
  if ((options & GHSUIViewAnimationOptionTransitionSlide) == GHSUIViewAnimationOptionTransitionSlide) {
    [self _removeAnimationsFromInternalView:fromInternalView toInternalView:toInternalView duration:duration options:options animations:^{
      fromInternalView.frame = CGRectMake(_parentView.frame.size.width, 0, _parentView.frame.size.width, _parentView.frame.size.height);
      [self _showInternalView:toInternalView];
    } completion:completion];
  } else if ((options & GHSUIViewAnimationOptionTransitionSlideOver) == GHSUIViewAnimationOptionTransitionSlideOver) {
    [self _removeAnimationsFromInternalView:fromInternalView toInternalView:toInternalView duration:duration options:options animations:^{
      fromInternalView.frame = CGRectMake(_parentView.frame.size.width, 0, _parentView.frame.size.width, _parentView.frame.size.height);
      [self _showInternalView:toInternalView];
    } completion:completion];
  } else if (fromInternalView && toInternalView) {
    [self _showInternalView:toInternalView];
    [toInternalView viewWillAppear:YES];
    [fromInternalView viewWillDisappear:YES];
    if (duration > 0) {
      __block GHUIViewStack *blockSelf = self;
      blockSelf.animating = YES;
      [UIView transitionFromView:fromInternalView toView:toInternalView duration:duration options:[self _animationOptions:options motion:YES] completion:^(BOOL finished) {
        blockSelf.animating = NO;
        [fromInternalView removeFromSuperview];
        [fromInternalView viewDidDisappear:YES];
        fromInternalView.view.stack = nil;
        [toInternalView viewDidAppear:YES];
        if (completion) completion(YES);
        [_stack removeObject:fromInternalView];
      }];
    } else {
      [_parentView addSubview:toInternalView];
      [fromInternalView removeFromSuperview];
      [fromInternalView viewDidDisappear:YES];
      fromInternalView.view.stack = nil;
      [toInternalView viewDidAppear:YES];
      if (completion) completion(YES);
      [_stack removeObject:fromInternalView];
    }
  } else if (fromInternalView) {
    [fromInternalView viewWillDisappear:YES];
    [fromInternalView removeFromSuperview];
    [fromInternalView viewDidDisappear:YES];
    fromInternalView.view.stack = nil;
    if (completion) completion(YES);
    [_stack removeObject:fromInternalView];
  }
}


- (void)_addAnimationsForView:(GHSUIView *)view fromInternalView:(GHSUIInternalView *)fromInternalView toInternalView:(GHSUIInternalView *)toInternalView duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options animations:(void (^)())animations {
  
  [self _setupToShowInternalView:toInternalView];
  [toInternalView viewWillAppear:YES];
  [_parentView addSubview:toInternalView];
  [fromInternalView viewWillDisappear:YES];
  [UIView animateWithDuration:duration delay:0 options:[self _animationOptions:options motion:NO] animations:animations completion:^(BOOL finished) {
    [fromInternalView viewDidDisappear:YES];
    [toInternalView viewDidAppear:YES];
  }];
}

- (void)_addView:(GHSUIView *)view fromInternalView:(GHSUIInternalView *)fromInternalView duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  GHSUIInternalView *toInternalView = [[GHSUIInternalView alloc] init];
  [toInternalView setView:view];
  toInternalView.view.stack = self;
  [_stack addObject:toInternalView];
  
  if (self.isAnimating) {
    options = 0;
    duration = 0;
  }
  
  if ((options & GHSUIViewAnimationOptionTransitionSlide) == GHSUIViewAnimationOptionTransitionSlide) {
    [self _setupToShowInternalView:toInternalView];
    __block GHUIViewStack *blockSelf = self;
    [self _addAnimationsForView:view fromInternalView:fromInternalView toInternalView:toInternalView duration:duration options:options animations:^{
      fromInternalView.frame = CGRectMake(-blockSelf.parentView.frame.size.width, 0, blockSelf.parentView.frame.size.width, blockSelf.parentView.frame.size.height);
      [blockSelf _showInternalView:toInternalView];
    }];
  } else if ((options & GHSUIViewAnimationOptionTransitionSlideOver) == GHSUIViewAnimationOptionTransitionSlideOver) {
    [self _setupToShowInternalView:toInternalView];
    __block GHUIViewStack *blockSelf = self;
    [self _addAnimationsForView:view fromInternalView:fromInternalView toInternalView:toInternalView duration:duration options:options animations:^{
      if (CATransform3DIsIdentity(fromInternalView.layer.transform)) {
        fromInternalView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
      }
      [blockSelf _showInternalView:toInternalView];
    }];
  } else {
    toInternalView.frame = CGRectMake(0, 0, _parentView.frame.size.width, _parentView.frame.size.height);
    [toInternalView viewWillAppear:YES];
    [fromInternalView viewWillDisappear:YES];
    __block GHUIViewStack *blockSelf = self;
    blockSelf.animating = YES;
    [UIView transitionWithView:_parentView duration:duration options:[self _animationOptions:options motion:YES] animations:^{
      blockSelf.animating = NO;
      [_parentView addSubview:toInternalView];
    } completion:^(BOOL finished) {
      [fromInternalView viewDidDisappear:YES];
      [toInternalView viewDidAppear:YES];
    }];
  }
}

- (NSInteger)indexOfView:(GHSUIView *)view {
  for (NSInteger i = 0, count = [_stack count]; i < count; i++) {
    GHSUIInternalView *internalView = [_stack objectAtIndex:i];
    if ([internalView.view isEqual:view]) return i;
  }
  return NSNotFound;
}

- (BOOL)isVisibleView:(GHSUIView *)view {
  return [view isEqual:[self visibleView]];
}

- (BOOL)isRootView:(GHSUIView *)view {
  return [view isEqual:[self rootView]];
}

- (GHSUIView *)visibleView {
  GHSUIInternalView *internalView = [_stack lastObject];
  return internalView.view;
}

- (GHSUIView *)rootView {
  GHSUIInternalView *internalView = [_stack gh_firstObject];
  return internalView.view;
}

#define ConvertAnimationOption(__OPTIONS__, __OPTION__, __ANIMATION_OPTIONS__, __ANIMATION_OPTION__) do {\
if ((__OPTIONS__ & __OPTION__) == __OPTION__) { \
__ANIMATION_OPTIONS__ |= __ANIMATION_OPTION__; \
} \
} while (0)

- (UIViewAnimationOptions)_animationOptions:(GHSUIViewAnimationOptions)options motion:(BOOL)motion {
  UIViewAnimationOptions animationOptions = 0;
  ConvertAnimationOption(options, GHSUIViewAnimationOptionCurveEaseInOut, animationOptions, UIViewAnimationOptionCurveEaseInOut);
  ConvertAnimationOption(options, GHSUIViewAnimationOptionCurveEaseIn, animationOptions, UIViewAnimationOptionCurveEaseIn);
  ConvertAnimationOption(options, GHSUIViewAnimationOptionCurveEaseOut, animationOptions, UIViewAnimationOptionCurveEaseOut);
  ConvertAnimationOption(options, GHSUIViewAnimationOptionCurveLinear, animationOptions, UIViewAnimationOptionCurveLinear);
  
  if (motion) {
    ConvertAnimationOption(options, GHSUIViewAnimationOptionTransitionFlipFromLeft, animationOptions, UIViewAnimationOptionTransitionFlipFromLeft);
    ConvertAnimationOption(options, GHSUIViewAnimationOptionTransitionFlipFromRight, animationOptions, UIViewAnimationOptionTransitionFlipFromRight);
    ConvertAnimationOption(options, GHSUIViewAnimationOptionTransitionCurlUp, animationOptions, UIViewAnimationOptionTransitionCurlUp);
    ConvertAnimationOption(options, GHSUIViewAnimationOptionTransitionCurlDown, animationOptions, UIViewAnimationOptionTransitionCurlDown);
    ConvertAnimationOption(options, GHSUIViewAnimationOptionTransitionCrossDissolve, animationOptions, UIViewAnimationOptionTransitionCrossDissolve);
    ConvertAnimationOption(options, GHSUIViewAnimationOptionTransitionFlipFromTop, animationOptions, UIViewAnimationOptionTransitionFlipFromTop);
    ConvertAnimationOption(options, GHSUIViewAnimationOptionTransitionFlipFromBottom, animationOptions, UIViewAnimationOptionTransitionFlipFromBottom);
  }
  return animationOptions;
}

@end
