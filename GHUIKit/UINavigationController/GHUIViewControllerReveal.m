//
//  GHUIViewControllerReveal.m
//  GHUIKit
//
//  Created by Gabriel Handford on 2/10/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIViewControllerReveal.h"

@interface GHUIViewControllerReveal ()
@property UIView *coverView;
@end

@implementation GHUIViewControllerReveal

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  
  if (self.animationType == GHUIViewControllerAnimationTypePresent) {
    // Darken behind modal
    if (!_coverView) {
      _coverView = [[UIView alloc] initWithFrame:containerView.frame];
      _coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    } else {
      _coverView.frame = containerView.frame;
    }
    _coverView.alpha = 1.0;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:_coverView];
    [containerView addSubview:fromVC.view];
    
    CGRect fromFrame = fromVC.view.frame;
    CGRect toFrame = toVC.view.frame;
    
    fromFrame.origin.y = containerView.frame.size.height;
    
    toFrame.origin.y = -containerView.frame.size.height;
    [toVC.view setFrame:toFrame];
    toFrame.origin.y = 0;
    [toVC.view setFrame:toFrame];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
      [fromVC.view setFrame:fromFrame];
      _coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
      [_coverView removeFromSuperview];
      [transitionContext completeTransition:YES];
    }];
    
  } else if (self.animationType == GHUIViewControllerAnimationTypeDismiss) {
    
    [containerView addSubview:_coverView];
    [containerView addSubview:toVC.view];
    _coverView.alpha = 0.0;
    //CGRect fromFrame = fromVC.view.frame;
    CGRect toFrame = toVC.view.frame;
    
    //fromFrame.origin.y = -fromFrame.size.height/2;
    //[fromVC.view setFrame:fromFrame];
    
    toFrame.origin.y = containerView.frame.size.height;
    [toVC.view setFrame:toFrame];
    toFrame.origin.y = 0;
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1.0
          initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
      [toVC.view setFrame:toFrame];
      _coverView.alpha = 1.0;
    } completion:^(BOOL finished) {
      [_coverView removeFromSuperview];
      [transitionContext completeTransition:YES];
    }];
    
  }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 1.0;
}

@end
