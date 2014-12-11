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
@property BOOL willAppear;
@property BOOL hasAppeared;
@property BOOL didLoadWithLayout;
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

#pragma mark Navigation Delegate

- (void)setNavigationTitle:(NSString *)navigationTitle {
  _navigationTitle = navigationTitle;
  self.navigationDelegate.navigationItem.title = _navigationTitle;
}

- (void)setNavigationBackTitle:(NSString *)navigationBackTitle {
  _navigationBackTitle = navigationBackTitle;
  self.navigationDelegate.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_navigationBackTitle style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)dismiss {
  [self.navigationDelegate dismissViewAnimated:YES completion:nil];
}

#pragma mark Navigation Callbacks

- (void)_didBecomeActive {
  if (_resignedActive) {
    _resignedActive = NO;
    [self _viewWillAppear:NO activating:YES];
    [self viewDidAppear:NO];
    [self viewDidBecomeActive];
  }
}

- (void)_willResignActive {
  if (_visible) {
    _resignedActive = YES;
    [self viewWillResign];
    [self _viewWillDisappear:NO resigning:YES];
    [self viewDidDisappear:NO];
  }
}

- (void)_viewWillAppear:(BOOL)animated activating:(BOOL)activating {
  _visible = YES;
  
  if (!activating) {
    if (_navigationTitle) [self setNavigationTitle:_navigationTitle];
    if (_navigationBackTitle) [self setNavigationBackTitle:_navigationBackTitle];
    
    switch (_presentationMode) {
      case GHUIContentViewPresentationModeModal: {
          UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
          self.navigationDelegate.navigationItem.leftBarButtonItem = closeItem;
        }
        break;
      case GHUIContentViewPresentationModeModalSplash:
        [self.navigationDelegate.viewController.navigationController setNavigationBarHidden:YES];
        break;
      case GHUIContentViewPresentationModeDefault: {
        UINavigationController *navigationController = self.navigationDelegate.viewController.navigationController;
        if (navigationController.navigationBarHidden) {
          [navigationController setNavigationBarHidden:NO];
        }
        break;
      }
    }
  }
}

- (void)_viewWillDisappear:(BOOL)animated resigning:(BOOL)resigning {
  if (!resigning) {
    switch (_presentationMode) {
      case GHUIContentViewPresentationModeModalSplash: {
          [self.navigationDelegate.viewController.navigationController setNavigationBarHidden:NO animated:NO]; // No animated for a good reason (can't remember it tho)
        }
        break;
      default: break;
    }
  }
  _visible = NO;
}

- (void)_viewDidDisappear:(BOOL)animated {
  [self viewDidDisappear:animated];
}

- (void)_viewDidLayoutSubviews {
  [self viewDidLayoutSubviews];
  if (!_didLoadWithLayout && (self.frame.size.width > 0 && self.frame.size.height > 0)) {
    _didLoadWithLayout = YES;
    [self viewDidLoadWithLayout];
  }
}

- (void)_viewDidLoad {
  [self viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  if (!_willAppear) {
    _willAppear = YES;
    [self viewWillAppearAfterLoad:animated];
  }
  [self _viewWillAppear:animated activating:NO];
}

- (void)viewDidAppear:(BOOL)animated {
  if (!_hasAppeared) {
    _hasAppeared = YES;
    [self viewDidAppearAfterLoad:animated];
  }
  [self refreshIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self _viewWillDisappear:animated resigning:NO];
}

- (void)viewDidDisappear:(BOOL)animated { }

- (void)viewDidLayoutSubviews { }
- (void)viewDidLoad { }
- (void)viewDidLoadWithLayout { }

- (void)viewDidBecomeActive { }
- (void)viewWillResign { }

- (void)viewWillAppearAfterLoad:(BOOL)animated { }
- (void)viewDidAppearAfterLoad:(BOOL)animated { }

+ (GHUIContentView *)contentViewForView:(UIView *)view {
  return [[GHUICView alloc] initWithView:view];
}

- (void)enableActivity { }
- (void)disableActivity { }
- (void)setError:(NSError *)error { }

@end


@implementation GHUICView

- (id)initWithView:(UIView *)view {
  if ((self = [super init])) {
    self.backgroundColor = [UIColor whiteColor];
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