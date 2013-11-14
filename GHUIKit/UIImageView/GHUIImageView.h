//
//  GHUIImageView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

@interface GHUIImageView : GHUIView

@property CGFloat cornerRadius;
@property CGFloat cornerRadiusPercentage;
@property (strong) UIColor *overlayColor;
@property (strong) UIColor *shadowColor;
@property CGFloat shadowBlur;
@property (strong) UIColor *strokeColor;
@property CGFloat strokeWidth;

@property (readonly) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

- (void)setImageWithURL:(NSURL *)URL;

@end

@interface UIImageView (GHUIImageViewStub)

- (void)setImageWithURL:(NSURL *)URL;

@end
