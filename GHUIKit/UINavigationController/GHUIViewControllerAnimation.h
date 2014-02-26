//
//  GHUIViewControllerAnimation.h
//  GHUIKit
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

typedef NS_ENUM (NSUInteger, GHUIViewControllerAnimationType) {
  GHUIViewControllerAnimationTypePresent,
  GHUIViewControllerAnimationTypeDismiss
};

@interface GHUIViewControllerAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property GHUIViewControllerAnimationType animationType;

@end