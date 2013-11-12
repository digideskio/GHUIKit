//
//  GHUIControl.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIControl.h"

@implementation GHUIControl

+ (void)removeAllTargets:(UIControl *)control {
  for (id target in [control allTargets]) {
    for (NSString *actionString in [control actionsForTarget:target forControlEvent:[control allControlEvents]]) {
      if (target == control) continue; // Skip self target so target/action still works
      [control removeTarget:target action:NSSelectorFromString(actionString) forControlEvents:[control allControlEvents]];
    }
  }
}

- (void)_sharedInit {
  [self addTarget:self action:@selector(_didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sharedInit { }

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self _sharedInit];
    [self sharedInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self _sharedInit];
    [self sharedInit];
  }
  return self;
}

- (void)removeAllTargets {
  [GHUIControl removeAllTargets:self];
}

+ (BOOL)touchesAllInView:(UIView *)view touches:(NSSet */*of UITouch*/)touches withEvent:(UIEvent *)event {
  // If any touch not in button, ignore
  for(UITouch *touch in touches) {
    CGPoint point = [touch locationInView:view];
    if (![view pointInside:point withEvent:event]) return NO;
  }
  return YES;
}

- (BOOL)touchesAllInView:(NSSet */*of UITouch*/)touches withEvent:(UIEvent *)event {
  return [GHUIControl touchesAllInView:self touches:touches withEvent:event];
}

- (void)addTarget:(id)target action:(SEL)action {
  [self removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)callTarget {
  if (_targetBlock != NULL) _targetBlock(self);
}

- (void)_didTouchUpInside {
  if (!_targetDisabled) {
    [self callTarget];
  }
}

//
// Layout code duplicated in GHUILayoutView. If you add changes please apply them there as well.
//

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
  GHLayoutAssert(self, _layout);
  if (_layout) {
    [_layout layoutSubviews:self.frame.size];
  }
}

- (CGSize)sizeThatFits:(CGSize)size {
  GHLayoutAssert(self, _layout);
  
  if (_layout) {
    return [_layout sizeThatFits:size];
  }
  return [super sizeThatFits:size];
}

- (void)setNeedsLayout {
  [super setNeedsLayout];
  [_layout setNeedsLayout];
}

- (void)layoutView {
  NSAssert(_layout, @"Missing layout instance");
  [_layout setNeedsLayout];
  [_layout layoutSubviews:self.frame.size];
}

#pragma mark Touches

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
  BOOL continueTracking = ([self pointInside:[touch locationInView:self] withEvent:event]);
  if (!continueTracking) {
    [self touchesCancelled:[NSSet setWithObject:touch] withEvent:event];
  }
  return continueTracking;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if (self.userInteractionEnabled) {
    if (![self touchesAllInView:touches withEvent:event]) return;
    self.highlighted = YES;
    [self setNeedsDisplay];
  }
  [super touchesBegan:touches withEvent:event];
  
  if (_delayActionEnabled && self.userInteractionEnabled) {
    // Force runloop to redraw so highlighted control appears instantly; must come after call to super
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.05]];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (self.isSelectable && [self touchesAllInView:touches withEvent:event] && self.userInteractionEnabled) {
    self.selected = !self.isSelected;
  }
  
  [super touchesEnded:touches withEvent:event];
  
  if (self.userInteractionEnabled) {
    // Unhighlight the control in a short while to give it a chance to be drawn highlighted
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      [self setHighlighted:NO];
      [self setNeedsDisplay];
    });
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  if (self.userInteractionEnabled) {
    self.highlighted = NO;
    [self setNeedsDisplay];
  }
}

#pragma mark Editing Menu

- (void)setValueForCopy:(NSString *)valueForCopy {
  _valueForCopy = valueForCopy;
  if (valueForCopy) {
    if (!_longPressGestureRecognizer) {
      _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_showEditingMenu:)];
      [self addGestureRecognizer:_longPressGestureRecognizer];
    }
  } else {
    if (_longPressGestureRecognizer) {
      [self removeGestureRecognizer:_longPressGestureRecognizer];
    }
  }
}

- (void)_showEditingMenu:(UILongPressGestureRecognizer *)gestureRecognizer {
  if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
    CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [self becomeFirstResponder];
    [menuController setTargetRect:CGRectMake(location.x, location.y, 0.0f, 0.0f) inView:[gestureRecognizer view]];
    [menuController setMenuVisible:YES animated:YES];
  }
}

- (void)copy:(id)sender {
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  pasteboard.string = _valueForCopy;
}

- (BOOL)canPerformAction:(SEL)selector withSender:(id) sender {
  if (selector == @selector(copy:) && _valueForCopy) {
    return YES;
  }
  return NO;
}

- (BOOL)canBecomeFirstResponder {
  return (!!_valueForCopy);
}

@end
