//
//  GHUIBorderView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 5/23/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"
#import <GHKit/GHCGUtils.h>

@interface GHUIBorderView : GHUIView

@property GHUIBorderStyle borderStyle;
@property UIColor *borderColor;
@property UIEdgeInsets insets;
@property CGFloat borderWidth;
@property CGFloat borderRadius;

@end

