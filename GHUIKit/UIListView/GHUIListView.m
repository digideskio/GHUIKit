//
//  GHUIListView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/5/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIListView.h"

@implementation GHUIListView

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  _views = [[NSMutableArray alloc] init];  
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  if ([_views count] == 0) return CGSizeMake(size.width, 0);
  
  CGFloat x = _insets.left;
  CGFloat y = _insets.top;
  for (UIView *view in _views) {
    CGRect viewRect = CGRectZero;
    if (view.autoresizesSubviews) {
      viewRect = [layout setFrame:CGRectMake(x, y, size.width - x - _insets.right, view.frame.size.height) view:view sizeToFit:YES];
    } else {
      viewRect = [layout setFrame:CGRectMake(x, y, view.frame.size.width, view.frame.size.height) view:view];
    }
    y += viewRect.size.height + _insets.bottom;
  }
  return CGSizeMake(size.width, y);
}

- (NSArray *)views {
  return _views;
}

- (void)addView:(UIView *)view {
  [_views addObject:view];
  [self addSubview:view];
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

//- (void)drawRect:(CGRect)rect {
//  [super drawRect:rect];
//  CGContextRef context = UIGraphicsGetCurrentContext();
//  
//  UIColor *borderColor = self.borderColor;
//  if (borderColor) {
//    GHCGContextDrawLine(context, 0, 0.5, self.bounds.size.width, 0.5, borderColor.CGColor, 1.0);
//
//    GHCGContextDrawLine(context, 0, self.bounds.size.height - 0.5, self.bounds.size.width, self.bounds.size.height - 0.5, borderColor.CGColor, 1.0);
//  }
//}

@end

