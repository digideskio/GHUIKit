//
//  GHUIViewControllerFade.m
//  GHUIKit
//
//  Created by Gabriel on 9/3/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIViewControllerFade.h"

@implementation GHUIViewControllerFade

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  
  UIView *toView = toVC.view;
  UIView *fromView = fromVC.view;
  
  [containerView addSubview:toView];
  [containerView sendSubviewToBack:toView];
  
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  [UIView animateWithDuration:duration animations:^{
    fromView.alpha = 0.0;
  } completion:^(BOOL finished) {
    if ([transitionContext transitionWasCancelled]) {
      fromView.alpha = 1.0;
    } else {
      [fromView removeFromSuperview];
      fromView.alpha = 1.0;
    }
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

//- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
//  return 0.5;
//}

@end
