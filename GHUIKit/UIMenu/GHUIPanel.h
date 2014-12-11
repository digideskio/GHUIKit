//
//  GHUIPanel.h
//  GHUIKit
//
//  Created by Gabriel Handford on 2/12/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

typedef NS_ENUM (NSUInteger, GHUIPanelTransition) {
  GHUIPanelTransitionTop,
  GHUIPanelTransitionLeft,
};

@interface GHUIPanel : GHUIView

@property (getter=isVisible) BOOL visible;
@property (nonatomic) GHUIPanelTransition transition;
@property (nonatomic) UIView *contentView;
@property (nonatomic) BOOL coverEnabled;

- (id)initWithContentView:(UIView *)contentView;

- (void)presentView;

- (void)dismissView;

- (void)dismissViewAfterDelay:(NSTimeInterval)delay;

- (void)toggleView;



@end
