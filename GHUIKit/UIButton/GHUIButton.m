//
//  GHUIButton.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIButton.h"
#import "GHUIUtils.h"

@implementation GHUIButton

- (void)sharedInit {
  [super sharedInit];
  self.userInteractionEnabled = YES;
  self.layout = [GHLayout layoutForView:self];
  self.backgroundColor = [UIColor clearColor];
  self.opaque = YES;
  //self.contentMode = UIViewContentModeRedraw;
  self.titleAlignment = NSTextAlignmentCenter;
  self.insets = UIEdgeInsetsZero;
  self.titleInsets = UIEdgeInsetsZero;
  self.iconImageSize = CGSizeZero;
  self.highlightable = YES;
  self.iconOrigin = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
  self.selectedShadingType = GHUIShadingTypeUnknown;
  self.highlightedShadingType = GHUIShadingTypeUnknown;
  self.disabledShadingType = GHUIShadingTypeUnknown;
  self.margin = UIEdgeInsetsZero;
  self.disabledAlpha = 1.0;
  self.titleColor = [UIColor blackColor];
  self.titleFont = [UIFont boldSystemFontOfSize:14.0];
  self.accessibilityTraits |= UIAccessibilityTraitButton;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
  if ((self = [self initWithFrame:frame])) {
    _title = title;
  }
  return self;
}

