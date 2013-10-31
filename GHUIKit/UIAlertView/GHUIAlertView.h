//
//  GHUIAlertView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/31/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

typedef void (^GHUIAlertViewBlock)(NSInteger index);

/*!
 Utility methods for UIAlertView.
 */
@interface GHUIAlertView : NSObject <UIAlertViewDelegate> {
  GHUIAlertViewBlock _block;
}

/*!
 Show alert with block callback.
 @param block YKUIAlertViewBlock that is called when the user presses a button
 @param title
 @param message
 @param cancelButtonTitle
 @param otherButtonTitle
 */
+ (void)showAlertWithBlock:(GHUIAlertViewBlock)block title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showAlertWithBlock:(GHUIAlertViewBlock)block title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle args:(va_list)args;

/*!
 Show OK alert.
 @param message
 @param title
 @result Alert view
 */
+ (UIAlertView *)showOKAlertWithMessage:(NSString *)message title:(NSString *)title;

/*!
 Show (simple) alert.
 @param message
 @param title
 @param cancelButtonTitle
 @result Alert view
 */
+ (UIAlertView *)showAlertWithMessage:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle;

@end
