//
//  GHUIViewController.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/11/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIContentView.h"
#import "GHUIViewControllerAnimation.h"

@interface GHUIViewController : UIViewController <GHUIViewNavigationDelegate>

@property (readonly) GHUIViewControllerAnimation *animation;

- (id)initWithContentView:(GHUIContentView *)contentView;

- (id)initWithContentView:(GHUIContentView *)contentView animation:(GHUIViewControllerAnimation *)animation;

+ (instancetype)contentView:(GHUIContentView *)contentView preload:(BOOL)preload;

@end
