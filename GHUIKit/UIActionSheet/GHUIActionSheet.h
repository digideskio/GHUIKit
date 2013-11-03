//
//  GHUIActionSheet.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/30/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

typedef void (^GHUIActionSheetTargetBlock)();

/*!
 Action sheet with target and actions associated with titles.
 Useful for conditional titles and not having to deal with a single delegate, and button index.
 
     GHUIActionSheet *actionSheet = [[GHUIActionSheet alloc] initWithTitle:nil cancelButtonTitle:NSLocalizedString(@"Cancel") cancelTarget:^(){} destructiveButtonTitle:nil destructiveTarget:^(){}];
     
     if (...) [actionSheet addButtonWithTitle:NSLocalizedString(@"Use My Facebook Photo") target:^() { }];
     if (...) [actionSheet addButtonWithTitle:YKLocalizedString(@"TakePhoto") target:^() { }];
     [actionSheet addButtonWithTitle:YKLocalizedString(@"ChooseExistingPhoto") target:^() { }];
     actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
     [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
 
 */
@interface GHUIActionSheet : NSObject <UIActionSheetDelegate> {
  UIActionSheet *_actionSheet;
  
  NSString *_title;
  
  NSMutableArray *_titles;
  NSMutableArray *_targets;
  
  NSString *_cancelButtonTitle;
  GHUIActionSheetTargetBlock _cancelTarget;
  NSString *_destructiveButtonTitle;
  GHUIActionSheetTargetBlock _destructiveTarget;
}

@property (assign, nonatomic) UIActionSheetStyle actionSheetStyle;

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle;

/*!
 Create action sheet.
 @param title
 @param target
 @param cancelButtonTitle
 @param cancelTarget
 @param destructiveButtonTitle
 @param destructiveTarget
 */
- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelTarget:(GHUIActionSheetTargetBlock)cancelTarget destructiveButtonTitle:(NSString *)destructiveButtonTitle destructiveTarget:(GHUIActionSheetTargetBlock)destructiveTarget;

/*!
 Add button to action sheet.
 @param title
 @param target
 */
- (void)addButtonWithTitle:(NSString *)title target:(GHUIActionSheetTargetBlock)target;

/*!
 Show action sheet from toolbar.
 @param view Source view
 */
- (void)showFromToolbar:(UIToolbar *)view;

/*!
 Show action sheet from tab bar.
 @param view Source view
 */
- (void)showFromTabBar:(UITabBar *)view;

/*!
 Show action sheet from view.
 @param view Source view
 */
- (void)showInView:(UIView *)view;

/*!
 Show action sheet from bar button item.
 @param item
 @param animated
 
 Available in iOS3.2 and later.
 */
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;

/*!
 Show action sheet in rect.
 @param rect
 @param view
 @param animated
 
 Available in iOS3.2 and later.
 */
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;

/*!
 Dismiss sheet as if the buttonIndex was pressed.
 @param buttonIndex
 @param animated
 */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

/*!
 Dismiss the sheet.
 */
- (void)cancel;

@end

