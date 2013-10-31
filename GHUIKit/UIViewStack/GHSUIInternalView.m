//
//  GHSUIInternalView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHSUIInternalView.h"
#import "GHSUIView.h"
#import "GHUIViewStack.h"

@implementation GHSUIInternalView

@synthesize view=_view;

- (void)sharedInit {
  self.layout = [GHLayout layoutForView:self];
  self.backgroundColor = [UIColor blackColor];
  self.opaque = YES;
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  CGFloat y = 0;
  CGSize contentSize = size;
  
  UIView *navigationBar = _view.navigationBar;
  if (navigationBar && !navigationBar.hidden) {
    CGRect navigationBarFrame = [layout setFrame:CGRectMake(0, y, size.width, 0) view:navigationBar sizeToFit:YES];
    y += navigationBarFrame.size.height;
    contentSize.height -= navigationBarFrame.size.height;
  }
  
  CGRect contentFrame = CGRectMake(0, y, contentSize.width, contentSize.height);
  // This prevents UIScrollViews from causing a layoutSubviews call after setFrame.
  //if (!GHCGRectIsEqual(contentFrame, _contentView.frame)) {
  [layout setFrame:contentFrame view:_view];
  
  return size;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  // This causes the subview frame changes to occur when the internal frame changes
  // which is important for animatable properties
  if (self.layout) [self layoutView];
}

- (void)setView:(GHSUIView *)view {
  [_view removeFromSuperview];
  _view = view;
  [self addSubview:_view];
  
  if (_view.navigationBar) {
    [self addSubview:_view.navigationBar];
  }
  
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)animated {
  [_view _viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [_view viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [_view viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [_view viewDidDisappear:animated];
}

@end