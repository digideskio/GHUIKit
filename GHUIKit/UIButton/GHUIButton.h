//
//  GHUIButton.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIControl.h"
#import "GHCGUtils.h"

typedef enum {
  GHUIButtonIconPositionLeft = 0, // Default
  GHUIButtonIconPositionCenter, // Centered
  GHUIButtonIconPositionTop, // Aligned with top of button
} GHUIButtonIconPosition;

/*!
 Button.
 */
@interface GHUIButton : GHUIControl {
  
  CGSize _sizeThatFitsText;
  CGSize _titleSize;
  
  UIActivityIndicatorView *_activityIndicatorView;
  
}

/*!
 Text for button.
 */
@property (strong, nonatomic) NSString *title;

/*!
 Text font for button.
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
 Background color for button.
 Can be used with shadingType, color2, color3, color4.
 */
@property (strong, nonatomic) UIColor *color;

/*!
 Background (alternate) color for button.
 Not all shading types use color2.
 */
@property (strong, nonatomic) UIColor *color2;

/*!
 Background (alternate) color for button.
 Not all shading types use color3.
 */
@property (strong, nonatomic) UIColor *color3;

/*!
 Background (alternate) color for button.
 Not all shading types use color4.
 */
@property (strong, nonatomic) UIColor *color4;

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
@property (strong, nonatomic) UIImage *image;

/*!
 Margins for element.
 */
@property (assign, nonatomic) UIEdgeInsets margin;

/*!
 Background image (highlighted).
 */
@property (strong, nonatomic) UIImage *highlightedImage;

/*@!
 Background image (disabled).
 */
@property (strong, nonatomic) UIImage *disabledImage;

/*!
 Image (view) to display to the left of the text.
 Alternatively, you can set the image.
 */
@property (strong, nonatomic) UIImageView *iconImageView;

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
@property (strong, nonatomic) UIImage *iconImage;

/*!
 If set, will use this size instead of the image.size.
 Defaults to CGSizeZero (disabled).
 */
@property (assign, nonatomic) CGSize iconImageSize;

/*!
 Override position for icon.
 Only supported for GHUIButtonIconPositionTop.
 Set a value of CGFLOAT_MAX to skip.
 */
@property (assign, nonatomic) CGPoint iconOrigin;

/*!
 Icon position.
 Defaults to GHUIButtonIconPositionLeft.
 */
@property (assign, nonatomic) GHUIButtonIconPosition iconPosition;

/*!
 Text color for title (highlighted).
 */
@property (strong, nonatomic) UIColor *highlightedTitleColor;

/*!
 Background color for button (highlighted).
 Can be used with shadingType, color2, color3, color4.
 */
@property (strong, nonatomic) UIColor *highlightedColor;

/*!
 Background (alternate) color for button (highlighted).
 Not all shading types use color2.
 */
@property (strong, nonatomic) UIColor *highlightedColor2;

/*!
 Shading type for background (highlighted).
 */
@property (assign, nonatomic) GHUIShadingType highlightedShadingType;

/*!
 Border color (highlighted).
 */
@property (strong, nonatomic) UIColor *highlightedBorderColor;

/*!
 Icon image (highlighted).
 */
@property (strong, nonatomic) UIImage *highlightedIconImage;

/*!
 Image to display on the right side of the button (highlighted).
 */
@property (strong, nonatomic) UIImage *highlightedAccessoryImage;

/*!
 Text color for title (selected).
 */
@property (strong, nonatomic) UIColor *selectedTitleColor;

/*!
 Background color for button (selected).
 Can be used with shadingType, color2, color3, color4.
 */
@property (strong, nonatomic) UIColor *selectedColor;

/*!
 Background (alternate) color for button (selected).
 Not all shading types use color2.
 */
@property (strong, nonatomic) UIColor *selectedColor2;

/*!
 Shading type for background (selected).
 */
@property (assign, nonatomic) GHUIShadingType selectedShadingType;

/*!
 Icon image (selected).
 */
@property (strong, nonatomic) UIImage *selectedIconImage;

/*!
 Text color for title (selected).
 */
@property (strong, nonatomic) UIColor *disabledTitleColor;

/*!
 Background color for button (highlighted).
 Can be used with shadingType, color2, color3, color4.
 */
@property (strong, nonatomic) UIColor *disabledColor;

/*!
 Background (alternate) color for button (highlighted).
 Not all shading types use color2.
 */
@property (strong, nonatomic) UIColor *disabledColor2;

/*!
 Border color (disabled).
 */
@property (strong, nonatomic) UIColor *disabledBorderColor;

/*!
 Shading type for background (disabled).
 */
@property (assign, nonatomic) GHUIShadingType disabledShadingType;

/*!
 Icon (disabled).
 */
@property (strong, nonatomic) UIImage *disabledIconImage;

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
 Button.
 @param frame Frame
 @param title Title
 */
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

/*!
 @result Button
 */
+ (GHUIButton *)button;

/*!
 Button.
 @param frame Frame
 @param title Title
 */
+ (GHUIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title;

/*!
 Button.
 @param title Title
 @param target Target
 @param action Action
 */
+ (GHUIButton *)buttonWithTitle:(NSString *)title;

/*!
 Set border.
 @param borderStyle Border style
 @param color Color
 @param width Width
 @param cornerRadius Corner radius
 */
- (void)setBorderStyle:(GHUIBorderStyle)borderStyle color:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius;

- (CGSize)sizeThatFitsInSize:(CGSize)size;

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
 Draw the view in the given rect.
 @param rect Rect to draw in.
 */
- (void)drawInRect:(CGRect)rect;

@end

