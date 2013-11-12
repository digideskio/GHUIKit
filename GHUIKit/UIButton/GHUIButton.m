//
//  GHUIButton.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIButton.h"
#import "GHUILabel.h"

@implementation GHUIButton

- (void)sharedInit {
  [super sharedInit];
  
  self.label = [[GHUILabel alloc] init];
  
  self.userInteractionEnabled = YES;
  self.backgroundColor = [UIColor clearColor];
  self.opaque = YES;
  self.accessibilityTraits |= UIAccessibilityTraitButton;
  
  self.label.insets = UIEdgeInsetsMake(20, 0, 20, 10);
  self.label.titleAlignment = NSTextAlignmentCenter;
  self.label.selectedShadingType = GHUIShadingTypeUnknown;
  self.label.highlightedShadingType = GHUIShadingTypeUnknown;
  self.label.highlightedFillColor = [UIColor colorWithWhite:(217.0f/255.0f) alpha:1.0f];
  self.label.disabledShadingType = GHUIShadingTypeUnknown;
  self.label.disabledAlpha = 1.0;
  self.label.titleColor = [UIColor colorWithRed:0 green:122.0f/255.0f blue:1.0f alpha:1.0f];
  self.label.titleFont = [UIFont systemFontOfSize:20.0f];
  
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

- (UIColor *)fillColor {
  return self.label.fillColor;
}

- (void)setFillColor:(UIColor *)fillColor {
  self.label.fillColor = fillColor;
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

@end


