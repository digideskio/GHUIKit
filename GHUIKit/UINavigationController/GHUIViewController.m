//
//  GHUIViewController.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/11/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIViewController.h"
#import "GHUIControl.h"

@interface GHUIView (ViewCallbacks)
- (void)_viewWillAppear:(BOOL)animated;
- (void)_viewDidAppear:(BOOL)animated;
- (void)_viewWillDisappear:(BOOL)animated;
- (void)_viewDidDisappear:(BOOL)animated;
- (void)_viewDidLayoutSubviews;
@end

@implementation GHUIViewController

- (id)initWithView:(GHUIView *)view {
  if ((self = [super init])) {
    _contentView = view;
    _contentView.navigationDelegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.view = _contentView;
}

- (void)viewDidLayoutSubviews {
  [_contentView _viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [_contentView _viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [_contentView _viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [_contentView _viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [_contentView _viewDidDisappear:animated];
}

- (void)pushView:(GHUIView *)view animated:(BOOL)animated {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithView:view];
  [self.navigationController pushViewController:viewController animated:animated];
}

- (void)popViewAnimated:(BOOL)animated {
  [self.navigationController popViewControllerAnimated:animated];
}

- (void)swapView:(GHUIView *)view animated:(BOOL)animated {
  NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
  [viewControllers removeLastObject];
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithView:view];
  [viewControllers addObject:viewController];
  [self.navigationController setViewControllers:viewControllers animated:animated];
}

@end
