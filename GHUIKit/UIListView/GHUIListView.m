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
  switch (self.viewType) {
    case GHUIListViewTypeVertical:
    case GHUIListViewTypeVerticalFill:
      return [self layoutVertical:layout size:size];

    case GHUIListViewTypeHorizontal:
      return [self layoutHorizontal:layout size:size];
  }
}

- (CGSize)layoutVertical:(id<GHLayout>)layout size:(CGSize)size {
  if ([_views count] == 0) return CGSizeMake(size.width, 0);
  
  CGFloat x = _insets.left;
  CGFloat y = _insets.top;
  for (UIView *view in _views) {
    CGRect viewRect = CGRectZero;
    if (self.viewType == GHUIListViewTypeVerticalFill) {
      viewRect = [layout setFrame:CGRectMake(x, y, size.width - x - _insets.right, view.frame.size.height) view:view sizeToFit:YES];
    } else {
      NSAssert(view.frame.size.width != 0, @"View width is 0, it won't be visible in a vertical (non-fill) layout");
      viewRect = [layout setFrame:CGRectMake(x, y, view.frame.size.width, view.frame.size.height) view:view];
    }
    y += viewRect.size.height + _insets.bottom;
  }
  return CGSizeMake(size.width, y);
}

- (CGSize)layoutHorizontal:(id<GHLayout>)layout size:(CGSize)size {
  if ([_views count] == 0) return CGSizeMake(size.width, 0);
  
  CGFloat x = 0;
  CGFloat y = _insets.top;
  CGFloat maxHeight = 0;
  CGFloat totalWidth = (size.width - ((_insets.left + _insets.right) * [_views count]));
  CGFloat width = floorf(totalWidth / [_views count]);
  //NSAssert(width != 0, @"View width is 0, it won't be visible in horizontal layout; maybe the list view width is 0");
  for (UIView *view in _views) {
    x += _insets.left;
    CGRect viewRect = [layout setFrame:CGRectMake(x, y, width, view.frame.size.height) view:view sizeToFit:YES];
    NSAssert(viewRect.size.height != 0, @"View height is 0, it won't be visible in a horizontal layout");
    x += width + _insets.right;
    if (maxHeight < viewRect.size.height) maxHeight = viewRect.size.height;
  }
  y += maxHeight + _insets.bottom;
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

