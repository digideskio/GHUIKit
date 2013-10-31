//
//  GHUIButton.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIButton.h"

@implementation GHUIButton

- (void)sharedInit {
  [super sharedInit];
  self.userInteractionEnabled = YES;
  self.layout = [GHLayout layoutForView:self];
  self.opaque = YES;
  self.backgroundColor = [UIColor clearColor];
  self.contentMode = UIViewContentModeRedraw;
  self.titleAlignment = NSTextAlignmentCenter;
  self.insets = UIEdgeInsetsZero;
  self.titleInsets = UIEdgeInsetsZero;
  self.iconImageSize = CGSizeZero;
  self.highlightedEnabled = YES;
  self.iconOrigin = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
  self.selectedShadingType = GHUIShadingTypeUnknown;
  self.highlightedShadingType = GHUIShadingTypeUnknown;
  self.disabledShadingType = GHUIShadingTypeUnknown;
  self.margin = UIEdgeInsetsZero;
  self.disabledAlpha = 1.0;
  self.titleColor = [UIColor blackColor];
  self.titleFont = [UIFont boldSystemFontOfSize:14.0];
  self.titleShadowOffset = CGSizeZero;
  self.accessibilityTraits |= UIAccessibilityTraitButton;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
  if ((self = [self initWithFrame:frame])) {
    _title = title;
  }
  return self;
}

- (id)initWithContentView:(UIView *)contentView {
  if ((self = [self initWithFrame:CGRectZero])) {
    [self setContentView:contentView];
  }
  return self;
}

