//
//  GHUIActivityLabel.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/31/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIActivityLabel.h"
#import "GHCGUtils.h"
#import "GHUIUtils.h"
#import <GHKit/GHNSString+Utils.h>

@implementation GHUIActivityLabel

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.layout = [GHLayout layoutForView:self];
    self.backgroundColor = [UIColor whiteColor];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.text = NSLocalizedString(@"Loading...", nil);
    _textLabel.font = [UIFont systemFontOfSize:16.0];
    _textLabel.textColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.contentMode = UIViewContentModeCenter;
    _textLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_textLabel];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidesWhenStopped = YES;
    [self addSubview:_activityIndicator];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.hidden = YES;
    [self addSubview:_imageView];
  }
  return self;
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  CGSize lineSize = CGSizeZero;
  CGSize textLabelSize = CGSizeZero;
  if (![NSString gh_isBlank:_textLabel.text]) {
    textLabelSize = [GHUIUtils sizeWithText:_textLabel.text font:_textLabel.font width:size.width multiline:YES truncate:YES];
    lineSize.width += textLabelSize.width;
    lineSize.height += textLabelSize.height;
  }
  
  CGSize detailLabelSize = CGSizeZero;
  if (![NSString gh_isBlank:_detailLabel.text]) {
    detailLabelSize = [GHUIUtils sizeWithText:_detailLabel.text font:_detailLabel.font width:size.width multiline:YES truncate:YES];
    lineSize.height += detailLabelSize.height + 2;
  }
  
  if (_activityIndicator.isAnimating) {
    lineSize.width += _activityIndicator.frame.size.width + 4;
    lineSize.height = MAX(lineSize.height, _activityIndicator.frame.size.height);
  }
  
  if (!_imageView.hidden) {
    lineSize.width += _imageView.image.size.width + 4;
    lineSize.height = MAX(lineSize.height, _imageView.image.size.height);
  }
  
  if (lineSize.height == 0) return CGSizeMake(size.width, self.frame.size.height);
  
  CGFloat x = GHCGFloatToCenter(lineSize.width, size.width, 0);
  CGFloat centerY = GHCGFloatToCenter(lineSize.height, size.height, 0);
  CGFloat height = lineSize.height;
  
  if (_activityIndicator.isAnimating) {
    [layout setOrigin:CGPointMake(x, centerY) view:_activityIndicator];
    x += _activityIndicator.frame.size.width + 4;
  }
  
  if (!_imageView.hidden) {
    [layout setOrigin:CGPointMake(x, centerY) view:_imageView];
    x += _imageView.image.size.width + 4;
  }
  
  if (![NSString gh_isBlank:_textLabel.text]) {
    [layout setFrame:CGRectMake(x, centerY, textLabelSize.width, textLabelSize.height) view:_textLabel];
    centerY += textLabelSize.height + 2;
  }
  
  x = GHCGFloatToCenter(detailLabelSize.width, size.width, 0);
  [layout setFrame:CGRectMake(x, centerY, detailLabelSize.width, detailLabelSize.height) view:_detailLabel];
  height += detailLabelSize.height;
  
  return CGSizeMake(size.width, height);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [super setBackgroundColor:backgroundColor];
  _textLabel.backgroundColor = backgroundColor;
  _detailLabel.backgroundColor = backgroundColor;
}

- (void)startAnimating {
  if (_hidesWhenStopped) self.hidden = NO;
  _imageView.hidden = YES;
  [_activityIndicator startAnimating];
  [self setNeedsLayout];
}

- (void)stopAnimating {
  if (_hidesWhenStopped) self.hidden = YES;
  [_activityIndicator stopAnimating];
  if (_imageView.image)
    _imageView.hidden = NO;
  [self setNeedsLayout];
}

- (void)setText:(NSString *)text {
  self.textLabel.text = text;
  [self setNeedsLayout];
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
  _hidesWhenStopped = hidesWhenStopped;
  if (_hidesWhenStopped && !_activityIndicator.isAnimating) self.hidden = YES;
}

- (void)setAnimating:(BOOL)animating {
  if (animating) [self startAnimating];
  else [self stopAnimating];
}

- (BOOL)isAnimating {
  return [_activityIndicator isAnimating];
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
  _activityIndicator.activityIndicatorViewStyle = activityIndicatorViewStyle;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
  return _activityIndicator.activityIndicatorViewStyle;
}

- (void)setImage:(UIImage *)image {
  if (image) {
    _activityIndicator.hidden = YES;
    _imageView.hidden = NO;
    _imageView.image = image;
  } else {
    _activityIndicator.hidden = NO;
    _imageView.hidden = YES;
  }
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setDetailText:(NSString *)detailText {
  self.detailLabel.text = detailText;
  [self setNeedsLayout];
}

- (UILabel *)detailLabel {
  if (!_detailLabel) {
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.backgroundColor = self.backgroundColor;
    _detailLabel.font = [UIFont systemFontOfSize:14.0];
    _detailLabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.contentMode = UIViewContentModeCenter;
    [self addSubview:_detailLabel];
  }
  return _detailLabel;
}

@end
