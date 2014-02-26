//
//  GHUIActivityView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/30/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIActivityView.h"
#import <GHKit/GHCGUtils.h>

@interface GHUIActivityView ()
@property UIActivityIndicatorView *activityIndicator;
@property BOOL activityEnabled;
@end

@implementation GHUIActivityView

- (void)sharedInit {
  [super sharedInit];
  self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _activityIndicator.frame = GHCGRectCenterInSize(_activityIndicator.frame.size, self.frame.size);
}

- (void)_setActivityEnabled:(BOOL)activityEnabled {
  _activityEnabled = activityEnabled;
  if (!_activityEnabled) {
    [_activityIndicator stopAnimating];
  } else {
    if (!_activityIndicator) {
      _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_activityStyle];
      _activityIndicator.hidesWhenStopped = YES;
      [self addSubview:_activityIndicator];
    }
    [_activityIndicator startAnimating];
  }
  [self setNeedsLayout];
}

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle {
  _activityStyle = activityStyle;
  if (_activityIndicator) _activityIndicator.activityIndicatorViewStyle = activityStyle;
}

- (BOOL)isAnimating {
  return _activityIndicator.isAnimating;
}

- (void)setAnimating:(BOOL)animating {
  [self _setActivityEnabled:animating];
}

- (void)presentViewInViewController:(UIViewController *)viewController keyboardRect:(CGRect)keyboardRect animated:(BOOL)animated {
  UIView *view = viewController.view;
  self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - keyboardRect.size.height);
  [self setAnimating:YES];
  [view addSubview:self];
  [view bringSubviewToFront:self];
 
  if (animated) {
    self.alpha = 0.0;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
      self.alpha = 1.0;
    } completion:^(BOOL finished) {
      
    }];
  }
}

- (void)dismissView:(BOOL)animated {
  if (animated) {
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
      self.alpha = 0.0;
    } completion:^(BOOL finished) {
      [self removeFromSuperview];
    }];
  } else {
    [self removeFromSuperview];
  }
}

@end
