//
//  GHUICellButtonView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICellButtonView.h"

@implementation GHUICellButtonView

- (void)layoutSubviews {
  [super layoutSubviews];
  CGFloat x = 0;
  for (UIView *buttonView in _buttonViews) {
    buttonView.frame = CGRectMake(x, 0, 90, self.frame.size.height);
    x += 90;
  }
}

- (CGSize)sizeThatFits:(CGSize)size {
  return CGSizeMake(90 * [_buttonViews count], size.height);
}

- (void)setButtonViews:(NSArray *)buttonViews {
  NSAssert(!_buttonViews, @"Only set once");
    
  _buttonViews = buttonViews;
  CGFloat x = 0;
  for (UIView *buttonView in _buttonViews) {
    x += 90;
    [self addSubview:buttonView];
  }
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

@end
