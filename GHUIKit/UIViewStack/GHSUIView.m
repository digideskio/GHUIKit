//
//  GHSUIView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHSUIView.h"
#import "GHUIViewStack.h"
#import "GHCGUtils.h"

@implementation GHSUIView

@synthesize navigationBar=_navigationBar;

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  self.backgroundColor = [UIColor blackColor];
  self.opaque = YES;
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  _view.frame = CGRectMake(0, 0, size.width, size.height);
  return size;
}

+ (GHSUIView *)viewWithView:(UIView *)view {
  return [self viewWithView:view title:nil];
}

+ (GHSUIView *)viewWithView:(UIView *)view title:(NSString *)title {
  GHSUIView *viewForStack = [[GHSUIView alloc] init];
  viewForStack.view = view;
  [viewForStack.navigationBar setTitle:title animated:NO];
  return viewForStack;
}

- (void)setView:(UIView *)view {
  [_view removeFromSuperview];
  _view = view;
  if (_view) {
    [self addSubview:_view];
  }
}

- (GHUINavigationBar *)navigationBar {
  if (!_navigationBar) {
    _navigationBar = [[GHUINavigationBar alloc] init];
    [self applyStyleForNavigationBar:_navigationBar];
  }
  return _navigationBar;
}

- (void)pushView:(GHSUIView *)view animated:(BOOL)animated {
  [_stack pushView:view animated:animated];
}

- (void)popViewAnimated:(BOOL)animated {
  [_stack popView:self animated:animated];
}

- (void)pushView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  [_stack pushView:view duration:duration options:options];
}

- (void)popViewWithDuration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  [_stack popView:self duration:duration options:options];
}

- (void)setView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  [_stack setView:view duration:duration options:options];
}

- (void)swapView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  [_stack swapView:view duration:duration options:options];
}

- (void)popToView:(GHSUIView *)view duration:(NSTimeInterval)duration options:(GHSUIViewAnimationOptions)options {
  [_stack popToView:view duration:duration options:options];
}

- (BOOL)isRootView {
  return [_stack isRootView:self];
}

- (BOOL)isVisibleView {
  return [_stack isVisibleView:self];
}

- (void)setNavigationTitle:(NSString *)title animated:(BOOL)animated {
  [self.navigationBar setTitle:title animated:animated];
}

- (GHUIButton *)setNavigationButtonWithTitle:(NSString *)title iconImage:(UIImage *)iconImage position:(GHUINavigationPosition)position style:(GHUINavigationButtonStyle)style animated:(BOOL)animated targetBlock:(GHUIControlTargetBlock)targetBlock {
  GHUIButton *button = [[GHUIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
  button.title = title;
  button.iconImage = iconImage;
  button.targetBlock = targetBlock;
  [self applyStyleForNavigationButton:button style:style];
  switch (position) {
    case GHUINavigationPositionLeft:
      [self.navigationBar setLeftButton:button animated:animated];
      break;
    case GHUINavigationPositionRight:
      [self.navigationBar setRightButton:button animated:animated];
      break;
  }
  
  return button;
}

- (void)_updateBackButton {
  // Set back button on navigation bar if not left button
  if (_navigationBar && !_navigationBar.leftButton) {
    NSUInteger index = [_stack indexOfView:self];
    if (index > 0 && index != NSNotFound) {
      
      // TODO(gabe): Back title?
      NSString *backTitle = NSLocalizedString(@"Back", nil);
      if (!backTitle || [backTitle length] > 8) backTitle = NSLocalizedString(@"Back", nil);
      GHUIButton *backButton = [[GHUIButton alloc] init];
      backButton.title = backTitle;
      //backButton.borderStyle = GHUIBorderStyleRoundedBack;
      [self applyStyleForNavigationButton:backButton style:GHUINavigationButtonStyleBack];
      __block id blockSelf = self;
      backButton.targetBlock = ^() {
        [blockSelf _back];
      };
      _navigationBar.leftButton = backButton;
    }
  }
}

- (void)_back {
  [self popViewAnimated:YES];
}

- (void)_viewWillAppear:(BOOL)animated {
  _visible = YES;
  [self _updateBackButton];
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
  [self _viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated { }

- (void)viewDidAppear:(BOOL)animated { }

- (void)viewWillDisappear:(BOOL)animated { }

- (void)viewDidDisappear:(BOOL)animated { }

- (void)refresh { }

- (void)refreshIfNeeded {
  if (_needsRefresh) {
    _needsRefresh = NO;
    [self refresh];
  }
}

- (void)setNeedsRefresh {
  _needsRefresh = YES;
  if (_visible) {
    [self refreshIfNeeded];
  }
}

#pragma mark Style

- (void)applyStyleForNavigationButton:(GHUIButton *)button style:(GHUINavigationButtonStyle)style {
  button.titleFont = [UIFont boldSystemFontOfSize:12];
  button.insets = UIEdgeInsetsMake(0, 8, 0, 8);
  button.titleColor = [UIColor whiteColor];
  button.margin = UIEdgeInsetsMake(6, 0, 6, 0);
  button.cornerRadius = 4.0;
  button.borderWidth = 0.5;
  button.shadingType = GHUIShadingTypeLinear;
  button.color = [UIColor colorWithRed:98.0f/255.0f green:120.0f/255.0f blue:170.0f/255.0f alpha:1.0];
  button.color2 = [UIColor colorWithRed:64.0f/255.0f green:90.0f/255.0f blue:136.0f/255.0f alpha:1.0];
  button.highlightedShadingType = GHUIShadingTypeLinear;
  button.highlightedColor = [UIColor colorWithRed:70.0f/255.0f green:92.0f/255.0f blue:138.0f/255.0f alpha:1.0];
  button.highlightedColor2 = [UIColor colorWithRed:44.0f/255.0f green:70.0f/255.0f blue:126.0f/255.0f alpha:1.0];
  button.borderColor = [UIColor colorWithRed:87.0f/255.0f green:100.0f/255.0f blue:153.0f/255.0f alpha:1.0];
  
  CGSize size = [button sizeThatFitsInSize:CGSizeMake(120, 999)];
  if (size.width < 55) size.width = 55;
  button.frame = CGRectMake(0, 0, size.width, 30 + button.margin.top + button.margin.bottom);
}

- (void)applyStyleForNavigationBar:(GHUINavigationBar *)navigationBar {
  navigationBar.backgroundColor = [UIColor colorWithRed:98.0f/255.0f green:120.0f/255.0f blue:170.0f/255.0f alpha:1.0];
  navigationBar.topBorderColor = [UIColor colorWithRed:87.0f/255.0f green:100.0f/255.0f blue:153.0f/255.0f alpha:1.0];
  navigationBar.bottomBorderColor = [UIColor colorWithRed:87.0f/255.0f green:100.0f/255.0f blue:153.0f/255.0f alpha:1.0];
}

@end
