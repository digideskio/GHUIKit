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
  self.selectedShadingType = GHUIShadingTypeUnknown;
  self.highlightedShadingType = GHUIShadingTypeUnknown;
  self.disabledShadingType = GHUIShadingTypeUnknown;
  self.disabledAlpha = 1.0;
  self.titleColor = [UIColor blackColor];
  self.titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  self.textFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  
  _observeAttributes = @[@"title", @"titleInsets", @"titleFont", @"titleAlignment", @"text", @"textFont", @"textAlignment", @"cornerRadius", @"cornerRadiusRatio", @"accessoryTitle", @"borderStyle"];
  for (NSString *attr in _observeAttributes) {
    [self addObserver:self forKeyPath:attr options:NSKeyValueObservingOptionNew context:nil];
  }
}

- (void)dealloc {
  for (NSString *attr in _observeAttributes) {
    [self removeObserver:self forKeyPath:attr];
  }
  [_imageView removeObserver:self forKeyPath:@"image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  [self setNeedsLayout];
}

- (CGSize)_sizeText:(CGSize)constrainedToSize {
  CGSize size = CGSizeZero;
  
  if (_title) {
    size = [GHUIUtils sizeWithText:_title font:self.titleFont size:constrainedToSize multiline:YES truncate:YES];
  }
  
  if (_accessoryTitle) {
    constrainedToSize.width -= roundf(size.width);
    UIFont *font = (_accessoryTitleFont ? _accessoryTitleFont : _titleFont);
    CGSize accessoryTitleSize = [GHUIUtils sizeWithText:_accessoryTitle font:font size:constrainedToSize multiline:NO truncate:YES];
    size.width += roundf(accessoryTitleSize.width);
  }
  
  if (_text) {
    UIFont *font = (_textFont ? _textFont : _titleFont);
    CGSize textSize = [GHUIUtils sizeWithText:_text font:font size:constrainedToSize multiline:YES truncate:YES];
    size.height += roundf(textSize.height);
  }
  
  return size;
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  CGFloat y = 0;
  
  y += _insets.top;
  UIEdgeInsets titleInsets = _titleInsets;
  y += titleInsets.top;
  
  CGSize imageSize = [self _imageSize];
  
  _sizeThatFitsText = CGSizeZero;
  _titleSize = CGSizeZero;
  
  CGSize constrainedToSize = size;
  // Subtract insets
  constrainedToSize.width -= (titleInsets.left + titleInsets.right);
  constrainedToSize.width -= (_insets.left + _insets.right);
  
  constrainedToSize.width -= imageSize.width;
  
  // Subtract activity indicator view
  if (_activityIndicatorView && _activityIndicatorView.isAnimating) {
    constrainedToSize.width -= _activityIndicatorView.frame.size.width;
  }
  
  if (constrainedToSize.height == 0) {
    constrainedToSize.height = CGFLOAT_MAX;
  }
  
  _sizeThatFitsText = [self _sizeText:constrainedToSize];
  _titleSize = [GHUIUtils sizeWithText:_title font:_titleFont size:constrainedToSize multiline:YES truncate:YES];
  
  if (_activityIndicatorView) {
    CGPoint p = GHCGPointToCenter(_sizeThatFitsText, size);
    p.x -= _activityIndicatorView.frame.size.width + 4;
    p.y = GHCGPointToCenter(_activityIndicatorView.bounds.size, size).y;
    [layout setOrigin:p view:_activityIndicatorView];
  }
  
  if (imageSize.height > _sizeThatFitsText.height) {
    y += imageSize.height;
  } else {
    y += _sizeThatFitsText.height;
  }
  
  y += titleInsets.bottom;
  y += _insets.bottom;
  
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
  CGSize imageSize = [self _imageSize];
  CGSize sizeForHeight = [GHUIUtils sizeWithText:_title font:_titleFont size:size multiline:NO truncate:NO];
  sizeForHeight.width += self.insets.left + self.insets.right;
  sizeForHeight.width += self.titleInsets.left + self.titleInsets.right;
  sizeForHeight.width += imageSize.width;
  if (self.accessoryImage) sizeForHeight.width += self.accessoryImage.size.width;
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
  
  if (_selectedTitleColor && isSelected) {
    return _selectedTitleColor;
  } else if (_highlightedTitleColor && isHighlighted) {
    return _highlightedTitleColor;
  } else if (_disabledTitleColor && isDisabled) {
    return _disabledTitleColor;
  } else if (_titleColor) {
    return _titleColor;
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
  if (animating) [self.activityIndicatorView startAnimating];
  else [self.activityIndicatorView stopAnimating];
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
  
  UIImage *backgroundImage = self.backgroundImage;
  
  CGFloat cornerRadius = self.cornerRadius;
  if (self.cornerRadiusRatio > 0) {
    cornerRadius = roundf(bounds.size.height/2.0f) * self.cornerRadiusRatio;
  }
  
  UIImage *accessoryImage = self.accessoryImage;
  
  if (isDisabled) {
    if (self.disabledShadingType != GHUIShadingTypeUnknown) shadingType = self.disabledShadingType;
    if (self.disabledFillColor) fillColor = self.disabledFillColor;
    if (self.disabledFillColor2) fillColor2 = self.disabledFillColor2;
    if (self.disabledBorderColor) borderColor = self.disabledBorderColor;
    if (self.disabledBackgroundImage) backgroundImage = self.disabledBackgroundImage;
  } else if (isHighlighted) {
    if (self.highlightedShadingType != GHUIShadingTypeUnknown) shadingType = self.highlightedShadingType;
    if (self.highlightedFillColor) fillColor = self.highlightedFillColor;
    if (self.highlightedFillColor2) fillColor2 = self.highlightedFillColor2;
    if (self.highlightedBackgroundImage) backgroundImage = self.highlightedBackgroundImage;
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
    if (self.highlightedBackgroundImage) backgroundImage = self.highlightedBackgroundImage;
  }
  
  CGFloat borderWidth = self.borderWidth;
  
  // Clip for border styles that support it (that form a cohesive path)
  BOOL clip = (self.borderStyle != GHUIBorderStyleTopOnly && self.borderStyle != GHUIBorderStyleBottomOnly && self.borderStyle != GHUIBorderStyleTopBottom && self.borderStyle != GHUIBorderStyleNone && self.borderStyle != GHUIBorderStyleNormal);
  
  if (fillColor && shadingType != GHUIShadingTypeNone) {
    if (clip) {
      CGContextSaveGState(context);
    }
    
    GHCGContextAddStyledRect(context, bounds, self.borderStyle, borderWidth, cornerRadius);
    if (clip) {
      CGContextClip(context);
    }
    
    GHCGContextDrawShading(context, fillColor.CGColor, fillColor2.CGColor, fillColor3.CGColor, fillColor4.CGColor, bounds.origin, CGPointMake(bounds.origin.x, CGRectGetMaxY(bounds)), shadingType, NO, NO);
    fillColor = nil;
    
    if (clip) {
      CGContextRestoreGState(context);
    }
  }
  
  if (self.borderWidth > 0 || cornerRadius > 0) {
    GHCGContextDrawBorder(context, bounds, self.borderStyle, fillColor.CGColor, borderColor.CGColor, borderWidth, cornerRadius);
  } else if (fillColor) {
    [fillColor setFill];
    CGContextFillRect(context, bounds);
  }
  
  if (backgroundImage) {
    [backgroundImage drawInRect:bounds];
  }
  
  UIColor *textColor = [self textColorForState];
  
  UIFont *font = self.titleFont;
  
  NSString *title = self.title;
  
  UIImage *image = self.imageView.image;
  CGSize imageSize = self.imageSize;
  if (image && GHCGSizeIsZero(imageSize)) {
    imageSize = image.size;
  }
  
  CGSize sizeThatFits = _sizeThatFitsText;
  if (imageSize.height > sizeThatFits.height) {
    sizeThatFits.height = imageSize.height;
  }
  
  CGFloat y = bounds.origin.y + roundf(GHCGPointToCenter(sizeThatFits, size).y) + self.insets.top;
  
  UIEdgeInsets titleInsets = _titleInsets;
  
  CGFloat x = bounds.origin.x + self.insets.left;
  CGFloat lineWidth = sizeThatFits.width + titleInsets.left + titleInsets.right + imageSize.width;
  if (accessoryImage) lineWidth += accessoryImage.size.width;
  
  if (self.titleAlignment == NSTextAlignmentCenter) {
    CGFloat width = size.width - self.insets.left - self.insets.right;
    x += roundf(width/2.0f - lineWidth/2.0f);
  }
  if (x < 0) x = 0;
  
  if (image) {
    [self.imageView.image drawInRect:CGRectMake(x, y, imageSize.width, imageSize.height)];
  }
  x += imageSize.width;
  
  x += titleInsets.left;
  
  CGPoint titleOrigin = CGPointMake(x, y);
  
  [GHUIUtils drawText:title rect:CGRectMake(titleOrigin.x, titleOrigin.y, _titleSize.width, _titleSize.height) font:font color:textColor alignment:self.titleAlignment multiline:YES truncate:YES];
  
  if (self.accessoryTitle) {
    if (self.accessoryTitleColor) textColor = self.accessoryTitleColor;
    if (self.accessoryTitleFont) font = self.accessoryTitleFont;
    if (self.accessoryTitleAlignment == NSTextAlignmentLeft) {
      x += _titleSize.width;
      CGFloat accessoryTitleWidth = size.width - x - self.insets.right - titleInsets.right;
      [GHUIUtils drawText:self.accessoryTitle rect:CGRectMake(x, y, accessoryTitleWidth, CGFLOAT_MAX) font:font color:textColor alignment:NSTextAlignmentLeft multiline:YES truncate:YES];
    } else if (self.accessoryTitleAlignment == NSTextAlignmentRight) {
      x += _titleSize.width;
      [GHUIUtils drawText:self.accessoryTitle rect:CGRectMake(x, y, size.width - x - self.insets.right - self.titleInsets.right, size.height) font:font color:textColor alignment:NSTextAlignmentRight multiline:YES truncate:YES];
    } else {
      NSAssert(NO, @"Unsupported accessory title alignment");
    }
  }
  
  if (accessoryImage) {
    [accessoryImage drawAtPoint:GHCGPointToRight(accessoryImage.size, CGSizeMake(size.width - 10, bounds.size.height))];
  }
  
  // Arrow
  if (self.leftArrowColor) {
    CGContextBeginPath(context); // Clear any paths
    CGFloat arrowHalf = roundf((size.height - 12.0f)/2.0f);
    CGFloat arrowX = bounds.origin.x + 2;
    CGFloat arrowY = bounds.origin.y + 6;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(arrowX + arrowHalf, arrowY)];
    [path addLineToPoint:CGPointMake(arrowX, arrowY + arrowHalf)];
    [path addLineToPoint:CGPointMake(arrowX + arrowHalf, arrowY + arrowHalf + arrowHalf)];
    [self.leftArrowColor setStroke];
    [path setLineWidth:3];
    [path stroke];
  }
  
  y += _titleSize.height;
  
  if (self.text) {
    if (self.textColor) textColor = self.textColor;
    if (self.textFont) font = self.textFont;
    if (self.titleAlignment == NSTextAlignmentLeft) {
      x = titleOrigin.x;
    } else {
      x = self.insets.left;
    }
    [GHUIUtils drawText:self.text rect:CGRectMake(x, y, size.width - x - self.insets.right, CGFLOAT_MAX) font:font color:textColor alignment:self.textAlignment multiline:YES truncate:YES];
  }
}

- (void)drawRect:(CGRect)rect {
  [self drawInRect:self.bounds];
}

@end
