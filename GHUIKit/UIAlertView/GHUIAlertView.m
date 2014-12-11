//
//  GHUIAlertView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/31/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIAlertView.h"

typedef void (^GHUIAlertViewTarget)(NSInteger index);

@interface GHUIAlertView ()
@property (copy) GHUIAlertViewTarget target;
@end

@implementation GHUIAlertView

+ (id)delegates {
  static NSMutableArray *gDelegates = NULL;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gDelegates = [[NSMutableArray alloc] init];
  });
  return gDelegates;
}

- (id)initWithTarget:(GHUIAlertViewTarget)target {
  if ((self = [super init])) {
    self.target = target;
  }
  return self;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles target:(void (^)(NSInteger index))target {
  
  GHUIAlertView *delegate = [[GHUIAlertView alloc] initWithTarget:target]; // Released in alertView:clickedButtonAtIndex: ([self autorelease])
  [[GHUIAlertView delegates] addObject:delegate];
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];

  for (NSString *otherButtonTitle in otherButtonTitles) {
    [alertView addButtonWithTitle:otherButtonTitle];
  }
  
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (self.target) {
    self.target(buttonIndex);
    self.target = NULL;
  }
  [[GHUIAlertView delegates] removeObject:self];
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
