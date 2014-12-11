//
//  GHUIViewController.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/11/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIViewController.h"
#import "GHUIControl.h"
#import "GHUIUtils.h"
#import <GHKit/GHKitDefines.h>
#import "GHUIViewTransitioning.h"

@interface GHUIViewController ()
@property GHUIContentView *contentView;
@property GHUIViewTransitioning *transitioning;
@end

// These need to match "protected" methods in GHUIContentView
@interface GHUIView (ViewCallbacks)
- (void)_viewDidLayoutSubviews;
- (void)_viewDidLoad;
- (void)_didBecomeActive;
- (void)_willResignActive;
@end

@implementation GHUIViewController

- (id)initWithContentView:(GHUIContentView *)contentView {
  return [self initWithContentView:contentView animation:nil];
}

+ (instancetype)contentView:(GHUIContentView *)contentView preload:(BOOL)preload {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithContentView:contentView];
  if (preload) {
    [viewController view];
    [[viewController view] layoutIfNeeded];
  }
  return viewController;
}

- (id)initWithContentView:(GHUIContentView *)contentView animation:(GHUIViewControllerAnimation *)animation {
  if ((self = [super init])) {
    contentView.navigationDelegate.viewController.view = nil;
    
    _contentView = contentView;
    _contentView.navigationDelegate = self;
    _animation = animation;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)loadView {
  [super loadView];
  self.view = _contentView;
}

- (void)viewDidLayoutSubviews {
  [_contentView _viewDidLayoutSubviews];
}

- (void)_didBecomeActive:(NSNotification *)notification {
  [_contentView _didBecomeActive];
}

- (void)_willResignActive:(NSNotification *)notification {
  [_contentView _willResignActive];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [_contentView viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_contentView viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_contentView viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [_contentView viewDidDisappear:animated];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSAssert([NSThread isMainThread], @"Not on main thread");
  [_contentView _viewDidLoad];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  [_contentView setNeedsLayout];
  
  UICollectionView *collectionView = (UICollectionView *)[GHUIUtils subview:_contentView forClass:[UICollectionView class]];
  // This doesn't seem to cause cells to refresh their width
  [collectionView reloadData];
  
  UITableView *tableView = (UITableView *)[GHUIUtils subview:_contentView forClass:[UITableView class]];
  [tableView reloadData];
}

- (UIViewController *)viewController {
  return self;
}

- (void)pushView:(GHUIContentView *)contentView animated:(BOOL)animated {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithContentView:contentView];
  [self.navigationController pushViewController:viewController animated:animated];
}

- (void)pushView:(GHUIContentView *)contentView animation:(id<UIViewControllerAnimatedTransitioning>)animation {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithContentView:contentView animation:animation];
  self.navigationController.delegate = [GHUIViewTransitioning sharedTransitioning];
  [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentView:(GHUIContentView *)contentView animation:(id<UIViewControllerAnimatedTransitioning>)animation completion:(void (^)(void))completion {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithContentView:contentView animation:animation];
  viewController.transitioningDelegate = [GHUIViewTransitioning sharedTransitioning];
  viewController.modalPresentationStyle = UIModalPresentationCustom;
  [self presentViewController:viewController animated:(!!animation) completion:completion];
}

- (id<GHUIViewNavigationDelegate>)presentNavigationView:(GHUIContentView *)contentView animated:(BOOL)animated completion:(void (^)(void))completion {
  if (contentView.presentationMode != GHUIContentViewPresentationModeModalSplash) {
    contentView.presentationMode = GHUIContentViewPresentationModeModal;
  }
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithContentView:contentView];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
  [self presentViewController:navigationController animated:animated completion:completion];
  return viewController;
}

- (void)presentView:(GHUIContentView *)contentView modalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle completion:(void (^)(void))completion {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithContentView:contentView];
  viewController.modalPresentationStyle = modalPresentationStyle;
  [self presentViewController:viewController animated:YES completion:completion];
}

- (void)dismissViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
  [self dismissViewControllerAnimated:animated completion:completion];
}

- (void)popViewAnimated:(BOOL)animated {
  [self.navigationController popViewControllerAnimated:animated];
}

- (void)popToRootViewAnimated:(BOOL)animated {
  [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)swapView:(GHUIContentView *)view animated:(BOOL)animated {
  NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
  [viewControllers removeLastObject];
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithContentView:view];
  [viewControllers addObject:viewController];
  [self.navigationController setViewControllers:viewControllers animated:animated];
}

- (void)setViews:(NSArray *)views animated:(BOOL)animated {
  NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
  for (GHUIContentView *view in views) {
    [viewControllers addObject:[[GHUIViewController alloc] initWithContentView:view]];
  }
  
  [self.navigationController setViewControllers:viewControllers animated:animated];
}

@end
