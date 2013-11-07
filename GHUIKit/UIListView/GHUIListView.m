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
    CGRect viewRect = [layout setFrame:CGRectMake(x, y, size.width - x - _insets.right, 0) view:view sizeToFit:YES];
    y += viewRect.size.height + _insets.bottom;
  }
  y += _insets.bottom;
  return CGSizeMake(size.width, y);
}

- (void)addView:(UIView *)view {
  [_views addObject:view];
  [self addSubview:view];
  [self setNeedsLayout];
}

@end
