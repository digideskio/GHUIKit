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

- (CGSize)sizeForVariableWidth:(CGSize)size;

// Forwarded properties
@property (nonatomic) NSString *title;
@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic) NSTextAlignment titleAlignment;
@property (nonatomic) NSString *text;
@property (nonatomic) UIFont *textFont;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) NSString *accessoryTitle;
@property (nonatomic) UIFont *accessoryTitleFont;
@property (nonatomic) UIColor *accessoryTitleColor;
@property (nonatomic) NSTextAlignment accessoryTitleAlignment;
@property (nonatomic) UIImage *accessoryImage;
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) UIColor *fillColor2;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat cornerRadiusRatio;
@property (nonatomic) UIColor *borderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) UIColor *selectedFillColor;
@property (nonatomic) UIColor *highlightedFillColor;
@property (nonatomic) UIColor *highlightedFillColor2;
@property (nonatomic) UIColor *highlightedTitleColor;
@property (nonatomic) UIColor *disabledFillColor;
@property (nonatomic) UIColor *disabledFillColor2;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic) CGSize imageSize;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) UIEdgeInsets titleInsets;
@property (nonatomic) UIEdgeInsets margin;
@property (nonatomic) GHUIBorderStyle borderStyle;
@property (nonatomic) GHUIShadingType shadingType;
@property (nonatomic) GHUIShadingType highlightedShadingType;
@property (nonatomic) GHUIShadingType disabledShadingType;

- (void)setActivityIndicatorAnimating:(BOOL)animating;

@end

