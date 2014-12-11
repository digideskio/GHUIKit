//
//  GHUIAlertView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/31/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

/*!
 Utility methods for UIAlertView.
 */
@interface GHUIAlertView : NSObject <UIAlertViewDelegate>

/*!
 Show alert with block callback.
 @param title
 @param message
 @param cancelButtonTitle
 @param otherButtonTitles
 @param target
 */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles target:(void (^)(NSInteger index))target;

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
