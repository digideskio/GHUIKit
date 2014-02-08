//
//  GHUIViewControllerModalAnimation.m
//  GHUIKit
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

// From VCTransitions project

#import "GHUIViewControllerModalAnimation.h"

@interface GHUIViewControllerModalAnimation ()
@property UIView *coverView;
@property NSArray *constraints;
@end

@implementation GHUIViewControllerModalAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIView *containerView = [transitionContext containerView];
  
  if (self.animationType == GHUIViewControllerAnimationTypePresent) {
    UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    //View to darken the area behind the modal view
    if (!_coverView) {
      _coverView = [[UIView alloc] initWithFrame:containerView.frame];
      _coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
      _coverView.alpha = 0.0;
    } else _coverView.frame = containerView.frame;
    [containerView addSubview:_coverView];
    
    modalView.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:modalView];
    NSDictionary *views = NSDictionaryOfVariableBindings(containerView, modalView);
    _constraints = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[modalView]-30-|" options:0 metrics:nil views:views] arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[modalView]-30-|" options:0 metrics:nil views:views]];
    [containerView addConstraints:_constraints];
    
    //Move off of the screen so we can slide it up
    CGRect endFrame = modalView.frame;
    modalView.frame = CGRectMake(endFrame.origin.x, containerView.frame.size.height, endFrame.size.width, endFrame.size.height);
    [containerView bringSubviewToFront:modalView];
    
    //Animate using spring animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:0 animations:^{
      modalView.frame = endFrame;
      _coverView.alpha = 1.0;
    } completion:^(BOOL finished) {
      [transitionContext completeTransition:YES];
    }];
  } else if (self.animationType == GHUIViewControllerAnimationTypeDismiss) {
    UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
    UIView *snapshot = [modalView snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = modalView.frame;
    [containerView addSubview:snapshot];
    [containerView bringSubviewToFront:snapshot];
    [modalView removeFromSuperview];
    
    CGRect originalFrame = snapshot.frame;
    snapshot.layer.anchorPoint = CGPointMake(0.0, 1.0);
    snapshot.frame = originalFrame;
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:0 animations:^{
      [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.15 animations:^{
        // 90 degrees (clockwise)
        snapshot.transform = CGAffineTransformMakeRotation(M_PI * -1.5);
      }];
      [UIView addKeyframeWithRelativeStartTime:0.15 relativeDuration:0.10 animations:^{
        // 180 degrees
        snapshot.transform = CGAffineTransformMakeRotation(M_PI * 1.0);
      }];
      [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.20 animations:^{
        // Swing past, ~225 degrees
        snapshot.transform = CGAffineTransformMakeRotation(M_PI * 1.3);
      }];
      [UIView addKeyframeWithRelativeStartTime:0.45 relativeDuration:0.20 animations:^{
        // Swing back, ~140 degrees
        snapshot.transform = CGAffineTransformMakeRotation(M_PI * 0.8);
      }];
      [UIView addKeyframeWithRelativeStartTime:0.65 relativeDuration:0.35 animations:^{
        // Spin and fall off the corner
        // Fade out the cover view since it is the last step
        CGAffineTransform shift = CGAffineTransformMakeTranslation(180.0, 0.0);
        CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI * 0.3);
        snapshot.transform = CGAffineTransformConcat(shift, rotate);
        _coverView.alpha = 0.0;
      }];
    } completion:^(BOOL finished) {
      [_coverView removeFromSuperview];
      [containerView removeConstraints:_constraints];
      [transitionContext completeTransition:YES];
    }];
  }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  if (self.animationType == GHUIViewControllerAnimationTypePresent) return 1.0;
  else if (self.animationType == GHUIViewControllerAnimationTypeDismiss) return 1.75;
  else return [super transitionDuration:transitionContext];
}

@end
