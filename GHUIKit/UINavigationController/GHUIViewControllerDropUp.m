//
//  GHUIViewControllerDropUp.m
//  GHUIKit
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIViewControllerDropUp.h"

@implementation GHUIViewControllerDropUp

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  //[containerView setBackgroundColor:self.backgroundColor ? self.backgroundColor : [UIColor whiteColor]];
  if (self.animationType == GHUIViewControllerAnimationTypePresent) {
    
    [containerView addSubview:toVC.view];
    CGRect fromFrame = fromVC.view.frame;
    CGRect toFrame = toVC.view.frame;
    
    fromFrame.origin.y = -fromFrame.size.height/2;
    toFrame.origin.y = containerView.frame.size.height;
    [toVC.view setFrame:toFrame];
    toFrame.origin.y = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.92f
          initialSpringVelocity:17
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                       [fromVC.view setFrame:fromFrame];
                       [toVC.view setFrame:toFrame];
                     } completion:^(BOOL finished) {
                       [transitionContext completeTransition:YES];
                     }];
  } else if (self.animationType == GHUIViewControllerAnimationTypeDismiss) {
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    CGRect fromFrame = fromVC.view.frame;
    CGRect toFrame = toVC.view.frame;
    
    fromFrame.origin.y = containerView.frame.size.height;
    
    toFrame.origin.y = -containerView.frame.size.height;
    [toVC.view setFrame:toFrame];
    toFrame.origin.y = 0;
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.92f
          initialSpringVelocity:17
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                       [fromVC.view setFrame:fromFrame];
                       [toVC.view setFrame:toFrame];
                     } completion:^(BOOL finished) {
                       [transitionContext completeTransition:YES];
                     }];
    
  }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 1.0;
}

@end
