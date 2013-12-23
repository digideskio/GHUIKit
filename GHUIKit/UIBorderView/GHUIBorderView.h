//
//  GHUIBorderView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 12/9/13.
//  Copyright (c) 2013 GHUIKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHUIBorderView : UIView

@property UIColor *color;
@property NSMutableArray *borders;

- (void)addBorder:(CGRect)border;
- (void)clearBorders;

- (void)drawBorders:(CGContextRef)context;

@end
