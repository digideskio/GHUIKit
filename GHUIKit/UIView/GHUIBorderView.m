//
//  GHUIBorderView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 5/23/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIBorderView.h"

@interface GHUIBorderView ()
@property UIView *contentView;
@end

@implementation GHUIBorderView

- (void)sharedInit {
  [super sharedInit];  
  self.borderWidth = 1.0;
  self.borderColor = [UIColor grayColor];
}

//- (void)addSubview:(UIView *)view {
//  NSAssert(!_contentView, @"GHUIBorderView can only have 1 subview");
//  _contentView = view;
//  [super addSubview:view];
//  [self setNeedsLayout];
//  [self setNeedsDisplay];
//}
//
//- (void)layoutSubviews {
//  [super layoutSubviews];
//  UIEdgeInsets insets = GHBorderInsets(self.borderStyle, 1.0);
//  _contentView.frame = UIEdgeInsetsInsetRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), insets);
//}
//
//- (CGSize)sizeThatFits:(CGSize)size {
//  if (_contentView) {
//    CGSize sizeThatFits = [_contentView sizeThatFits:size];
//    return CGSizeMake(size.width, sizeThatFits.height);
//  }
//  return [super sizeThatFits:size];
//}

- (void)drawRect:(CGRect)rect {
//  [super drawRect:rect];
  CGContextRef context = UIGraphicsGetCurrentContext();
  GHCGContextDrawBorder(context, UIEdgeInsetsInsetRect(self.bounds, self.insets), self.borderStyle, NULL, self.borderColor.CGColor, self.borderWidth, self.borderRadius);
}

@end
