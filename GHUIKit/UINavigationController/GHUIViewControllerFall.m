//
//  GHUIViewControllerFall.m
//  GHUIKit
//
//  Created by Gabriel Handford on 2/12/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIViewControllerFall.h"

@implementation GHUIViewControllerFall

/*
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
 */
@end
