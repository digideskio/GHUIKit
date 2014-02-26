//
//  GHUIView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"
#import <GHKit/GHCGUtils.h>

@interface GHUIView ()
@property NSMutableArray *observeAttributes;
@property BOOL resignedActive;
@end

@implementation GHUIView

- (void)_sharedInit {
  self.autoresizesSubviews = NO;
  self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)sharedInit { }

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self _sharedInit];
    [self sharedInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self _sharedInit];
    [self sharedInit];
  }
  return self;
}

- (void)dealloc {
  for (NSString *attr in _observeAttributes) {
    [self removeObserver:self forKeyPath:attr context:@"attributesNeedUpdate"];
  }
}

- (void)setAttributesNeedUpdate:(NSArray *)attributes {
  if (!_observeAttributes) _observeAttributes = [NSMutableArray array];
  [_observeAttributes addObjectsFromArray:attributes];
  for (NSString *attr in attributes) {
    [self addObserver:self forKeyPath:attr options:NSKeyValueObservingOptionNew context:@"attributesNeedUpdate"];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([_observeAttributes containsObject:keyPath]) {
    [self setNeedsDisplay];
    [self setNeedsLayout];
  }
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

- (id<UILayoutSupport>)topLayoutGuide {
  return self.navigationDelegate.viewController.topLayoutGuide;
}

#pragma mark Title

- (void)setTitle:(NSString *)title {
  _title = title;
  self.navigationDelegate.navigationItem.title = _title;
}

#pragma mark Navigation Callbacks

- (void)_willBecomeActive {
  if (_resignedActive) {
    _resignedActive = NO;
    [self _viewWillAppear:NO];
    [self _viewDidAppear:NO];
  }
}

- (void)_willResignActive {
  if (_visible) {
    _resignedActive = YES;
    [self _viewWillDisappear:NO];
    [self _viewDidDisappear:NO];
  }
}

- (void)_viewWillAppear:(BOOL)animated {
  _visible = YES;
  
  if (self.title) {
    self.navigationDelegate.navigationItem.title = self.title;
  }
  
  [self viewWillAppear:animated];
}

- (void)_viewDidAppear:(BOOL)animated {
  [self refreshIfNeeded];
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
