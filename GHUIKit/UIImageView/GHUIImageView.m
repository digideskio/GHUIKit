//
//  GHUIImageView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIImageView.h"

#import "GHCGUtils.h"

@implementation GHUIImageView

- (void)sharedInit {
  self.backgroundColor = [UIColor clearColor];
  _imageView = [[UIImageView alloc] init];
  [_imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
  [_imageView removeObserver:self forKeyPath:@"image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image {
  _imageView.image = image;
}

- (void)setImageWithURL:(NSURL *)URL {
  [_imageView setImageWithURL:URL];
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGFloat cornerRadius = _cornerRadius;
  if (_cornerRadiusPercentage > 0) {
    cornerRadius = roundf(rect.size.height * _cornerRadiusPercentage * 0.01);
  }
  
  if (_fillColor) {
    GHCGContextDrawRoundedRect(context, rect, _fillColor.CGColor, NULL, _strokeWidth, cornerRadius);
  }

  GHCGContextDrawRoundedRectImageWithShadowAndTransform(context, _imageView.image.CGImage, _imageView.image.size, self.bounds, _strokeColor.CGColor, _strokeWidth, cornerRadius, self.contentMode, self.backgroundColor.CGColor, _shadowColor.CGColor, _shadowBlur, self.transform);
  
  if (_overlayColor) {
    GHCGContextDrawRoundedRect(context, rect, _overlayColor.CGColor, NULL, _strokeWidth, cornerRadius);
  }
}

@end
