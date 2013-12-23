//
//  GHUIKeyboardHandler.h
//  GHUIKit
//
//  Created by Gabriel Handford on 12/23/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"
#import <GHKit/GHKitDefines.h>

@interface GHUIKeyboardHandler : NSObject

@property (assign, nonatomic, getter=isKeyboardVisible) BOOL keyboardVisible;
@property (copy) GHTargetBlock keyboardBlock;

@property (weak) GHUIView *view;

- (void)registerKeyboardNotificationsForView:(GHUIView *)view;

@end
