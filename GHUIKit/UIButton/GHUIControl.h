//
//  GHUIControl.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHLayout.h"

typedef void (^GHUIControlTargetBlock)();

/*!
 UIControl with some helpers.
 
 Also implements GHLayout.
 */
@interface GHUIControl : UIControl <GHLayoutView> {
  
  GHUIControlTargetBlock _targetBlock;
  BOOL _targetDisabled;
  
  id<GHLayout> _layout;
  
  NSString *_valueForCopy;
  UILongPressGestureRecognizer *_longPressGestureRecognizer;
}

@property (assign, nonatomic, getter=isSelectable) BOOL selectable; // If YES, will set selected state when touch (ended); Default is NO
@property (assign, nonatomic, getter=isDelayActionEnabled) BOOL delayActionEnabled; // If YES, the action on the control is delayed in order to display the highlighted state
@property (retain, nonatomic) id<GHLayout> layout;
@property (copy, nonatomic) GHUIControlTargetBlock targetBlock;
@property (retain, nonatomic) NSString *valueForCopy;

/*!
 If YES, then touching the button will not callTarget.
 */
@property (assign, nonatomic, getter=isTargetDisabled) BOOL targetDisabled;

/*!
 This method gets called by both initWithFrame and initWithCoder. Subclasses taking advantage of
 this method should make sure to call [super sharedInit] at the top of their implementation
 of sharedInit
 */
- (void)sharedInit;

/*!
 Removes all targets.
 Does NOT remove or clear the setTarget:action:.
 */
- (void)removeAllTargets;

/*!
 Removes all targets.
 Does NOT remove targets that the control has set for itself.
 */
+ (void)removeAllTargets:(UIControl *)control;

/*!
 Check if touches are all inside this view.
 @param touches
 @param event
 @result YES if all touches are inside control
 */
- (BOOL)touchesAllInView:(NSSet */*of UITouch*/)touches withEvent:(UIEvent *)event;

/*!
 Check if touches are all inside the view.
 @param view
 @param touches
 @param event
 @result YES if all touches are inside the view
 */
+ (BOOL)touchesAllInView:(UIView *)view touches:(NSSet */*of UITouch*/)touches withEvent:(UIEvent *)event;

/*!
 Add a target.
 @param target
 @param action
 */
- (void)addTarget:(id)target action:(SEL)action;

/*!
 Call the target and targetBlock. This is what is called automatically on the touch up inside event.
 */
- (void)callTarget;

/*!
 Force the layout, if using GHLayout.
 You can use this instead of setNeedsLayout + layoutIfNeeded.
 This is also useful when using animations and setNeedsLayout + layoutIfNeeded don't work as expected.
 */
- (void)layoutView;

@end

