//
//  GHUIViewTransitioning.h
//  GHUIKit
//
//  Created by Gabriel Handford on 2/10/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIViewControllerAnimation.h"

@interface GHUIViewTransitioning : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

+ (id)sharedTransitioning;

- (id)initWithAnimation:(GHUIViewControllerAnimation *)animation;

@property GHUIViewControllerAnimation *animation;

@end
