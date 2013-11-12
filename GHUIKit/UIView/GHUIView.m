//
//  GHUIView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"
#import "GHCGUtils.h"

@implementation GHUIView

@synthesize layout=_layout, needsLayoutBlock=_needsLayoutBlock;

- (void)sharedInit { }

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self sharedInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self sharedInit];
  }
  return self;
}

- (void)setFrame:(CGRect)frame {
  if (_layout && !GHCGRectIsEqual(self.frame, frame)) [_layout setNeedsLayout];
  [super setFrame:frame];
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
  GHLayoutAssert(self, _layout);
  if (_layout) {
    [_layout layoutSubviews:self.frame.size];
  }
}

- (CGSize)sizeThatFits:(CGSize)size {
  GHLayoutAssert(self, _layout);
  if (_layout) {
    return [_layout sizeThatFits:size];
  }
  return [super sizeThatFits:size];
}

- (void)setNeedsLayout {
  [super setNeedsLayout];
  [self setNeedsDisplay];
  [_layout setNeedsLayout];
}

- (void)notifyNeedsLayout:(BOOL)animated {
  if (_needsLayoutBlock != NULL) _needsLayoutBlock(self, animated);
  else [self setNeedsLayout];
}

#pragma mark Navigation Callbacks

- (void)_viewWillAppear:(BOOL)animated {
  _visible = YES;
  [self refreshIfNeeded];
  [self viewWillAppear:animated];
}

- (void)_viewDidAppear:(BOOL)animated {
  [self viewDidAppear:animated];
}

- (void)_viewWillDisappear:(BOOL)animated {
  [self viewWillDisappear:animated];
  _visible = NO;
}

- (void)_viewDidDisappear:(BOOL)animated {
  [self viewDidDisappear:animated];
}

- (void)_viewDidLayoutSubviews {
  [self viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated { }

- (void)viewDidAppear:(BOOL)animated { }

- (void)viewWillDisappear:(BOOL)animated { }

- (void)viewDidDisappear:(BOOL)animated { }

- (void)viewDidLayoutSubviews { }

#pragma mark Refersh

- (void)refresh { }

- (void)refreshIfNeeded {
  if (self.needsRefresh) {
    self.needsRefresh = NO;
    [self refresh];
  }
}

- (void)setNeedsRefresh {
  self.needsRefresh = YES;
  if (_visible) {
    [self refreshIfNeeded];
  }
}

#pragma mark Drawing/Layout

- (void)layoutView {
  NSAssert(_layout, @"Missing layout instance");
  [_layout setNeedsLayout];
  [_layout layoutSubviews:self.frame.size];
}

- (void)drawInRect:(CGRect)rect {
  [_layout drawSubviewsInRect:rect];
}

@end