+ (GHUIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title {
  return [[[self class] alloc] initWithFrame:frame title:title];
}

+ (GHUIButton *)buttonWithTitle:(NSString *)title {
  return [self buttonWithFrame:CGRectZero title:title];
}

- (CGSize)_sizeForTitle:(NSString *)title constrainedToSize:(CGSize)constrainedToSize {
  if (_maxLineCount > 0) {
    CGSize lineSize = [@" " sizeWithFont:self.titleFont];
    constrainedToSize.height = lineSize.height * self.maxLineCount;
  }
  
  CGSize titleSize = CGSizeZero;
  
  if (title) {
    titleSize = [title sizeWithFont:self.titleFont constrainedToSize:constrainedToSize lineBreakMode:NSLineBreakByTruncatingTail];
    // TODO: Probably need this because sizeWithFont and draw methods produce different sizing
    titleSize.width += 2;
  }
  
  if (_secondaryTitle) {
    if (_secondaryTitlePosition == GHUIButtonSecondaryTitlePositionDefault || _secondaryTitlePosition == GHUIButtonSecondaryTitlePositionRightAlign) {
      constrainedToSize.width -= roundf(titleSize.width);
      CGSize secondaryTitleSize = [_secondaryTitle sizeWithFont:(_secondaryTitleFont ? _secondaryTitleFont : _titleFont) constrainedToSize:constrainedToSize lineBreakMode:NSLineBreakByTruncatingTail];
      titleSize.width += roundf(secondaryTitleSize.width);
    } else if (_secondaryTitlePosition == GHUIButtonSecondaryTitlePositionBottom) {
      CGSize secondaryTitleSize = [_secondaryTitle sizeWithFont:(_secondaryTitleFont ? _secondaryTitleFont : _titleFont) constrainedToSize:constrainedToSize lineBreakMode:NSLineBreakByTruncatingTail];
      titleSize.height += roundf(secondaryTitleSize.height);
    } else if (_secondaryTitlePosition == GHUIButtonSecondaryTitlePositionBottomLeftSingle) {
      CGSize secondaryTitleSize = [_secondaryTitle sizeWithFont:(_secondaryTitleFont ? _secondaryTitleFont : _titleFont)];
      titleSize.height += roundf(secondaryTitleSize.height);
    }
  }
  return titleSize;
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  if (_contentView) {
    CGFloat y = _insets.top;
    
    // TODO: UILabel sizeToFit with 0 height will not work? Special case it?
    CGRect contentViewFrame = [layout setFrame:CGRectMake(_insets.left, y, size.width - _insets.left - _insets.right, 0) view:_contentView options:GHLayoutOptionsSizeToFit|GHLayoutOptionsVariableWidth];
    y += contentViewFrame.size.height;
    return CGSizeMake(size.width, y + _insets.bottom);
  }
  
  CGFloat y = 0;
  
  y += _insets.top;
  UIEdgeInsets titleInsets = [self _titleInsets];
  y += titleInsets.top;
  
  // If the title is nil, but _titleSize hasn't been updated yet
  // Happens when the title gets changed from non-nil to nil.
  if (!GHCGSizeIsZero(_titleSize) && !_title) {
    _titleSize = CGSizeZero;
    _abbreviatedTitleSize = CGSizeZero;
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
    
    _titleSize = [self _sizeForTitle:_title constrainedToSize:constrainedToSize];
    _abbreviatedTitleSize = [self _sizeForTitle:_abbreviatedTitle constrainedToSize:constrainedToSize];
    
    if (_activityIndicatorView) {
      if (_titleHidden) {
        CGPoint p = GHCGPointToCenter(_activityIndicatorView.frame.size, size);
        [layout setOrigin:p view:_activityIndicatorView];
      } else {
        CGPoint p = GHCGPointToCenter(_titleSize, size);
        p.x -= _activityIndicatorView.frame.size.width + 4;
        [layout setOrigin:p view:_activityIndicatorView];
      }
    }
    
    y += _titleSize.height;
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

- (CGSize)sizeThatFitsTitle:(CGSize)size minWidth:(CGFloat)minWidth {
  CGSize sizeThatFitsTitle = [self sizeThatFitsTitle:size];
  if (sizeThatFitsTitle.width < minWidth) sizeThatFitsTitle.width = minWidth;
  return sizeThatFitsTitle;
}

- (CGSize)sizeThatFitsTitle:(CGSize)size {
  CGSize titleSize = [self _sizeForTitle:_title constrainedToSize:size];
  CGSize accessoryImageSize = CGSizeZero;
  if (_accessoryImage) {
    accessoryImageSize = _accessoryImage.size;
    accessoryImageSize.width += 10;
  }
  UIEdgeInsets titleInsets = [self _titleInsets];
  return CGSizeMake(titleSize.width + _insets.left + _insets.right + titleInsets.left + titleInsets.right + accessoryImageSize.width, titleSize.height + titleInsets.top + titleInsets.bottom + _insets.top + _insets.bottom);
}

- (CGSize)sizeThatFitsTitleAndIcon:(CGSize)size {
  CGSize titleSize = [self sizeThatFitsTitle:size];
  CGSize iconSize = _iconImageSize;
  if (_iconImageView.image && GHCGSizeIsZero(iconSize)) {
    iconSize = _iconImageView.image.size;
  }
  return CGSizeMake(titleSize.width + iconSize.width, titleSize.height + iconSize.height);
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

- (void)setSecondaryTitle:(NSString *)secondaryTitle {
  _secondaryTitle = secondaryTitle;
  [self didChangeValueForKey:@"secondaryTitle"];
}

- (void)setTitleHidden:(BOOL)titleHidden {
  _titleHidden = titleHidden;
  [self didChangeValueForKey:@"titleHidden"];
}

- (void)setContentView:(UIView *)contentView {
  [contentView removeFromSuperview];
  [_contentView removeFromSuperview];
  _contentView = contentView;
  [self addSubview:_contentView];
  [self didChangeValueForKey:@"contentView"];
}

- (void)setColor:(UIColor *)color {
  _color = color;
  // Set shading type to none if a color is set
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

- (void)setNeedsDisplay {
  [super setNeedsDisplay];
  [_contentView setNeedsDisplay];
}

- (void)drawInRect:(CGRect)rect {
  // Force layout if we never have
  if (GHCGSizeIsZero(_titleSize)) [self layoutView];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  UIControlState state = self.state;
  CGRect bounds = rect;
  bounds = UIEdgeInsetsInsetRect(bounds, self.margin);
  CGSize size = bounds.size;
  
  size.height -= self.insets.top + self.insets.bottom;
  
  BOOL isHighlighted = (self.isHighlighted && self.userInteractionEnabled && self.isHighlightedEnabled);
  BOOL isSelected = self.isSelected;
  BOOL isDisabled = !self.isEnabled;
  
  GHUIShadingType shadingType = self.shadingType;
  UIColor *color = self.color;
  UIColor *color2 = self.color2;
  UIColor *color3 = self.color3;
  UIColor *color4 = self.color4;
  UIColor *borderColor = self.borderColor;
  
  UIImage *image = self.image;
  
  UIColor *borderShadowColor = self.borderShadowColor;
  CGFloat borderShadowBlur = self.borderShadowBlur;
  
  CGFloat cornerRadius = self.cornerRadius;
  if (self.cornerRadiusRatio > 0) {
    cornerRadius = roundf(bounds.size.height/2.0f) * self.cornerRadiusRatio;
  }
  
  UIColor *titleShadowColor = self.titleShadowColor;
  CGSize titleShadowOffset = self.titleShadowOffset;
  UIImage *icon = self.iconImageView.image;
  UIImage *accessoryImage = self.accessoryImage;
  
  if (isDisabled) {
    if (self.disabledShadingType != GHUIShadingTypeUnknown) shadingType = self.disabledShadingType;
    if (self.disabledColor) color = self.disabledColor;
    if (self.disabledColor2) color2 = self.disabledColor2;
    if (self.disabledBorderColor) borderColor = self.disabledBorderColor;
    if (self.disabledImage) image = self.disabledImage;
    if (self.disabledIconImage) icon = self.disabledIconImage;
    if (self.disabledTitleShadowColor) titleShadowColor = self.disabledTitleShadowColor;
  } else if (isHighlighted) {
    if (self.highlightedShadingType != GHUIShadingTypeUnknown) shadingType = self.highlightedShadingType;
    if (self.highlightedColor) color = self.highlightedColor;
    if (self.highlightedColor2) color2 = self.highlightedColor2;
    if (self.highlightedImage) image = self.highlightedImage;
    if (self.highlightedBorderColor) borderColor = self.highlightedBorderColor;
    if (self.highlightedBorderShadowColor) borderShadowColor = self.highlightedBorderShadowColor;
    if (self.highlightedBorderShadowBlur) borderShadowBlur = self.highlightedBorderShadowBlur;
    if (self.highlightedTitleShadowColor) titleShadowColor = self.highlightedTitleShadowColor;
    if (!CGSizeEqualToSize(self.highlightedTitleShadowOffset, CGSizeZero)) titleShadowOffset = self.highlightedTitleShadowOffset;
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
    if (self.selectedBorderShadowColor) borderShadowColor = self.selectedBorderShadowColor;
    if (self.selectedBorderShadowBlur) borderShadowBlur = self.selectedBorderShadowBlur;
    if (self.selectedIconImage) icon = self.selectedIconImage;
    if (self.selectedTitleShadowColor) titleShadowColor = self.selectedTitleShadowColor;
    else if (_highlightedTitleShadowColor) titleShadowColor = self.highlightedTitleShadowColor;
    if (!CGSizeEqualToSize(_selectedTitleShadowOffset, CGSizeZero)) titleShadowOffset = self.selectedTitleShadowOffset;
    else if (!CGSizeEqualToSize(_highlightedTitleShadowOffset, CGSizeZero)) titleShadowOffset = self.highlightedTitleShadowOffset;
  }
  
  // Set a sensible default
  if (borderShadowColor && borderShadowBlur == 0) borderShadowBlur = 3;
  
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
    if (borderShadowColor) {
      CGContextSaveGState(context);
      // Need to clip without border width adjustment
      if (clip) {
        GHCGContextAddStyledRect(context, bounds, self.borderStyle, 0, cornerRadius);
        CGContextClip(context);
      }
      
      GHCGContextDrawBorderWithShadow(context, bounds, self.borderStyle, fillColor.CGColor, borderColor.CGColor, borderWidth, cornerRadius, borderShadowColor.CGColor, borderShadowBlur, NO);
      CGContextRestoreGState(context);
    } else {
      GHCGContextDrawBorder(context, bounds, self.borderStyle, fillColor.CGColor, borderColor.CGColor, borderWidth, cornerRadius);
    }
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
  CGSize titleSize = _titleSize;
  
  // Check if we need to use abbreviated title
  if (self.abbreviatedTitle) {
    CGSize titleSizeAbbreviated = [self.title sizeWithFont:self.titleFont];
    if (titleSizeAbbreviated.width > _titleSize.width) {
      title = self.abbreviatedTitle;
      titleSize = _abbreviatedTitleSize;
    }
  }
  
  CGFloat y = bounds.origin.y + roundf(GHCGPointToCenter(titleSize, size).y) + self.insets.top;
  
  BOOL showIcon = (icon != nil && !self.iconImageView.hidden);
  CGSize iconSize = self.iconImageSize;
  if (icon && GHCGSizeIsZero(iconSize)) {
    iconSize = icon.size;
  }
  
  UIEdgeInsets titleInsets = [self _titleInsets];
  if (!self.titleHidden) {
    CGFloat lineWidth = titleSize.width + titleInsets.left + titleInsets.right;
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
      if (self.iconShadowColor) CGContextSetShadowWithColor(context, CGSizeZero, 5.0, self.iconShadowColor.CGColor);
      switch (self.iconPosition) {
        case GHUIButtonIconPositionLeft: {
          CGPoint iconTop = GHCGPointToCenter(iconSize, size);
          iconTop.x = x;
          iconTop.y += bounds.origin.y + self.insets.top;
          //[self.iconImageView drawInRect:CGRectMake(iconTop.x, iconTop.y, iconSize.width, iconSize.height)];
          x += iconSize.width;
          break;
        }
        case GHUIButtonIconPositionTop: {
          CGPoint iconTop = GHCGPointToCenter(iconSize, size);
          //[self.iconImageView drawInRect:CGRectMake(iconTop.x, self.insets.top, iconSize.width, iconSize.height)];
          y = self.insets.top + iconSize.height + titleInsets.top;
          break;
        }
        case GHUIButtonIconPositionCenter: {
          CGPoint iconTop = GHCGPointToCenter(iconSize, CGSizeMake(size.width, size.height - titleSize.height));
          if (self.iconOrigin.x != CGFLOAT_MAX) iconTop.x = self.iconOrigin.x;
          if (self.iconOrigin.y != CGFLOAT_MAX) iconTop.y = self.iconOrigin.y;
          //[self.iconImageView drawInRect:CGRectMake(iconTop.x, iconTop.y + self.insets.top, iconSize.width, iconSize.height)];
          y = iconTop.y + self.insets.top + iconSize.height + titleInsets.top;
          break;
        }
      }
      CGContextSetShadowWithColor(context, CGSizeZero, 0.0, NULL);
      showIcon = NO;
    } else if (!GHCGSizeIsZero(iconSize)) {
      if (self.iconPosition == GHUIButtonIconPositionLeft) {
        x += iconSize.width;
      }
    }
    
    [textColor setFill];
    CGContextSetShadowWithColor(context, titleShadowOffset, 0.0, titleShadowColor.CGColor);
    
    x += titleInsets.left;
    if (y < self.insets.top) y = self.insets.top + titleInsets.top;
    
    // Draw title. If we have a secondary title, we'll need to adjust for alignment.
    if (!self.secondaryTitle) {
      [title drawInRect:CGRectMake(x, y, titleSize.width, titleSize.height) withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.titleAlignment];
    } else if (self.secondaryTitle) {
      if (self.maxLineCount > 0) {
        // NOTE(nakoury): ideally this check would not be done here. instead self.titleSize should be broken up into self.titleSize and self.secondaryTitleSize because currently self.titleSize is doing a dual purpose. In some cases it is considered the size of self.title + self.secondaryTitle, but in this case it is considered just the size of self.title. See self.sizeForTitle:constrainedToSize for the logic behind self.titleSize.
        CGSize lineSize = [@" " sizeWithFont:self.titleFont];
        titleSize.height = lineSize.height * self.maxLineCount;
      }
      
      CGSize titleSizeAdjusted = [title sizeWithFont:self.titleFont constrainedToSize:titleSize lineBreakMode:NSLineBreakByTruncatingTail];
      titleSizeAdjusted = [title drawInRect:CGRectMake(x, y, titleSizeAdjusted.width, titleSizeAdjusted.height) withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.titleAlignment];
      if (self.secondaryTitleColor) [self.secondaryTitleColor set];
      if (self.secondaryTitleFont) font = self.secondaryTitleFont;
      if (self.secondaryTitlePosition == GHUIButtonSecondaryTitlePositionDefault) {
        x += titleSizeAdjusted.width;
        CGFloat secondaryTitleWidth = size.width - x - self.insets.right - titleInsets.right;
        CGSize secondaryTitleSize = [self.secondaryTitle sizeWithFont:font forWidth:secondaryTitleWidth lineBreakMode:NSLineBreakByTruncatingTail];
        [self.secondaryTitle drawInRect:CGRectMake(x, y, secondaryTitleSize.width, secondaryTitleSize.height) withFont:font lineBreakMode:NSLineBreakByTruncatingTail];
      } else if (self.secondaryTitlePosition == GHUIButtonSecondaryTitlePositionRightAlign) {
        x += titleSizeAdjusted.width;
        [self.secondaryTitle drawInRect:CGRectMake(x, y, size.width - x - self.insets.right - self.titleInsets.right, size.height) withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
      } else if (self.secondaryTitlePosition == GHUIButtonSecondaryTitlePositionBottom) {
        x = self.insets.left + titleInsets.left + iconSize.width;
        y += titleSizeAdjusted.height + titleInsets.bottom;
        // TODO(gabe): Needed to put "+ self.insets.bottom" so secondary text would wrap
        CGRect secondaryTitleRect = CGRectMake(x, y, size.width - x - self.insets.right - titleInsets.right, size.height - y + self.insets.bottom);
        [self.secondaryTitle drawInRect:secondaryTitleRect withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
      } else if (self.secondaryTitlePosition == GHUIButtonSecondaryTitlePositionBottomLeftSingle) {
        x = self.insets.left + titleInsets.left + iconSize.width;
        y += titleSizeAdjusted.height;
        CGRect secondaryTitleRect = CGRectMake(x, y, size.width - x - self.insets.right - titleInsets.right, 0);
        [self.secondaryTitle drawAtPoint:secondaryTitleRect.origin forWidth:secondaryTitleRect.size.width withFont:font lineBreakMode:NSLineBreakByTruncatingTail];
      }
    }
  }
  
  if (accessoryImage) {
    [accessoryImage drawAtPoint:GHCGPointToRight(accessoryImage.size, CGSizeMake(size.width - 10, bounds.size.height))];
  }
  
  if (showIcon) {
    if (self.iconShadowColor) CGContextSetShadowWithColor(context, CGSizeZero, 3.0, self.iconShadowColor.CGColor);
    //[self.iconImageView drawInRect:GHCGRectToCenterInRect(iconSize, bounds)];
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
}

- (void)drawRect:(CGRect)rect {
  [self drawInRect:self.bounds];
}

@end


