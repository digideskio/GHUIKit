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

@interface GHUIViewController ()
@property GHUIView *contentView;
@end

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
  [collectionView reloadData];
}

- (UIViewController *)viewController {
  return self;
}

- (void)pushView:(GHUIView *)view animated:(BOOL)animated {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithView:view];
  [self.navigationController pushViewController:viewController animated:animated];
}

- (void)pushView:(GHUIView *)view animation:(id<UIViewControllerAnimatedTransitioning>)animation {
  GHUIViewController *viewController = [[GHUIViewController alloc] initWithView:view];
  self.navigationController.delegate = viewController;
  
  viewController.animationController = animation;
  [self.navigationController pushViewController:viewController animated:YES];
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

#pragma mark UIViewControllerAnimatedTransitioning

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    
  GHUIViewControllerAnimation *animationController = self.animationController;
  if (!animationController) return nil;

  switch (operation) {
    case UINavigationControllerOperationPush:
      animationController.animationType = GHUIViewControllerAnimationTypePresent;
      return animationController;
    case UINavigationControllerOperationPop:
      animationController.animationType = GHUIViewControllerAnimationTypeDismiss;
      return animationController;
    default:
      return nil;
  }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
  return nil;
}


@end
