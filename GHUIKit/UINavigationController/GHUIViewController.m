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
@property GHUIView *contentView;
@property GHUIViewTransitioning *transitioning;
@end

// These need to match "protected" methods in GHUIView
@interface GHUIView (ViewCallbacks)
- (void)_viewWillAppear:(BOOL)animated;
- (void)_viewDidAppear:(BOOL)animated;
- (void)_viewWillDisappear:(BOOL)animated;
- (void)_viewDidDisappear:(BOOL)animated;
- (void)_viewDidLayoutSubviews;
- (void)_willBecomeActive;
- (void)_willResignActive;
@end

@implementation GHUIViewController

- (id)initWithView:(GHUIView *)view {
  return [self initWithView:view animation:nil];
}

- (id)initWithView:(GHUIView *)view animation:(GHUIViewControllerAnimation *)animation {
  if ((self = [super init])) {
    _contentView = view;
    _contentView.navigationDelegate = self;
    _animation = animation;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_willBecomeActive:) name:UIApplicationWillResignActiveNotification object:nil];
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

- (void)_willBecomeActive:(NSNotification *)notification {
  [_contentView _willBecomeActive];
}

- (void)_willResignActive:(NSNotification *)notification {
  [_contentView _willResignActive];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [_contentView _viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_contentView _viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_contentView _viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [_contentView _viewDidDisappear:animated];
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

- (void)pushView:(GHUIView *)view animated:(BOOL)animated {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithView:view];
  [self.navigationController pushViewController:viewController animated:animated];
}

- (void)pushView:(GHUIView *)view animation:(id<UIViewControllerAnimatedTransitioning>)animation {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithView:view animation:animation];
  self.navigationController.delegate = [GHUIViewTransitioning sharedTransitioning];
  [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentView:(GHUIView *)view animation:(id<UIViewControllerAnimatedTransitioning>)animation completion:(void (^)(void))completion {
  UIViewController *presentController;
//  if (navigation) {
//    GHUIViewController *viewController = [[GHUIViewController alloc] initWithView:view];
//    viewController.modalPresentationStyle = UIModalPresentationCustom;
//    presentController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    self.transitioning = [[GHUIViewTransitioning alloc] initWithAnimation:animation];
//    presentController.transitioningDelegate = self.transitioning;
//  } else {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithView:view animation:animation];
  viewController.transitioningDelegate = [GHUIViewTransitioning sharedTransitioning];
  viewController.modalPresentationStyle = UIModalPresentationCustom;
  presentController = viewController;
  
  [self presentViewController:presentController animated:(!!animation) completion:completion];
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

- (void)swapView:(GHUIView *)view animated:(BOOL)animated {
  NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
  [viewControllers removeLastObject];
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithView:view];
  [viewControllers addObject:viewController];
  [self.navigationController setViewControllers:viewControllers animated:animated];
}

- (void)setViews:(NSArray *)views animated:(BOOL)animated {
  NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
  for (GHUIView *view in views) {
    [viewControllers addObject:[[GHUIViewController alloc] initWithView:view]];
  }
  [self.navigationController setViewControllers:viewControllers animated:animated];
}

@end
