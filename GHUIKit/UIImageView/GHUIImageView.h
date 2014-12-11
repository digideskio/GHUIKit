//
//  GHUIImageView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

@interface GHUIImageView : GHUIView

@property CGFloat cornerRadius UI_APPEARANCE_SELECTOR;
@property CGFloat cornerRadiusRatio UI_APPEARANCE_SELECTOR;
@property UIColor *overlayColor UI_APPEARANCE_SELECTOR;
@property UIColor *shadowColor UI_APPEARANCE_SELECTOR;
@property CGFloat shadowBlur UI_APPEARANCE_SELECTOR;
@property UIColor *fillColor UI_APPEARANCE_SELECTOR;

@property (readonly) UIImageView *imageView;
@property (nonatomic) UIImage *image;

- (void)setImageWithURL:(NSURL *)URL;

@end

@interface UIImageView (GHUIImageViewStub)

- (void)setImageWithURL:(NSURL *)URL;

@end
