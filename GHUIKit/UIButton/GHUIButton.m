//
//  GHUIButton.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIButton.h"
#import "GHUILabel.h"
#import <GHKit/GHUIColor+Utils.h>

@interface GHUIButton ()
@property GHUILabel *label;
@end

// We could use objective-c message forwarding for NSProxy for a GHUILabel which this wraps, but fuck it,
// lets just write the methods out and be non-magical.
@implementation GHUIButton

- (void)sharedInit {
  [super sharedInit];
  
  self.label = [[GHUILabel alloc] init];
  
  self.userInteractionEnabled = YES;
  self.backgroundColor = [UIColor whiteColor];
  self.opaque = YES;
  self.accessibilityTraits |= UIAccessibilityTraitButton;
  
  self.insets = UIEdgeInsetsMake(9, 10, 9, 10);
  self.borderWidth = 1.0;
  self.borderColor = [UIColor grayColor];
  self.textAlignment = NSTextAlignmentCenter;
  self.highlightedShadingType = GHUIShadingTypeUnknown;
  self.highlightedFillColor = GHUIColorFromRGB(0xFAFAFA);
  self.disabledShadingType = GHUIShadingTypeUnknown;
  self.disabledBorderColor = [UIColor lightGrayColor];
  self.textColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1.0f alpha:1.0f];
  self.font = [UIFont systemFontOfSize:20.0f];
  self.style.disabledAlpha = 0.5;
  self.style.disabledTextColor = [UIColor grayColor];
  self.style.selectedShadingType = GHUIShadingTypeUnknown;
  self.style.disabledAlpha = 1.0;
  
  [self addSubview:self.label];
}

