//
//  GHUIPanel.m
//  GHUIKit
//
//  Created by Gabriel Handford on 2/12/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIPanel.h"

@interface GHUIPanel ()
@property UIView *coverView;
@property BOOL presenting;
@property BOOL dismissing;
@property BOOL contentVisible;
@end

@protocol GHUIPanelAppear
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
@end


@implementation GHUIPanel

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  self.backgroundColor = [UIColor clearColor];
  self.userInteractionEnabled = NO;
  
  _coverView = [[UIView alloc] init];
  _coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
  _coverView.alpha = 0.0;
  
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismiss)];
  tapRecognizer.cancelsTouchesInView = NO;
  [_coverView addGestureRecognizer:tapRecognizer];
  [self addSubview:_coverView];
}

- (id)initWithContentView:(UIView *)contentView {
  if ((self = [super init])) {
    // Default transition
    [self setTransition:GHUIPanelTransitionTop];
    
    [self setContentView:contentView];
  }
  return self;
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  if (!_coverView.hidden) {
    [layout setFrame:CGRectMake(0, 0, size.width, size.height) view:_coverView];
  }
  
  CGSize contentSize = [_contentView sizeThatFits:size];
  [layout setFrame:CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, contentSize.width, contentSize.height) view:_contentView];
  
  if (![layout isSizing]) {
    [self _updateTransition];
  }
  
  if (_coverView.hidden) {
    return CGSizeMake(size.width, contentSize.height);
  } else {
    return size;
  }
}

- (void)setCoverEnabled:(BOOL)coverEnabled {
  _coverEnabled = coverEnabled;
  _coverView.hidden = !_coverEnabled;
  [self setNeedsLayout];
}

- (void)_updateTransition {
  if (!_presenting && !_contentVisible) [self setTransition:self.transition];
}

- (void)setContentView:(UIView *)contentView {
  _contentView = contentView;
  [self addSubview:_contentView];
  [self bringSubviewToFront:_contentView];
  [self _updateTransition];
  [self setNeedsLayout];
}

- (void)_dismiss {
  [self dismissView];
}

- (CGRect)_startFrame {
  //NSAssert(_contentView.frame.size.width != 0, @"Content view width is 0, it won't be visible");
  //NSAssert(_contentView.frame.size.height != 0, @"Content view height is 0, it won't be visible");
  switch (self.transition) {
    case GHUIPanelTransitionTop:
      return CGRectMake(0, -_contentView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
    case GHUIPanelTransitionLeft:
      return CGRectMake(-_contentView.frame.size.width, 64, _contentView.frame.size.width, _contentView.frame.size.height);
  }
}

- (CGRect)_endFrame {
  switch (self.transition) {
    case GHUIPanelTransitionTop:
      return CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    case GHUIPanelTransitionLeft:
      return CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
  }
}

- (void)setTransition:(GHUIPanelTransition)transition {
  _transition = transition;
  _contentView.frame = [self _startFrame];
}

- (void)presentView {
  if (_presenting) return;
  _presenting = YES;
  
  CGRect endFrame = [self _endFrame];
  
  _contentVisible = YES;
  if (_coverEnabled) self.userInteractionEnabled = YES;
  if ([_contentView respondsToSelector:@selector(viewWillAppear:)]) {
    [(id<GHUIPanelAppear>)_contentView viewWillAppear:YES];
  }
  [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
    _contentView.frame = endFrame;
    _coverView.alpha = 1.0;
    if ([_contentView respondsToSelector:@selector(viewDidAppear:)]) {
      [(id<GHUIPanelAppear>)_contentView viewDidAppear:YES];
    }
  } completion:^(BOOL finished) {
    _presenting = NO;
  }];
}

- (void)dismissViewAfterDelay:(NSTimeInterval)delay {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self dismissView];
  });
}

- (void)dismissView {
  if (_dismissing) return;
  _dismissing = YES;
  _contentVisible = NO;
  self.userInteractionEnabled = NO;
  CGRect startFrame = [self _startFrame];
  if ([_contentView respondsToSelector:@selector(viewWillDisappear:)]) {
    [(id<GHUIPanelAppear>)_contentView viewWillDisappear:YES];
  }
  [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    _contentView.frame = startFrame;
    _coverView.alpha = 0.0;
    if ([_contentView respondsToSelector:@selector(viewDidDisappear:)]) {
      [(id<GHUIPanelAppear>)_contentView viewDidDisappear:YES];
    }
  } completion:^(BOOL finished) {
    _dismissing = NO;
  }];
}

- (void)toggleView {
  if (_contentVisible) [self dismissView];
  else [self presentView];
}

@end
