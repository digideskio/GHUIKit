//
//  GHUIImageView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

@interface GHUIImageView : GHUIView {
  UIImageView *_imageView;
}

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGFloat cornerRadiusPercentage;

@property (nonatomic, retain) UIColor *overlayColor;

@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowBlur;

@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;

- (void)setImageWithURL:(NSURL *)URL;

@end

@interface UIImageView (GHUIImageViewStub)

- (void)setImageWithURL:(NSURL *)URL;

@end
