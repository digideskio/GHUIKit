//
//  GHUIViewControllerAnimation.m
//  GHUIKit
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIViewControllerAnimation.h"

@implementation GHUIViewControllerAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  NSAssert(NO, @"Abstract");
}

@end
