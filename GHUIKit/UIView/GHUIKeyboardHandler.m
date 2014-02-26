//
//  GHUIKeyboardHandler.m
//  GHUIKit
//
//  Created by Gabriel Handford on 12/23/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIKeyboardHandler.h"

@implementation GHUIKeyboardHandler

+ (id)keyboardHandler {
  static GHUIKeyboardHandler *gKeyboardHandler = NULL;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gKeyboardHandler = [[GHUIKeyboardHandler alloc] init];
    [gKeyboardHandler registerNotifications];
  });
  return gKeyboardHandler;
}

- (void)dealloc {
  [self unregisterNotifications];
}

- (void)unregisterNotifications {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)registerNotifications {
  [self unregisterNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  [self keyboardWillToggle:notification];
}

- (void)keyboardDidHide:(NSNotification *)notification {
  _keyboardVisible = NO;
  _keyboardRect = CGRectZero;
}

- (void)keyboardWillShow:(NSNotification *)notification {
  [self keyboardWillToggle:notification];
}

- (void)keyboardDidShow:(NSNotification *)notification {
  _keyboardVisible = YES;
  _keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

static BOOL gIsAnimating = NO;

+ (BOOL)isAnimating {
  return gIsAnimating;
}

- (void)keyboardWillToggle:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  NSTimeInterval duration;
  UIViewAnimationCurve animationCurve;
  CGRect startFrame;
  CGRect endFrame;
  [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
  [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
  [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&startFrame];
  [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
  
  NSInteger signCorrection = 1;
  if (startFrame.origin.y < 0 || startFrame.origin.x < 0 || endFrame.origin.y < 0 || endFrame.origin.x < 0)
    signCorrection = -1;
  
  CGFloat widthChange = (endFrame.origin.x - startFrame.origin.x) * signCorrection;
  CGFloat heightChange = (endFrame.origin.y - startFrame.origin.y) * signCorrection;
  
  CGFloat sizeChange = UIInterfaceOrientationIsLandscape([self.view.navigationDelegate interfaceOrientation]) ? widthChange : heightChange;
  
  CGRect containerFrame = self.view.frame;
  containerFrame.size.height += sizeChange;
  
  GHWeakSelf blockSelf = self;
  [UIView animateWithDuration:duration delay:0 options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState animations:^{
    gIsAnimating = YES;
    blockSelf.view.frame = containerFrame;
    [blockSelf.view layoutView];
    if (blockSelf.keyboardBlock) blockSelf.keyboardBlock(blockSelf);
  } completion:^(BOOL finished) {
    gIsAnimating = NO;
  }];
}

@end
