//
//  GHUIAlertView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/31/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIAlertView.h"

@implementation GHUIAlertView

- (id)initWithBlock:(GHUIAlertViewBlock)block {
  if ((self = [super init])) {
    _block = block;
  }
  return self;
}

+ (void)showAlertWithBlock:(GHUIAlertViewBlock)block title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ... {
  va_list args;
  va_start(args, otherButtonTitle);
  [self showAlertWithBlock:block title:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle args:args];
  va_end(args);
}

+ (void)showAlertWithBlock:(GHUIAlertViewBlock)block title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle args:(va_list)args {
  
  GHUIAlertView *delegate = [[GHUIAlertView alloc] initWithBlock:block]; // Released in alertView:clickedButtonAtIndex: ([self autorelease])
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
  
  while(otherButtonTitle) {
    [alertView addButtonWithTitle:otherButtonTitle];
    otherButtonTitle = va_arg(args, id);
  }
  
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (!_block) return;
  _block(buttonIndex);
  _block = NULL;
}

+ (UIAlertView *)showAlertWithMessage:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
  [alert show];
  return alert;
}

+ (UIAlertView *)showOKAlertWithMessage:(NSString *)message title:(NSString *)title {
  return [self showAlertWithMessage:message title:title cancelButtonTitle:@"OK"];
}

@end