- (id)initWithText:(NSString *)text targetBlock:(GHUIControlTargetBlock)targetBlock {
  if ((self = [self init])) {
    self.text = text;
    self.targetBlock = targetBlock;
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.label.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (CGSize)sizeThatFits:(CGSize)size {
  return [self.label sizeThatFits:size];
}

- (CGSize)sizeForVariableWidth:(CGSize)size {
  return [self.label sizeForVariableWidth:size];
}

- (void)setBorderStyle:(GHUIBorderStyle)borderStyle color:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius {
  [self.label setBorderStyle:borderStyle color:color width:width cornerRadius:cornerRadius];
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  [self.label setDisabled:!enabled];
  [self.label setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  [self.label setSelected:selected];
  [self.label setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  [self.label setHighlighted:highlighted];
  [self.label setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [super setBackgroundColor:backgroundColor];
  [self.label setBackgroundColor:backgroundColor];
}

- (NSString *)text {
  return self.label.text;
}

- (void)setText:(NSString *)text {
  self.label.text = text;
}

- (UIFont *)font {
  return self.label.font;
}

- (void)setFont:(UIFont *)font {
  self.label.font = font;
}

- (UIColor *)textColor {
  return self.label.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
  self.label.textColor = textColor;
}

- (NSString *)secondaryText {
  return self.label.secondaryText;
}

- (void)setSecondaryText:(NSString *)secondaryText {
  self.label.secondaryText = secondaryText;
}

- (UIFont *)secondaryFont {
  return self.label.secondaryFont;
}

- (void)setSecondaryFont:(UIFont *)secondaryFont {
  self.label.secondaryFont = secondaryFont;
}

- (UIColor *)secondaryTextColor {
  return self.label.secondaryTextColor;
}

- (void)setSecondaryTextColor:(UIColor *)secondaryTextColor {
  self.label.secondaryTextColor = secondaryTextColor;
}

- (NSString *)accessoryText {
  return self.label.accessoryText;
}

- (void)setAccessoryText:(NSString *)accessoryText {
  self.label.accessoryText = accessoryText;
}

- (UIFont *)accessoryTextFont {
  return self.label.accessoryTextFont;
}

- (void)setAccessoryTextFont:(UIFont *)accessoryTextFont {
  self.label.accessoryTextFont = accessoryTextFont;
}

- (UIColor *)accessoryTextColor {
  return self.label.accessoryTextColor;
}

- (void)setAccessoryTextColor:(UIColor *)accessoryTextColor {
  self.label.accessoryTextColor = accessoryTextColor;
}

- (NSTextAlignment)accessoryTextAlignment {
  return self.label.accessoryTextAlignment;
}

- (void)setAccessoryTextAlignment:(NSTextAlignment)accessoryTextAlignment {
  self.label.accessoryTextAlignment = accessoryTextAlignment;
}

- (UIImage *)accessoryImage {
  return self.label.accessoryImage;
}

- (void)setAccessoryImage:(UIImage *)accessoryImage {
  self.label.accessoryImage = accessoryImage;
}

- (UIColor *)fillColor {
  return self.label.fillColor;
}

- (void)setFillColor:(UIColor *)fillColor {
  self.label.fillColor = fillColor;
}

- (UIColor *)fillColor2 {
  return self.label.fillColor2;
}

- (void)setFillColor2:(UIColor *)fillColor2 {
  self.label.fillColor2 = fillColor2;
}

- (void)setBorderColor:(UIColor *)borderColor {
  self.label.borderColor = borderColor;
}

- (UIColor *)borderColor {
  return self.label.borderColor;
}

- (void)setDisabledBorderColor:(UIColor *)disabledBorderColor {
  self.label.disabledBorderColor = disabledBorderColor;
}

- (UIColor *)disabledBorderColor {
  return self.label.disabledBorderColor;
}

- (void)setDisabledTextColor:(UIColor *)disabledTextColor {
  self.label.disabledTextColor = disabledTextColor;
}

- (UIColor *)disabledTextColor {
  return self.label.disabledTextColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  self.label.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
  return self.label.borderWidth;
}

- (CGFloat)cornerRadiusRatio {
  return self.label.cornerRadiusRatio;
}

- (void)setCornerRadiusRatio:(CGFloat)cornerRadiusRatio {
  self.label.cornerRadiusRatio = cornerRadiusRatio;
}

- (CGFloat)cornerRadius {
  return self.label.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  self.label.cornerRadius = cornerRadius;
}

- (UIColor *)selectedFillColor {
  return self.label.selectedFillColor;
}

- (void)setSelectedFillColor:(UIColor *)selectedFillColor {
  self.label.selectedFillColor = selectedFillColor;
}

- (UIColor *)selectedTextColor {
  return self.label.selectedTextColor;
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
  self.label.selectedTextColor = selectedTextColor;
}

- (UIColor *)highlightedTextColor {
  return self.label.highlightedTextColor;
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
  self.label.highlightedTextColor = highlightedTextColor;
}

- (UIColor *)highlightedFillColor {
  return self.label.highlightedFillColor;
}

- (void)setHighlightedFillColor:(UIColor *)highlightedFillColor {
  self.label.highlightedFillColor = highlightedFillColor;
}

- (UIColor *)highlightedBorderColor {
  return self.label.highlightedBorderColor;
}

- (void)setHighlightedBorderColor:(UIColor *)highlightedBorderColor {
  self.label.highlightedBorderColor = highlightedBorderColor;
}

- (UIColor *)highlightedFillColor2 {
  return self.label.highlightedFillColor2;
}

- (void)setHighlightedFillColor2:(UIColor *)highlightedFillColor2 {
  self.label.highlightedFillColor2 = highlightedFillColor2;
}

- (UIColor *)disabledFillColor {
  return self.label.disabledFillColor;
}

- (void)setDisabledFillColor:(UIColor *)disabledFillColor {
  self.label.disabledFillColor = disabledFillColor;
}

- (UIColor *)disabledFillColor2 {
  return self.label.disabledFillColor2;
}

- (void)setDisabledFillColor2:(UIColor *)disabledFillColor2 {
  self.label.disabledFillColor2 = disabledFillColor2;
}

- (void)setImageSize:(CGSize)imageSize {
  self.label.imageSize = imageSize;
}

- (CGSize)imageSize {
  return self.label.imageSize;
}

- (UIImageView *)imageView {
  return self.label.imageView;
}

- (void)setBackgroundImageSize:(CGSize)backgroundImageSize {
  self.label.backgroundImageSize = backgroundImageSize;
}

- (CGSize)backgroundImageSize {
  return self.label.backgroundImageSize;
}

- (UIImageView *)backgroundImageView {
  return self.label.backgroundImageView;
}

- (UIEdgeInsets)textInsets {
  return self.label.textInsets;
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
  self.label.textInsets = textInsets;
}

- (NSTextAlignment)textAlignment {
  return self.label.textAlignment;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
  self.label.textAlignment = textAlignment;
}

- (NSTextAlignment)secondaryTextAlignment {
  return self.label.secondaryTextAlignment;
}

- (void)setSecondaryTextAlignment:(NSTextAlignment)secondaryTextAlignment {
  self.label.secondaryTextAlignment = secondaryTextAlignment;
}

- (void)setInsets:(UIEdgeInsets)insets {
  self.label.insets = insets;
}

- (UIEdgeInsets)insets {
  return self.label.insets;
}

- (void)setBorderStyle:(GHUIBorderStyle)borderStyle {
  self.label.borderStyle = borderStyle;
}

- (GHUIBorderStyle)borderStyle {
  return self.label.borderStyle;
}

- (void)setShadingType:(GHUIShadingType)shadingType {
  self.label.shadingType = shadingType;
}

- (GHUIShadingType)shadingType {
  return self.label.shadingType;
}

- (void)setDisabledShadingType:(GHUIShadingType)disabledShadingType {
  self.label.disabledShadingType = disabledShadingType;
}

- (GHUIShadingType)disabledShadingType {
  return self.label.disabledShadingType;
}

- (void)setHighlightedShadingType:(GHUIShadingType)highlightedShadingType {
  self.label.highlightedShadingType = highlightedShadingType;
}

- (GHUIShadingType)highlightedShadingType {
  return self.label.highlightedShadingType;
}

- (BOOL)textHidden {
  return self.label.textHidden;
}

- (void)setTextHidden:(BOOL)textHidden {
  self.label.textHidden = textHidden;
}

- (UIActivityIndicatorView *)activityIndicatorView {
  return self.label.activityIndicatorView;
}

- (void)setActivityIndicatorAnimating:(BOOL)animating {
  [self.label setActivityIndicatorAnimating:animating];
  [self setEnabled:!animating];
  self.userInteractionEnabled = !animating;
  [self setNeedsLayout];
}

- (GHUILabel *)style {
  return self.label;
}

@end


