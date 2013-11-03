//
//  GHUIActionSheet.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/30/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIActionSheet.h"
#import <GHKit/GHNSArray+Utils.h>

@implementation GHUIActionSheet

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle {
  return [self initWithTitle:title cancelButtonTitle:cancelButtonTitle];
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelTarget:(GHUIActionSheetTargetBlock)cancelTarget
destructiveButtonTitle:(NSString *)destructiveButtonTitle destructiveTarget:(GHUIActionSheetTargetBlock)destructiveTarget {
  
  if ((self = [self init])) {
    _title = title;
    _actionSheetStyle = UIActionSheetStyleDefault;
    
    _cancelButtonTitle = cancelButtonTitle;
    _cancelTarget = cancelTarget;
    
    _destructiveButtonTitle = destructiveButtonTitle;
    _destructiveTarget = destructiveTarget;
    
    _titles = [[NSMutableArray alloc] initWithCapacity:10];
    _targets = [[NSMutableArray alloc] initWithCapacity:10];
  }
  return self;
}

- (UIActionSheet *)actionSheet {
  if (!_actionSheet) {
    // Initialize the buttons from the array. This is a hack since there's no way to pass in an array to the nil-terminated list
    _actionSheet = [[UIActionSheet alloc] initWithTitle:_title delegate:self cancelButtonTitle:_cancelButtonTitle destructiveButtonTitle:_destructiveButtonTitle otherButtonTitles:[_titles gh_objectAtIndex:0], [_titles gh_objectAtIndex:1], [_titles gh_objectAtIndex:2], [_titles gh_objectAtIndex:3], [_titles gh_objectAtIndex:4], [_titles gh_objectAtIndex:5], [_titles gh_objectAtIndex:6], [_titles gh_objectAtIndex:7], [_titles gh_objectAtIndex:8], nil];
    _actionSheet.actionSheetStyle = _actionSheetStyle;
    // Add cancel and destructive buttons to actions at their correct indices
    if (_destructiveButtonTitle && _destructiveTarget) [_targets insertObject:_destructiveTarget atIndex:[_actionSheet destructiveButtonIndex]];
    if (_cancelButtonTitle && _cancelTarget) [_targets insertObject:_cancelTarget atIndex:[_actionSheet cancelButtonIndex]];
  }
  return _actionSheet;
}

- (void)addButtonWithTitle:(NSString *)title target:(GHUIActionSheetTargetBlock)target {
  [_titles addObject:title];
  [_targets addObject:target];
}

- (void)showFromToolbar:(UIToolbar *)view {
  [[self actionSheet] showFromToolbar:view];
}

- (void)showFromTabBar:(UITabBar *)view {
  [[self actionSheet] showFromTabBar:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated {
  [[self actionSheet] showFromBarButtonItem:item animated:animated];
}

- (void)showInView:(UIView *)view {
  if (!view) return;
  [[self actionSheet] showInView:view];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {
  [[self actionSheet] showFromRect:rect inView:view animated:animated];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
  [[self actionSheet] dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

- (void)cancel {
  [self dismissWithClickedButtonIndex:[_actionSheet cancelButtonIndex] animated:YES];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  GHUIActionSheetTargetBlock target = [_targets objectAtIndex:buttonIndex];
  if (target) {
    target();
  }
  _actionSheet.delegate = nil;
}


@end
