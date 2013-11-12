//
//  GHUILabel.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/8/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"
#import "GHCGUtils.h"

@interface GHUILabel : GHUIView {

  CGSize _sizeThatFitsText;
  CGSize _titleSize;

  UIImageView *_imageView;

  UIActivityIndicatorView *_activityIndicatorView;

}

@property (assign, nonatomic, getter=isSelected) BOOL selected;
@property (assign, nonatomic, getter=isDisabled) BOOL disabled;
@property (assign, nonatomic, getter=isHighlighted) BOOL highlighted;

/*!
 Text.
 */
@property (strong, nonatomic) NSString *title;

/*!
 Text font.
 */
@property (strong, nonatomic) UIFont *titleFont;

/*!
 Text alignment for title. Defaults to center.
 */
@property (assign, nonatomic) NSTextAlignment titleAlignment;

/*!
 Text color for title.
 */
@property (strong, nonatomic) UIColor *titleColor;

/*!
 Background color.
 */
@property (strong, nonatomic) UIColor *fillColor;

/*!
 Background (alternate) color.
 Not all shading types use color2.
 */
@property (strong, nonatomic) UIColor *fillColor2;

/*!
 Background (alternate) color.
 Not all shading types use color3.
 */
@property (strong, nonatomic) UIColor *fillColor3;

/*!
 Background (alternate) color.
 Not all shading types use color4.
 */
@property (strong, nonatomic) UIColor *fillColor4;

/*!
 Shading type for background.
 */
@property (assign, nonatomic) GHUIShadingType shadingType;

/*!
 Border style.
 Defaults to GHUIBorderStyleRounded.
 */
@property (assign, nonatomic) GHUIBorderStyle borderStyle;

/*!
 Border color.
 */
@property (strong, nonatomic) UIColor *borderColor;

/*!
 Border width (stroke).
 */
@property (assign, nonatomic) CGFloat borderWidth;

/*!
 Border corner radius.
 */
@property (assign, nonatomic) CGFloat cornerRadius;

/*!
 Border corner radius ratio. For example 1.0 will be the most corner radius (half the height).
 */
@property (assign, nonatomic) CGFloat cornerRadiusRatio;

/*!
 Background image.
 */
@property (strong, nonatomic) UIImage *backgroundImage;

/*!
 Margins for element.
 */
@property (assign, nonatomic) UIEdgeInsets margin;

/*!
 Background image (highlighted).
 */
@property (strong, nonatomic) UIImage *highlightedBackgroundImage;

/*@!
 Background image (disabled).
 */
@property (strong, nonatomic) UIImage *disabledBackgroundImage;

/*!
 Image to display on the right side of the button.
 */
@property (strong, nonatomic) UIImage *accessoryImage;

/*!
 Insets for title text.
 */
@property (assign, nonatomic) UIEdgeInsets titleInsets;

/*!
 Insets (padding).
 */
@property (assign, nonatomic) UIEdgeInsets insets;

/*!
 Image to display to the left of the text.
 Alternatively, you can set the imageView.
 */
@property (strong, nonatomic) UIImage *image;

/*!
 If set, will use this size instead of the image.size.
 Defaults to CGSizeZero (disabled).
 */
@property (assign, nonatomic) CGSize imageSize;

/*!
 Text color for title (highlighted).
 */
@property (strong, nonatomic) UIColor *highlightedTitleColor;

/*!
 Background color (highlighted).
 Can be used with shadingType, color2, color3, color4.
 */
@property (strong, nonatomic) UIColor *highlightedFillColor;

/*!
 Background (alternate) color (highlighted).
 Not all shading types use color2.
 */
@property (strong, nonatomic) UIColor *highlightedFillColor2;

/*!
 Shading type for background (highlighted).
 */
@property (assign, nonatomic) GHUIShadingType highlightedShadingType;

/*!
 Border color (highlighted).
 */
@property (strong, nonatomic) UIColor *highlightedBorderColor;

/*!
 Image to display on the right side of the button (highlighted).
 */
@property (strong, nonatomic) UIImage *highlightedAccessoryImage;

/*!
 Text color for title (selected).
 */
@property (strong, nonatomic) UIColor *selectedTitleColor;

/*!
 Background color (selected).
 Can be used with shadingType, color2, color3, color4.
 */
@property (strong, nonatomic) UIColor *selectedFillColor;

/*!
 Background (alternate) color (selected).
 Not all shading types use color2.
 */
@property (strong, nonatomic) UIColor *selectedFillColor2;

/*!
 Shading type for background (selected).
 */
@property (assign, nonatomic) GHUIShadingType selectedShadingType;

/*!
 Text color for title (selected).
 */
@property (strong, nonatomic) UIColor *disabledTitleColor;

/*!
 Background color (highlighted).
 Can be used with shadingType, color2, color3, color4.
 */
@property (strong, nonatomic) UIColor *disabledFillColor;

/*!
 Background (alternate) color (highlighted).
 Not all shading types use color2.
 */
@property (strong, nonatomic) UIColor *disabledFillColor2;

/*!
 Border color (disabled).
 */
@property (strong, nonatomic) UIColor *disabledBorderColor;

/*!
 Shading type for background (disabled).
 */
@property (assign, nonatomic) GHUIShadingType disabledShadingType;

/*!
 Alpha (disabled). Defaults to 50%.
 */
@property (assign, nonatomic) CGFloat disabledAlpha;

/*!
 Accessory title, that appears next to title.
 */
@property (strong, nonatomic) NSString *accessoryTitle;

/*!
 Accessory title color. Defaults to titleColor.
 */
@property (strong, nonatomic) UIColor *accessoryTitleColor;

/*!
 Accessory title font. Defaults to titleFont.
 */
@property (strong, nonatomic) UIFont *accessoryTitleFont;

/*!
 Accessory title alignment.
 */
@property (assign, nonatomic) NSTextAlignment accessoryTitleAlignment;

/*!
 Text (appears under title).
 */
@property (strong, nonatomic) NSString *text;

/*!
 Text (appears under title) color.  Defaults to titleColor.
 */
@property (strong, nonatomic) UIColor *textColor;

/*!
 Text (appears under title) font. Defaults to titleFont.
 */
@property (strong, nonatomic) UIFont *textFont;

/*!
 Text alignment.
 */
@property (assign, nonatomic) NSTextAlignment textAlignment;

/*!
 Color for left arrow (iOS7 back button)
 */
@property (strong, nonatomic) UIColor *leftArrowColor;

/*!
 Image view.
 */
- (UIImageView *)imageView;

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
