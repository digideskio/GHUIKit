//
//  GHUIActivityView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/30/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIActivityView.h"
#import "GHCGUtils.h"

@implementation GHUIActivityView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor blackColor];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _activityIndicator.frame = GHCGRectCenterInSize(_activityIndicator.frame.size, self.frame.size);
  _label.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height);
  [_label setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size {
  // TODO: Size based on activity style and label height
  return CGSizeMake(size.width, 60);
}

- (void)_setActivityEnabled:(BOOL)activityEnabled {
  _activityEnabled = activityEnabled;
  if (!_activityEnabled) {
    [_activityIndicator stopAnimating];
  } else {
    if (!_activityIndicator) {
      _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_activityStyle];
      _activityIndicator.frame = GHCGRectCenterInSize(_activityIndicator.frame.size, self.frame.size);
      _activityIndicator.hidesWhenStopped = YES;
      [self addSubview:_activityIndicator];
    }
    [_activityIndicator startAnimating];
  }
}

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle {
  _activityStyle = activityStyle;
  if (_activityIndicator) _activityIndicator.activityIndicatorViewStyle = activityStyle;
}

- (UILabel *)label {
  if (!_label) {
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = [UIColor clearColor];
    _label.contentMode = UIViewContentModeCenter;
    _label.numberOfLines = 0;
    _label.font = [UIFont boldSystemFontOfSize:16.0];
    _label.textColor = [UIColor whiteColor];
  }
  return _label;
}

- (void)setText:(NSString *)text {
  if (!text) {
    if (_label) {
      _label.hidden = YES;
    }
  } else {
    self.hidden = NO;
    UILabel *label = self.label;
    label.hidden = NO;
    if (![label superview]) {
      [self addSubview:label];
    }
    label.text = text;
  }
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (BOOL)isAnimating {
  return _activityIndicator.isAnimating;
}

- (void)setAnimating:(BOOL)animating {
  if (animating) [self start];
  else [self stop];
}

- (void)start {
  [self _setActivityEnabled:YES];
  [self setText:nil];
}

- (void)stop {
  [self _setActivityEnabled:NO];
  [self setText:nil];
}

- (void)setErrorWithDescription:(NSString *)description {
  [self _setActivityEnabled:NO];
  [self setText:description];
}

@end
