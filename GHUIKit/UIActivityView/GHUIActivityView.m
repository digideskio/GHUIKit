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
@property BOOL activityEnabled;
@end

@implementation GHUIActivityView

- (void)sharedInit {
  [super sharedInit];
  self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
  
  _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  _activityIndicator.hidesWhenStopped = YES;
  [self addSubview:_activityIndicator];
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
    [_activityIndicator startAnimating];
  }
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (BOOL)isAnimating {
  return _activityIndicator.isAnimating;
}

- (void)setAnimating:(BOOL)animating {
  [self _setActivityEnabled:animating];
}

- (void)presentInView:(UIView *)view keyboardRect:(CGRect)keyboardRect animated:(BOOL)animated {
  //NSAssert(view.frame.size.width > 0, @"Activity view has no width");
  
  self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - keyboardRect.size.height);
  [self setAnimating:YES];
  [view addSubview:self];
  [view bringSubviewToFront:self];
 
  if (animated) {
    self.alpha = 0.0;
    //delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
    [UIView animateWithDuration:0.25 animations:^{
      self.alpha = 1.0;
    } completion:^(BOOL finished) {
      
    }];
  }
}

- (void)dismissView:(BOOL)animated {
  if (animated) {
    //delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
    [UIView animateWithDuration:0.25 animations:^{
      self.alpha = 0.0;
    } completion:^(BOOL finished) {
      [self removeFromSuperview];
    }];
  } else {
    [self removeFromSuperview];
  }
}

@end
