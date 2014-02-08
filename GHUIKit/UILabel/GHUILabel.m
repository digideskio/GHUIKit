//
//  GHUILabel.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/8/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUILabel.h"
#import "GHUIUtils.h"

@implementation GHUILabel

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  self.backgroundColor = [UIColor clearColor];
  self.userInteractionEnabled = NO;
  self.contentMode = UIViewContentModeRedraw;
  self.selectedShadingType = GHUIShadingTypeUnknown;
  self.highlightedShadingType = GHUIShadingTypeUnknown;
  self.disabledShadingType = GHUIShadingTypeUnknown;
  self.disabledAlpha = 1.0;
  self.textColor = [UIColor blackColor];
  self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  self.secondaryTextColor = [UIColor blackColor];
  self.secondaryTextFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

  [self setAttributesNeedUpdate:@[@"text", @"textInsets", @"textFont", @"textAlignment", @"text", @"textFont", @"textAlignment", @"cornerRadius", @"cornerRadiusRatio", @"accessoryText", @"borderStyle"]];
}

- (void)dealloc {
  [_imageView removeObserver:self forKeyPath:@"image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (BOOL)shouldDrawText {
  return ![self isAnimating] && !self.textHidden;
}

- (void)_sizeText:(CGSize)constrainedToSize size:(CGSize *)size textSize:(CGSize *)textSize {
  *size = CGSizeZero;
  *textSize = CGSizeZero;
  if (![self shouldDrawText]) return;
  CGSize sizeText = CGSizeZero;
  
  if (_text) {
    sizeText = [GHUIUtils sizeWithText:_text font:_font size:constrainedToSize multiline:YES truncate:YES];
    *textSize = sizeText;
  }
  
  if (_accessoryText) {
    constrainedToSize.width -= roundf(sizeText.width);
    UIFont *font = (_accessoryTextFont ? _accessoryTextFont : _font);
    CGSize accessoryTextSize = [GHUIUtils sizeWithText:_accessoryText font:font size:constrainedToSize multiline:NO truncate:YES];
    sizeText.width += roundf(accessoryTextSize.width);
  }
  
  if (_secondaryText) {
    UIFont *font = (_secondaryTextFont ? _secondaryTextFont : _font);
    CGSize textSize = [GHUIUtils sizeWithText:_secondaryText font:font size:constrainedToSize multiline:YES truncate:YES];
    sizeText.height += roundf(textSize.height);
  }
  
  *size = sizeText;
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  CGFloat y = 0;
  
  y += _insets.top;
  UIEdgeInsets textInsets = ([self shouldDrawText] ? UIEdgeInsetsZero : _textInsets);
  y += textInsets.top;
  
  CGSize imageSize = [self _imageSize];
  
  _sizeThatFitsText = CGSizeZero;
  _textSize = CGSizeZero;
  
  CGSize constrainedToSize = size;
  // Subtract insets
  constrainedToSize.width -= (textInsets.left + textInsets.right);
  constrainedToSize.width -= (_insets.left + _insets.right);
  
  // Subtract activity indicator view
  if (_activityIndicatorView && _activityIndicatorView.isAnimating) {
    constrainedToSize.width -= _activityIndicatorView.frame.size.width;
  }
  
  if (constrainedToSize.height == 0) {
    constrainedToSize.height = CGFLOAT_MAX;
  }
  
  [self _sizeText:constrainedToSize size:&_sizeThatFitsText textSize:&_textSize];
  
  if (imageSize.height > _sizeThatFitsText.height) {
    y += imageSize.height;
  } else {
    y += _sizeThatFitsText.height;
  }
  
  y += textInsets.bottom;
  y += _insets.bottom;
  
  if (_activityIndicatorView) {
    [layout setOrigin:GHCGPointToCenter(_activityIndicatorView.frame.size, CGSizeMake(size.width, y - _insets.top - _insets.bottom))
                 view:_activityIndicatorView];
  }
  
  return CGSizeMake(size.width, y);
}

- (CGSize)_imageSize {
  CGSize imageSize = _imageSize;
  if (GHCGSizeIsZero(imageSize)) {
    if (self.imageView.image) imageSize = self.imageView.image.size;
  }
  return imageSize;
}

- (CGSize)sizeForVariableWidth:(CGSize)size {
  CGSize sizeForHeight = [GHUIUtils sizeWithText:_text font:_font size:size multiline:NO truncate:NO];
  sizeForHeight.width += self.insets.left + self.insets.right;
  sizeForHeight.height += self.insets.top + self.insets.bottom;
  sizeForHeight.width += _textInsets.left + _textInsets.right;
  sizeForHeight.height += _textInsets.top + _textInsets.bottom;
  if (self.accessoryImage) sizeForHeight.width += self.accessoryImage.size.width;
  
  CGSize imageSize = [self _imageSize];
  if (sizeForHeight.width < imageSize.width) sizeForHeight.width = imageSize.width;
  if (sizeForHeight.height < imageSize.height) sizeForHeight.height = imageSize.height;
  
  return sizeForHeight;
}

- (void)setDisabled:(BOOL)disabled {
  _disabled = disabled;
  if (_disabledAlpha == 1.0) return;
  self.alpha = (_disabled ? _disabledAlpha : 1.0);
}

- (void)_cornerRadiusChanged {
  if (_borderStyle == GHUIBorderStyleNone && (_cornerRadius > 0 || _cornerRadiusRatio > 0)) {
    self.borderStyle = GHUIBorderStyleRounded;
  }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  [self willChangeValueForKey:@"cornerRadius"];
  _cornerRadius = cornerRadius;
  [self didChangeValueForKey:@"cornerRadius"];
  [self _cornerRadiusChanged];
}

- (void)setCornerRadiusRatio:(CGFloat)cornerRadiusRatio {
  [self willChangeValueForKey:@"cornerRadiusRatio"];
  _cornerRadiusRatio = cornerRadiusRatio;
  [self didChangeValueForKey:@"cornerRadiusRatio"];
  [self _cornerRadiusChanged];
}

- (UIImageView *)imageView {
  if (!_imageView) {
    _imageView = [[UIImageView alloc] init];
    [_imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
  }
  return _imageView;
}

- (void)setImage:(UIImage *)image {
  self.imageView.image = image;
}

- (void)sizeToFitWithMinimumSize:(CGSize)minSize {
  CGSize size = [self sizeThatFits:minSize];
  if (size.width < minSize.width) size.width = minSize.width;
  if (size.height < minSize.height) size.height = minSize.height;
  self.frame = GHCGRectSetSize(self.frame, size);
}

- (void)setBorderStyle:(GHUIBorderStyle)borderStyle {
  _borderStyle = borderStyle;
  [self didChangeValueForKey:@"borderStyle"];
}

- (void)setBorderStyle:(GHUIBorderStyle)borderStyle color:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius {
  self.borderStyle = borderStyle;
  self.borderColor = color;
  self.borderWidth = width;
  self.cornerRadius = cornerRadius;
}

- (UIColor *)textColorForState {
  
  BOOL isSelected = self.isSelected;
  BOOL isHighlighted = self.isHighlighted;
  BOOL isDisabled = self.isDisabled;
  
  if (_selectedTextColor && isSelected) {
    return _selectedTextColor;
  } else if (_highlightedTextColor && isHighlighted) {
    return _highlightedTextColor;
  } else if (_disabledTextColor && isDisabled) {
    return _disabledTextColor;
  } else if (_textColor) {
    return _textColor;
  } else {
    return [UIColor blackColor];
  }
}

- (UIActivityIndicatorView *)activityIndicatorView {
  if (!_activityIndicatorView) {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    [self addSubview:_activityIndicatorView];
  }
  return _activityIndicatorView;
}

- (void)setActivityIndicatorAnimating:(BOOL)animating {
  if (animating) {
    [self.activityIndicatorView startAnimating];
  } else {
    [_activityIndicatorView stopAnimating];
  }
  [self setNeedsLayout];
}

- (BOOL)isAnimating {
  return [_activityIndicatorView isAnimating];
}

- (void)drawInRect:(CGRect)rect {
  // Force layout if we never have
  if (GHCGSizeIsZero(_sizeThatFitsText)) [self layoutView];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGRect bounds = rect;
  bounds = UIEdgeInsetsInsetRect(bounds, self.margin);
  CGSize size = bounds.size;
  
  size.height -= self.insets.top + self.insets.bottom;
  
  BOOL isHighlighted = self.isHighlighted;
  BOOL isSelected = self.isSelected;
  BOOL isDisabled = self.isDisabled;
  
  GHUIShadingType shadingType = self.shadingType;
  UIColor *fillColor = self.fillColor;
  UIColor *fillColor2 = self.fillColor2;
  UIColor *fillColor3 = self.fillColor3;
  UIColor *fillColor4 = self.fillColor4;
  UIColor *borderColor = self.borderColor;
  
  CGFloat cornerRadius = self.cornerRadius;
  if (self.cornerRadiusRatio > 0) {
    cornerRadius = roundf((bounds.size.height/2.0f) * self.cornerRadiusRatio);
  }
  
  UIImage *accessoryImage = self.accessoryImage;
  
  if (isDisabled) {
    if (self.disabledShadingType != GHUIShadingTypeUnknown) shadingType = self.disabledShadingType;
    if (self.disabledFillColor) fillColor = self.disabledFillColor;
    if (self.disabledFillColor2) fillColor2 = self.disabledFillColor2;
    if (self.disabledBorderColor) borderColor = self.disabledBorderColor;
  } else if (isHighlighted) {
    if (self.highlightedShadingType != GHUIShadingTypeUnknown) shadingType = self.highlightedShadingType;
    if (self.highlightedFillColor) fillColor = self.highlightedFillColor;
    if (self.highlightedFillColor2) fillColor2 = self.highlightedFillColor2;
    if (self.highlightedBorderColor) borderColor = self.highlightedBorderColor;
    if (self.highlightedAccessoryImage) accessoryImage = self.highlightedAccessoryImage;
  } else if (isSelected) {
    // Set from selected properties; Fall back to highlighted properties
    if (self.selectedShadingType != GHUIShadingTypeUnknown) shadingType = self.selectedShadingType;
    else if (self.highlightedShadingType != GHUIShadingTypeUnknown) shadingType = self.highlightedShadingType;
    if (self.selectedFillColor) fillColor = self.selectedFillColor;
    else if (self.highlightedFillColor) fillColor = self.highlightedFillColor;
    if (self.selectedFillColor2) fillColor2 = self.selectedFillColor2;
    else if (self.highlightedFillColor2) fillColor2 = self.highlightedFillColor2;
  }
  
  CGFloat borderWidth = self.borderWidth;
  
  // Clip for border styles that support it (that form a cohesive path)
  BOOL clip = GHIsBorderStyleClippable(self.borderStyle, cornerRadius);
  
  GHCGContextAddStyledRect(context, bounds, self.borderStyle, borderWidth, cornerRadius);
  if (clip) {
    CGContextSaveGState(context);
    CGContextClip(context);
  }
  
  if (fillColor && shadingType != GHUIShadingTypeNone) {
    GHCGContextDrawShading(context, fillColor.CGColor, fillColor2.CGColor, fillColor3.CGColor, fillColor4.CGColor, bounds.origin, CGPointMake(bounds.origin.x, CGRectGetMaxY(bounds)), shadingType, NO, NO);
    fillColor = nil;
  } else if (fillColor) {
    [fillColor setFill];
    CGContextFillRect(context, bounds);
  }
  
  UIColor *textColor = [self textColorForState];
  
  UIFont *font = _font;
  
  CGFloat x = bounds.origin.x;
  CGFloat y = bounds.origin.y;
  
  // Draw image
  UIImage *image = self.imageView.image;
  CGSize imageSize = self.imageSize;
  if (image && GHCGSizeIsZero(imageSize)) {
    imageSize = image.size;
  }
  if (image) {
    [image drawInRect:CGRectMake(x, y, imageSize.width, imageSize.height)];
  }
  
  CGSize sizeThatFits = _sizeThatFitsText;

  x += self.insets.left;
  y += roundf(GHCGPointToCenter(sizeThatFits, size).y) + self.insets.top;
  
  UIEdgeInsets textInsets = _textInsets;
  
  CGFloat lineWidth = sizeThatFits.width + textInsets.left + textInsets.right;
  if (accessoryImage) lineWidth += accessoryImage.size.width;
  
  if (_textAlignment == NSTextAlignmentCenter) {
    CGFloat width = size.width - self.insets.left - self.insets.right;
    x += roundf(width/2.0f - lineWidth/2.0f);
  }
  if (x < 0) x = 0;
  
  x += textInsets.left;
  
  CGPoint textOrigin = CGPointMake(x, y);
  
  if (_text && [self shouldDrawText]) {
    [GHUIUtils drawText:_text rect:CGRectMake(textOrigin.x, textOrigin.y, _textSize.width, _textSize.height) font:font color:textColor alignment:_textAlignment multiline:YES truncate:YES];
  }
  
  if (self.accessoryText && [self shouldDrawText]) {
    if (self.accessoryTextColor) textColor = self.accessoryTextColor;
    if (self.accessoryTextFont) font = self.accessoryTextFont;
    if (self.accessoryTextAlignment == NSTextAlignmentLeft) {
      x += _textSize.width;
      CGFloat accessoryTextWidth = size.width - x - self.insets.right - textInsets.right;
      [GHUIUtils drawText:self.accessoryText rect:CGRectMake(x, y, accessoryTextWidth, CGFLOAT_MAX) font:font color:textColor alignment:NSTextAlignmentLeft multiline:YES truncate:YES];
    } else if (self.accessoryTextAlignment == NSTextAlignmentRight) {
      x += _textSize.width;
      [GHUIUtils drawText:self.accessoryText rect:CGRectMake(x, y, size.width - x - self.insets.right - _textInsets.right, size.height) font:font color:textColor alignment:NSTextAlignmentRight multiline:YES truncate:YES];
    } else {
      NSAssert(NO, @"Unsupported accessory text alignment");
    }
  }
  
  if (accessoryImage) {
    [accessoryImage drawAtPoint:GHCGPointToRight(accessoryImage.size, CGSizeMake(size.width - 10, bounds.size.height))];
  }
  
//  // Arrow
//  if (self.leftArrowColor) {
//    CGContextBeginPath(context); // Clear any paths
//    CGFloat arrowHalf = roundf((size.height - 12.0f)/2.0f);
//    CGFloat arrowX = bounds.origin.x + 2;
//    CGFloat arrowY = bounds.origin.y + 6;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(arrowX + arrowHalf, arrowY)];
//    [path addLineToPoint:CGPointMake(arrowX, arrowY + arrowHalf)];
//    [path addLineToPoint:CGPointMake(arrowX + arrowHalf, arrowY + arrowHalf + arrowHalf)];
//    [self.leftArrowColor setStroke];
//    [path setLineWidth:3];
//    [path stroke];
//  }
  
  y += _textSize.height;
  
  if (_secondaryText && [self shouldDrawText]) {
    if (_secondaryTextColor) textColor = _secondaryTextColor;
    if (_secondaryTextFont) font = _secondaryTextFont;
    if (_secondaryTextAlignment == NSTextAlignmentLeft) {
      x = textOrigin.x;
    } else {
      x = self.insets.left;
    }
    [GHUIUtils drawText:self.secondaryText rect:CGRectMake(x, y, size.width - x - self.insets.right, CGFLOAT_MAX) font:font color:textColor alignment:self.secondaryTextAlignment multiline:YES truncate:YES];
  }
  
  if (clip) {
    CGContextRestoreGState(context);
  }
  
  if (borderWidth > 0 && self.borderColor) {
    GHCGContextDrawBorder(context, bounds, self.borderStyle, NULL, borderColor.CGColor, borderWidth, cornerRadius);
  }
}

- (void)drawRect:(CGRect)rect {
  [self drawInRect:self.bounds];
}

@end
