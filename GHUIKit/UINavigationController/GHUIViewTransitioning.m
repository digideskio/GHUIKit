//
//  GHUIViewTransitioning.m
//  GHUIKit
//
//  Created by Gabriel Handford on 2/10/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIViewTransitioning.h"
#import "GHUIViewControllerAnimation.h"
#import "GHUIViewController.h"

@implementation GHUIViewTransitioning

+ (id)sharedTransitioning {
  static GHUIViewTransitioning *gShared = NULL;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gShared = [[GHUIViewTransitioning alloc] init];
  });
  return gShared;
}

- (id)initWithAnimation:(GHUIViewControllerAnimation *)animation {
  if ((self = [super init])) {
    _animation = animation;
  }
  return self;
}

#pragma mark UIViewControllerAnimatedTransitioning

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {

  GHUIViewControllerAnimation *animation = nil;
  
  switch (operation) {
    case UINavigationControllerOperationPush:
      if ([toViewController respondsToSelector:@selector(animation)]) {
        animation = [toViewController performSelector:@selector(animation)];
      }
      animation.animationType = GHUIViewControllerAnimationTypePresent;
      return animation;
    case UINavigationControllerOperationPop:
      if ([fromViewController respondsToSelector:@selector(animation)]) {
        animation = [fromViewController performSelector:@selector(animation)];
      }
      animation.animationType = GHUIViewControllerAnimationTypeDismiss;
      return animation;
    default:
      return nil;
  }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
  return nil;
}

#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presentedController presentingController:(UIViewController *)presentingController sourceController:(UIViewController *)source {
  GHUIViewControllerAnimation *animation = self.animation;
  if ([presentedController respondsToSelector:@selector(animation)]) {
    animation = [presentedController performSelector:@selector(animation)];
  }
  animation.animationType = GHUIViewControllerAnimationTypePresent;
  return animation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissedController {
  GHUIViewControllerAnimation *animation = self.animation;
  if ([dismissedController respondsToSelector:@selector(animation)]) {
    animation = [dismissedController performSelector:@selector(animation)];
  }
  animation.animationType = GHUIViewControllerAnimationTypeDismiss;
  return animation;
}


@end
