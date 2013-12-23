//
//  GHUIButton.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIControl.h"
#import "GHUILabel.h"

/*!
 Button.
 */
@interface GHUIButton : GHUIControl

@property (strong, nonatomic) GHUILabel *label;

- (CGSize)sizeForVariableWidth:(CGSize)size;

// Forwarded properties
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *fillColor;
@property (assign, nonatomic) CGFloat cornerRadius;
@property CGFloat cornerRadiusRatio;
@property UIColor *borderColor;
@property (strong, nonatomic) UIColor *selectedFillColor;

- (void)setActivityIndicatorAnimating:(BOOL)animating;

@end

