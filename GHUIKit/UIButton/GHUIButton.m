//
//  GHUIButton.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIButton.h"
#import "GHUILabel.h"

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
  
  self.label.insets = UIEdgeInsetsMake(20, 10, 20, 10);
  self.label.titleAlignment = NSTextAlignmentCenter;
  self.label.selectedShadingType = GHUIShadingTypeUnknown;
  self.label.highlightedShadingType = GHUIShadingTypeUnknown;
  self.label.highlightedFillColor = [UIColor colorWithWhite:(217.0f/255.0f) alpha:1.0f];
  self.label.disabledShadingType = GHUIShadingTypeUnknown;
  self.label.disabledAlpha = 1.0;
  self.label.titleColor = [UIColor colorWithRed:0 green:122.0f/255.0f blue:1.0f alpha:1.0f];
  self.label.titleFont = [UIFont systemFontOfSize:20.0f];
  self.label.disabledAlpha = 0.5;
  self.label.disabledTitleColor = [UIColor grayColor];
  
  [self addSubview:self.label];
}

- (void)layoutSubviews {
  self.label.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (CGSize)sizeThatFits:(CGSize)size {
  return [self.label sizeThatFits:size];
}

- (CGSize)sizeForVariableWidth:(CGSize)size {
  return [self.label sizeForVariableWidth:size];
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

- (NSString *)title {
  return self.label.title;
}

- (void)setTitle:(NSString *)title {
  self.label.title = title;
}

- (UIFont *)titleFont {
  return self.label.titleFont;
}

- (void)setTitleFont:(UIFont *)titleFont {
  self.label.titleFont = titleFont;
}

- (UIColor *)titleColor {
  return self.label.titleColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
  self.label.titleColor = titleColor;
}

- (NSString *)text {
  return self.label.text;
}

- (void)setText:(NSString *)text {
  self.label.text = text;
}

- (UIFont *)textFont {
  return self.label.textFont;
}

- (void)setTextFont:(UIFont *)textFont {
  self.label.textFont = textFont;
}

- (UIColor *)textColor {
  return self.label.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
  self.label.textColor = textColor;
}

- (NSString *)accessoryTitle {
  return self.label.accessoryTitle;
}

- (void)setAccessoryTitle:(NSString *)accessoryTitle {
  self.label.accessoryTitle = accessoryTitle;
}

- (UIFont *)accessoryTitleFont {
  return self.label.accessoryTitleFont;
}

- (void)setAccessoryTitleFont:(UIFont *)accessoryTitleFont {
  self.label.accessoryTitleFont = accessoryTitleFont;
}

- (UIColor *)accessoryTitleColor {
  return self.label.accessoryTitleColor;
}

- (void)setAccessoryTitleColor:(UIColor *)accessoryTitleColor {
  self.label.accessoryTitleColor = accessoryTitleColor;
}

- (NSTextAlignment)accessoryTitleAlignment {
  return self.label.accessoryTitleAlignment;
}

- (void)setAccessoryTitleAlignment:(NSTextAlignment)accessoryTitleAlignment {
  self.label.accessoryTitleAlignment = accessoryTitleAlignment;
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

- (UIColor *)highlightedTitleColor {
  return self.label.highlightedTitleColor;
}

- (void)setHighlightedTitleColorFillColor:(UIColor *)highlightedTitleColor {
  self.label.highlightedTitleColor = highlightedTitleColor;
}

- (UIColor *)highlightedFillColor {
  return self.label.highlightedFillColor;
}

- (void)setHighlightedFillColorFillColor:(UIColor *)highlightedFillColor {
  self.label.highlightedFillColor = highlightedFillColor;
}

- (UIColor *)highlightedFillColor2 {
  return self.label.highlightedFillColor2;
}

- (void)setHighlightedFillColorFillColor2:(UIColor *)highlightedFillColor2 {
  self.label.highlightedFillColor2 = highlightedFillColor2;
}

- (UIColor *)disabledFillColor {
  return self.label.disabledFillColor;
}

- (void)setDisabledFillColorFillColor:(UIColor *)disabledFillColor {
  self.label.disabledFillColor = disabledFillColor;
}

- (UIColor *)disabledFillColor2 {
  return self.label.disabledFillColor2;
}

- (void)setDisabledFillColorFillColor2:(UIColor *)disabledFillColor2 {
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

- (void)setInsets:(UIEdgeInsets)insets {
  self.label.insets = insets;
}

- (UIEdgeInsets)titleInsets {
  return self.label.titleInsets;
}

- (void)setTitleInsets:(UIEdgeInsets)titleInsets {
  self.label.titleInsets = titleInsets;
}

- (NSTextAlignment)titleAlignment {
  return self.label.titleAlignment;
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
  self.label.titleAlignment = titleAlignment;
}

- (UIEdgeInsets)insets {
  return self.label.insets;
}

- (void)setMargin:(UIEdgeInsets)margin {
  self.label.margin = margin;
}

- (UIEdgeInsets)margin {
  return self.label.margin;
}

- (void)setBorderStyle:(GHUIBorderStyle)borderStyle {
  self.label.borderStyle = borderStyle;
}

- (GHUIBorderStyle)borderStyle {
  return self.label.borderStyle;
}

- (void)setActivityIndicatorAnimating:(BOOL)animating {
  [self.label setActivityIndicatorAnimating:animating];
  self.userInteractionEnabled = !animating;
  [self setNeedsLayout];
}

@end


