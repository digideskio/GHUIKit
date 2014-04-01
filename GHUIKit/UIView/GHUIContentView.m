//
//  GHUIContentView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 4/1/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIContentView.h"

@interface GHUIContentView ()
@property BOOL resignedActive;
@end


@implementation GHUIContentView

- (id<UILayoutSupport>)topLayoutGuide {
  return self.navigationDelegate.viewController.topLayoutGuide;
}

- (void)setNeedsRefresh {
  self.needsRefresh = YES;
  if (_visible) {
    [self refreshIfNeeded];
  }
}

#pragma mark Title

- (void)setNavigationTitle:(NSString *)navigationTitle {
  _navigationTitle = navigationTitle;
  self.navigationDelegate.navigationItem.title = _navigationTitle;
}

- (void)setNavigationBackTitle:(NSString *)navigationBackTitle {
  _navigationBackTitle = navigationBackTitle;
  self.navigationDelegate.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_navigationBackTitle style:UIBarButtonItemStylePlain target:nil action:nil];
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
  
  if (_navigationTitle) [self setNavigationTitle:_navigationTitle];
  if (_navigationBackTitle) [self setNavigationBackTitle:_navigationBackTitle];
  
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

#pragma -

+ (GHUIContentView *)contentViewForView:(UIView *)view {
  return [[GHUICView alloc] initWithView:view];
}

@end


@implementation GHUICView

- (id)initWithView:(UIView *)view {
  if ((self = [super init])) {
    _view = view;    
    [self addSubview:_view];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end