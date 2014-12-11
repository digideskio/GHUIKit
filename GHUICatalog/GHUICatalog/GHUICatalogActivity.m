//
//  GHUICatalogActivity.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 2/24/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogActivity.h"
#import "GHUICatalogItem.h"
#import "GHUIActivityView.h"
#import <GHUIKit/GHUIErrorView.h>
#import <GHUIKit/GHUIKeyboardHandler.h>

@interface GHUICatalogActivity ()
@property GHUIActivityView *activityView;
@property GHUIErrorView *errorView;
@property UITextField *textField;
@end

@implementation GHUICatalogActivity

- (void)sharedInit {
  [super sharedInit];
  self.navigationTitle = @"Activity";
  
  NSMutableArray *items = [NSMutableArray array];
  [items addObject:[GHUICatalogItem itemForTitle:@"Activity View" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Error View" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Error View (Long)" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Toggle Keyboard" detail:nil]];
  [self.dataSource addObjects:items];
  
  [GHUIKeyboardHandler keyboardHandler];
  
  _activityView = [[GHUIActivityView alloc] init];
  
  _errorView = [[GHUIErrorView alloc] init];
  
  _textField = [[UITextField alloc] init];
  [self addSubview:_textField];
}

- (void)_dismiss {
  [self.navigationDelegate dismissViewAnimated:YES completion:nil];
}

- (void)selectItem:(GHUICatalogItem *)item {
  if ([item.title isEqualToString:@"Activity View"]) {
    [_activityView presentInView:self.navigationDelegate.viewController.navigationController.view keyboardRect:[[GHUIKeyboardHandler keyboardHandler] keyboardRect] animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      [_activityView dismissView:YES];
    });
  } else if ([item.title isEqualToString:@"Error View"]) {
    [_errorView setText:@"Oops!" detailText:@"Mustache Bushwick vinyl magna PBR&B gluten-free Vice"];
    [_errorView presentInView:self.navigationDelegate.viewController.navigationController.view keyboardRect:[[GHUIKeyboardHandler keyboardHandler] keyboardRect] dismissAfter:2.0];
  } else if ([item.title isEqualToString:@"Error View (Long)"]) {
    [_errorView setText:@"Oops!" detailText:@"Mustache Bushwick vinyl magna PBR&B gluten-free Vice tofu, ethnic McSweeney's sustainable shabby chic. Eiusmod selfies proident nisi, letterpress nostrud commodo. Cornhole artisan four loko odio letterpress tousled, officia do banjo American Apparel delectus ennui umami."];
    [_errorView presentInView:self.navigationDelegate.viewController.navigationController.view keyboardRect:[[GHUIKeyboardHandler keyboardHandler] keyboardRect] dismissAfter:2.0];
  } else if ([item.title isEqualToString:@"Toggle Keyboard"]) {
    if (!_textField.isFirstResponder) {
      [_textField becomeFirstResponder];
    } else {
      [_textField resignFirstResponder];
    }
  }
}

@end