+ (GHUIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title {
  return [[[self class] alloc] initWithFrame:frame title:title];
}

+ (GHUIButton *)buttonWithTitle:(NSString *)title {
  return [self buttonWithFrame:CGRectZero title:title];
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
  UIEdgeInsets titleInsets = [self _titleInsets];
  y += titleInsets.top;
  
  // If the title is nil, but _titleSize hasn't been updated yet
  // Happens when the title gets changed from non-nil to nil.
  if (!GHCGSizeIsZero(_sizeThatFitsText) && !_title) {
    _sizeThatFitsText = CGSizeZero;
  } else if (_title) {
    CGSize constrainedToSize = size;
    // Subtract insets
    constrainedToSize.width -= (titleInsets.left + titleInsets.right);
    constrainedToSize.width -= (_insets.left + _insets.right);
    
    // Subtract icon width
    CGSize iconSize = _iconImageSize;
    if (_iconImageView.image && GHCGSizeIsZero(iconSize)) {
      iconSize = _iconImageView.image.size;
      iconSize.width += 2; // TODO(gabe): Set configurable
    }
    if (_iconPosition == GHUIButtonIconPositionLeft) {
      constrainedToSize.width -= iconSize.width;
    }
    
    if (_activityIndicatorView && _activityIndicatorView.isAnimating) {
      constrainedToSize.width -= _activityIndicatorView.frame.size.width;
    }
    
    if (constrainedToSize.height == 0) {
      constrainedToSize.height = 9999;
    }
    
    _sizeThatFitsText = [self _sizeText:constrainedToSize];
    _titleSize = [GHUIUtils sizeWithText:_title font:_titleFont size:constrainedToSize multiline:YES truncate:YES];
    
    if (_activityIndicatorView) {
      CGPoint p = GHCGPointToCenter(_sizeThatFitsText, size);
      p.x -= _activityIndicatorView.frame.size.width + 4;
      [layout setOrigin:p view:_activityIndicatorView];
    }
    
    y += _sizeThatFitsText.height;
  }
  
  y += titleInsets.bottom;
  y += _insets.bottom;
  
  return CGSizeMake(size.width, y);
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  if (_disabledAlpha == 1.0) return;
  self.alpha = (!enabled ? _disabledAlpha : 1.0);
}

- (UIEdgeInsets)_titleInsets {
  UIEdgeInsets titleInsets = _titleInsets;
  if (_borderStyle == GHUIBorderStyleRoundedBack) {
    titleInsets.left += 4;
  }
  return titleInsets;
}

- (CGSize)sizeThatFitsInSize:(CGSize)size {
  CGSize sizeThatFitsText = [self _sizeText:size];
  CGSize accessoryImageSize = CGSizeZero;
  if (_accessoryImage) {
    accessoryImageSize = _accessoryImage.size;
    accessoryImageSize.width += 10;
  }
  UIEdgeInsets titleInsets = [self _titleInsets];
  CGSize sizeThatFits =  CGSizeMake(sizeThatFitsText.width + _insets.left + _insets.right + titleInsets.left + titleInsets.right + accessoryImageSize.width, sizeThatFitsText.height + titleInsets.top + titleInsets.bottom + _insets.top + _insets.bottom);
  
//  CGSize iconSize = _iconImageSize;
//  if (_iconImageView.image && GHCGSizeIsZero(iconSize)) {
//    iconSize = _iconImageView.image.size;
//  }
  return sizeThatFits;
}

- (void)setHighlighted:(BOOL)highlighted {
  for (UIView *view in [self subviews]) {
    if ([view respondsToSelector:@selector(setHighlighted:)]) {
      [(id)view setHighlighted:highlighted];
    }
  }
  [super setHighlighted:highlighted];
}

- (void)didChangeValueForKey:(NSString *)key {
  [super didChangeValueForKey:key];
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setTitleInsets:(UIEdgeInsets)titleInsets {
  _titleInsets = titleInsets;
  [self didChangeValueForKey:@"titleInsets"];
}

- (void)setTitleFont:(UIFont *)titleFont {
  _titleFont = titleFont;
  [self didChangeValueForKey:@"titleFont"];
}

- (void)setTitle:(NSString *)title {
  _title = title;
  [self didChangeValueForKey:@"title"];
}

- (void)setaccessoryTitle:(NSString *)accessoryTitle {
  _accessoryTitle = accessoryTitle;
  [self didChangeValueForKey:@"accessoryTitle"];
}

- (void)setColor:(UIColor *)color {
  _color = color;
  if (_shadingType == GHUIShadingTypeUnknown) {
    _shadingType = GHUIShadingTypeNone;
  }
  [self didChangeValueForKey:@"color"];
}

- (void)_cornerRadiusChanged {
  if (_borderStyle == GHUIBorderStyleNone && (_cornerRadius > 0 || _cornerRadiusRatio > 0)) {
    _borderStyle = GHUIBorderStyleRounded;
    [self didChangeValueForKey:@"borderStyle"];
  }
  [self didChangeValueForKey:@"cornerRadius"];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  [self _cornerRadiusChanged];
}

- (void)setCornerRadiusRatio:(CGFloat)cornerRadiusRatio {
  _cornerRadiusRatio = cornerRadiusRatio;
  [self didChangeValueForKey:@"cornerRadiusRatio"];
  [self _cornerRadiusChanged];
}

+ (GHUIButton *)button {
  return [[GHUIButton alloc] initWithFrame:CGRectZero];
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

- (void)setIconImage:(UIImage *)iconImage {
  _iconImageView = [[UIImageView alloc] initWithImage:iconImage];
  _iconImageView.contentMode = UIViewContentModeScaleToFill;
  _iconImageView.backgroundColor = [UIColor clearColor];
}

- (UIImage *)iconImage {
  return _iconImageView.image;
}

- (UIColor *)textColorForState:(UIControlState)state {
  
  BOOL isSelected = self.isSelected;
  BOOL isHighlighted = (self.isHighlighted && self.userInteractionEnabled);
  BOOL isDisabled = !self.isEnabled;
  
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
  UIActivityIndicatorView *activityIndicatorView = [self activityIndicatorView];
  if (animating) [activityIndicatorView startAnimating];
  else [activityIndicatorView stopAnimating];
  self.userInteractionEnabled = !animating;
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (BOOL)isAnimating {
  return [_activityIndicatorView isAnimating];
}

- (void)drawInRect:(CGRect)rect {
  // Force layout if we never have
  if (GHCGSizeIsZero(_sizeThatFitsText)) [self layoutView];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  UIControlState state = self.state;
  CGRect bounds = rect;
  bounds = UIEdgeInsetsInsetRect(bounds, self.margin);
  CGSize size = bounds.size;
  
  size.height -= self.insets.top + self.insets.bottom;
  
  BOOL isHighlighted = (self.isHighlighted && self.userInteractionEnabled && self.isHighlightable);
  BOOL isSelected = self.isSelected;
  BOOL isDisabled = !self.isEnabled;
  
  GHUIShadingType shadingType = self.shadingType;
  UIColor *color = self.color;
  UIColor *color2 = self.color2;
  UIColor *color3 = self.color3;
  UIColor *color4 = self.color4;
  UIColor *borderColor = self.borderColor;
  
  UIImage *image = self.image;
  
  CGFloat cornerRadius = self.cornerRadius;
  if (self.cornerRadiusRatio > 0) {
    cornerRadius = roundf(bounds.size.height/2.0f) * self.cornerRadiusRatio;
  }
  
  UIImage *icon = self.iconImageView.image;
  UIImage *accessoryImage = self.accessoryImage;
  
  if (isDisabled) {
    if (self.disabledShadingType != GHUIShadingTypeUnknown) shadingType = self.disabledShadingType;
    if (self.disabledColor) color = self.disabledColor;
    if (self.disabledColor2) color2 = self.disabledColor2;
    if (self.disabledBorderColor) borderColor = self.disabledBorderColor;
    if (self.disabledImage) image = self.disabledImage;
    if (self.disabledIconImage) icon = self.disabledIconImage;
  } else if (isHighlighted) {
    if (self.highlightedShadingType != GHUIShadingTypeUnknown) shadingType = self.highlightedShadingType;
    if (self.highlightedColor) color = self.highlightedColor;
    if (self.highlightedColor2) color2 = self.highlightedColor2;
    if (self.highlightedImage) image = self.highlightedImage;
    if (self.highlightedBorderColor) borderColor = self.highlightedBorderColor;
    if (self.highlightedIconImage) icon = self.highlightedIconImage;
    if (self.highlightedAccessoryImage) accessoryImage = self.highlightedAccessoryImage;
  } else if (isSelected) {
    // Set from selected properties; Fall back to highlighted properties
    if (self.selectedShadingType != GHUIShadingTypeUnknown) shadingType = self.selectedShadingType;
    else if (self.highlightedShadingType != GHUIShadingTypeUnknown) shadingType = self.highlightedShadingType;
    if (self.selectedColor) color = self.selectedColor;
    else if (self.highlightedColor) color = self.highlightedColor;
    if (self.selectedColor2) color2 = self.selectedColor2;
    else if (self.highlightedColor2) color2 = self.highlightedColor2;
    if (self.highlightedImage) image = self.highlightedImage;
    if (self.selectedIconImage) icon = self.selectedIconImage;
  }
  
  UIColor *fillColor = color;
  
  CGFloat borderWidth = self.borderWidth;
  
  // Clip for border styles that support it (that form a cohesive path)
  BOOL clip = (self.borderStyle != GHUIBorderStyleTopOnly && self.borderStyle != GHUIBorderStyleBottomOnly && self.borderStyle != GHUIBorderStyleTopBottom && self.borderStyle != GHUIBorderStyleNone && self.borderStyle != GHUIBorderStyleNormal);
  
  if (color && shadingType != GHUIShadingTypeNone) {
    if (clip) {
      CGContextSaveGState(context);
    }
    
    GHCGContextAddStyledRect(context, bounds, self.borderStyle, borderWidth, cornerRadius);
    if (clip) {
      CGContextClip(context);
    }

    GHCGContextDrawShading(context, color.CGColor, color2.CGColor, color3.CGColor, color4.CGColor, bounds.origin, CGPointMake(bounds.origin.x, CGRectGetMaxY(bounds)), shadingType, NO, NO);
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
  
  if (image) {
    [image drawInRect:bounds];
  }
  
  UIColor *textColor = [self textColorForState:state];
  
  UIFont *font = self.titleFont;
  
  NSString *title = self.title;
  CGSize sizeThatFitsText = _sizeThatFitsText;
    
  CGFloat y = bounds.origin.y + roundf(GHCGPointToCenter(sizeThatFitsText, size).y) + self.insets.top;
  
  BOOL showIcon = (icon != nil && !self.iconImageView.hidden);
  CGSize iconSize = self.iconImageSize;
  if (icon && GHCGSizeIsZero(iconSize)) {
    iconSize = icon.size;
  }
  
  UIEdgeInsets titleInsets = [self _titleInsets];

  CGFloat lineWidth = sizeThatFitsText.width + titleInsets.left + titleInsets.right;
  if (showIcon && self.iconPosition == GHUIButtonIconPositionLeft) lineWidth += iconSize.width;
  CGFloat x = bounds.origin.x;
  
  if (self.titleAlignment == NSTextAlignmentCenter) {
    CGFloat width = size.width - self.insets.left - self.insets.right;
    if (accessoryImage) width -= accessoryImage.size.width;
    x += roundf(width/2.0 - lineWidth/2.0) + self.insets.left;
  } else {
    x += self.insets.left;
  }
  if (x < 0) x = 0;
  
  if (showIcon) {
    switch (self.iconPosition) {
      case GHUIButtonIconPositionLeft: {
        CGPoint iconTop = GHCGPointToCenter(iconSize, size);
        iconTop.x = x;
        iconTop.y += bounds.origin.y + self.insets.top;
        [self.iconImageView.image drawInRect:CGRectMake(iconTop.x, iconTop.y, iconSize.width, iconSize.height)];
        x += iconSize.width;
        break;
      }
      case GHUIButtonIconPositionTop: {
        CGPoint iconTop = GHCGPointToCenter(iconSize, size);
        [self.iconImageView.image drawInRect:CGRectMake(iconTop.x, self.insets.top, iconSize.width, iconSize.height)];
        y = self.insets.top + iconSize.height + titleInsets.top;
        break;
      }
      case GHUIButtonIconPositionCenter: {
        CGPoint iconTop = GHCGPointToCenter(iconSize, CGSizeMake(size.width, size.height - sizeThatFitsText.height));
        if (self.iconOrigin.x != CGFLOAT_MAX) iconTop.x = self.iconOrigin.x;
        if (self.iconOrigin.y != CGFLOAT_MAX) iconTop.y = self.iconOrigin.y;
        [self.iconImageView.image drawInRect:CGRectMake(iconTop.x, iconTop.y + self.insets.top, iconSize.width, iconSize.height)];
        y = iconTop.y + self.insets.top + iconSize.height + titleInsets.top;
        break;
      }
    }
    showIcon = NO;
  }
  
  x += titleInsets.left;
  if (y < self.insets.top) y = self.insets.top + titleInsets.top;
  
  [GHUIUtils drawText:title rect:CGRectMake(x, y, _titleSize.width, _titleSize.height) font:font color:textColor alignment:self.titleAlignment multiline:YES truncate:YES];

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
  
  if (showIcon) {
    [self.iconImageView.image drawInRect:GHCGRectToCenterInRect(iconSize, bounds)];
    CGContextSetShadowWithColor(context, CGSizeZero, 0.0, NULL);
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
    [GHUIUtils drawText:self.text rect:CGRectMake(self.insets.left, y, size.width - self.insets.left - self.insets.right, CGFLOAT_MAX) font:font color:textColor alignment:self.textAlignment multiline:YES truncate:YES];
  }
}

- (void)drawRect:(CGRect)rect {
  [self drawInRect:self.bounds];
}

@end


