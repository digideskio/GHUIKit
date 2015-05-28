//
//  GHUILabel.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/8/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"
#import <GHKit/GHCGUtils.h>

@interface GHUILabel : GHUIView {

  CGSize _sizeThatFitsText;
  CGSize _textSize;
  CGSize _accessoryTextSize;
  CGSize _secondaryTextSize;

  UIImageView *_imageView;
  
  UIImageView *_backgroundImageView;

  UIActivityIndicatorView *_activityIndicatorView;

  NSArray *_observeAttributes;
}

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

/*!
 Text.
 */
@property (nonatomic) NSString *text;

/*!
 Text font.
 */
@property (nonatomic) UIFont *font;

/*!
 Text alignment.
 */
@property (nonatomic) NSTextAlignment textAlignment;

/*!
 Text color.
 */
@property (nonatomic) UIColor *textColor;

/*!
 Background color.
 */
@property (nonatomic) UIColor *fillColor;

/*!
 Background (alternate) color.
 Not all shading types use color2.
 */
@property (nonatomic) UIColor *fillColor2;

/*!
 Background (alternate) color.
 Not all shading types use color3.
 */
@property (nonatomic) UIColor *fillColor3;

/*!
 Background (alternate) color.
 Not all shading types use color4.
 */
@property (nonatomic) UIColor *fillColor4;

/*!
 Shading type for background.
 */
@property (nonatomic) GHUIShadingType shadingType;

/*!
 Border style.
 Defaults to GHUIBorderStyleRounded.
 */
@property (nonatomic) GHUIBorderStyle borderStyle;

/*!
 Border color.
 */
@property (nonatomic) UIColor *borderColor;

/*!
 Border width (stroke).
 */
@property (nonatomic) CGFloat borderWidth;

/*!
 Border corner radius.
 */
@property (nonatomic) CGFloat cornerRadius;

/*!
 Border corner radius ratio. For example 1.0 will be the most corner radius (half the height).
 */
@property (nonatomic) CGFloat cornerRadiusRatio;

/*!
 Image to display on the right side of the button.
 */
@property (nonatomic) UIImage *accessoryImage;

/*!
 Insets for text text.
 */
@property (nonatomic) UIEdgeInsets textInsets;

/*!
 Insets (padding).
 */
@property (nonatomic) UIEdgeInsets insets;

/*!
 If set, will use this size instead of the image.size.
 Defaults to CGSizeZero (disabled).
 */
@property (nonatomic) CGSize imageSize;

@property (nonatomic) CGSize backgroundImageSize;

/*!
 Text color for text (highlighted).
 */
@property (nonatomic) UIColor *highlightedTextColor;

/*!
 Background color (highlighted).
 Can be used with shadingType, color2, color3, color4.
 */
@property (nonatomic) UIColor *highlightedFillColor;

/*!
 Background (alternate) color (highlighted).
 Not all shading types use color2.
 */
@property (nonatomic) UIColor *highlightedFillColor2;

/*!
 Shading type for background (highlighted).
 */
@property (nonatomic) GHUIShadingType highlightedShadingType;

/*!
 Border color (highlighted).
 */
@property (nonatomic) UIColor *highlightedBorderColor;

/*!
 Image to display on the right side of the button (highlighted).
 */
@property (nonatomic) UIImage *highlightedAccessoryImage;

/*!
 Text color (selected).
 */
@property (nonatomic) UIColor *selectedTextColor;

/*!
 Background color (selected).
 Can be used with shadingType, color2, color3, color4.
 */
@property (nonatomic) UIColor *selectedFillColor;

/*!
 Background (alternate) color (selected).
 Not all shading types use color2.
 */
@property (nonatomic) UIColor *selectedFillColor2;

/*!
 Accessory text color (selected).
 */
@property (nonatomic) UIColor *selectedAccessoryTextColor;

/*!
 Shading type for background (selected).
 */
@property (nonatomic) GHUIShadingType selectedShadingType;

/*!
 Text color for text (selected).
 */
@property (nonatomic) UIColor *disabledTextColor;

/*!
 Background color (highlighted).
 Can be used with shadingType, color2, color3, color4.
 */
@property (nonatomic) UIColor *disabledFillColor;

/*!
 Background (alternate) color (highlighted).
 Not all shading types use color2.
 */
@property (nonatomic) UIColor *disabledFillColor2;

/*!
 Border color (disabled).
 */
@property (nonatomic) UIColor *disabledBorderColor;

/*!
 Shading type for background (disabled).
 */
@property (nonatomic) GHUIShadingType disabledShadingType;

/*!
 Alpha (disabled). Defaults to 50%.
 */
@property (nonatomic) CGFloat disabledAlpha;

/*!
 Accessory text, that appears next to text.
 */
@property (nonatomic) NSString *accessoryText;

/*!
 Accessory text color. Defaults to textColor.
 */
@property (nonatomic) UIColor *accessoryTextColor;

/*!
 Accessory text font. Defaults to textFont.
 */
@property (nonatomic) UIFont *accessoryTextFont;

/*!
 Accessory text alignment.
 */
@property (nonatomic) NSTextAlignment accessoryTextAlignment;

/*!
 Secondary text (appears under text).
 */
@property (nonatomic) NSString *secondaryText;

/*!
 Secondary text (appears under text) color.  Defaults to textColor.
 */
@property (nonatomic) UIColor *secondaryTextColor;

/*!
 Secondary text (appears under text) font. Defaults to textFont.
 */
@property (nonatomic) UIFont *secondaryFont;

/*!
 Secondary text (appears under text) alignment.
 */
@property (nonatomic) NSTextAlignment secondaryTextAlignment;

/*!
 Hide all text.
 */
@property BOOL textHidden;

/*!
 Color for left arrow (iOS7 back button)
 */
//@property (nonatomic) UIColor *leftArrowColor;

/*!
 Image view.
 */
- (UIImageView *)imageView;

- (UIImageView *)backgroundImageView;

/*!
 Set border.
 @param borderStyle Border style
 @param color Color
 @param width Width
 @param cornerRadius Corner radius
 */
- (void)setBorderStyle:(GHUIBorderStyle)borderStyle color:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius;

/*!
 Activity indicator view.
 */
- (UIActivityIndicatorView *)activityIndicatorView;

/*!
 Set activity indicator animating.
 @param animating
 */
- (void)setActivityIndicatorAnimating:(BOOL)animating;

/*!
 @result YES if activity indicator is animating
 */
- (BOOL)isAnimating;

/*!
 Size for a variable width.
 */
- (CGSize)sizeForVariableWidth:(CGSize)size;

/*!
 Draw the view in the given rect.
 @param rect Rect to draw in.
 */
- (void)drawInRect:(CGRect)rect;


@end
