//
//  GHUIViewControllerModal.h
//  GHUIKit
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIViewControllerAnimation.h"

typedef NS_ENUM (NSUInteger, GHUIViewControllerModalStartPosition) {
  GHUIViewControllerModalStartPositionTop,
  GHUIViewControllerModalStartPositionRight,
  GHUIViewControllerModalStartPositionBottom,
  GHUIViewControllerModalStartPositionLeft
};

@interface GHUIViewControllerModal : GHUIViewControllerAnimation

@property UIEdgeInsets insets;
@property GHUIViewControllerModalStartPosition startPosition;
@property CGFloat shadowAlpha;

@end
