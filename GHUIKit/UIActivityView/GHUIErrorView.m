//
//  GHUIErrorView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 2/24/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIErrorView.h"

#import "GHUILabel.h"

@interface GHUIErrorView ()
@property GHUILabel *errorLabel;
@end

@implementation GHUIErrorView

- (void)sharedInit {
  [super sharedInit];
  
  _errorLabel = [[GHUILabel alloc] init];
  _errorLabel.userInteractionEnabled = NO;
  _errorLabel.text = @"Oops!";
  _errorLabel.textAlignment = NSTextAlignmentCenter;
  _errorLabel.font = [UIFont systemFontOfSize:14.0f];
  _errorLabel.textAlignment = NSTextAlignmentCenter;
  _errorLabel.textColor = [UIColor whiteColor];
  _errorLabel.insets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
  _errorLabel.textInsets = UIEdgeInsetsMake(0, 0, 10.0f, 0);
  _errorLabel.font = [UIFont boldSystemFontOfSize:22.0f];
  _errorLabel.fillColor = [UIColor colorWithWhite:0.0f alpha:0.85f];
  _errorLabel.cornerRadius = 10.0f;
  _errorLabel.secondaryTextColor = [UIColor whiteColor];
  _errorLabel.secondaryTextFont = [UIFont systemFontOfSize:14.0f];
  _errorLabel.secondaryTextAlignment = NSTextAlignmentCenter;
  [self addSubview:_errorLabel];
}

- (void)setText:(NSString *)text detailText:(NSString *)detailText {
  _errorLabel.text = text;
  _errorLabel.secondaryText = detailText;
}

- (void)_updateLabelFrame {
  CGSize errorLabelSize = [_errorLabel sizeThatFits:CGSizeMake(200, self.frame.size.height)];
  _errorLabel.frame = GHCGRectCenterInSize(errorLabelSize, self.frame.size);
}

- (void)presentViewInViewController:(UIViewController *)viewController keyboardRect:(CGRect)keyboardRect dismissAfter:(NSTimeInterval)dismissAfter {
  UIView *view = viewController.view;
  self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - keyboardRect.size.height);
  [self _updateLabelFrame];
  [view addSubview:self];
  [view bringSubviewToFront:self];
  self.alpha = 0.0;
  [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    self.alpha = 1.0;
  } completion:^(BOOL finished) {
  }];
  
  if (dismissAfter > 0) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 + dismissAfter * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      [self dismissView];
    });
  }
}

- (void)dismissView {
  [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    self.alpha = 0.0;
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

@end
