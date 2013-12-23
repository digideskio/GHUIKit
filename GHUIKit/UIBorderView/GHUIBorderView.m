//
//  GHUIBorderView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 12/9/13.
//  Copyright (c) 2013 GHUIKit. All rights reserved.
//

#import "GHUIBorderView.h"
#import <GHKit/GHCGUtils.h>

@implementation GHUIBorderView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.userInteractionEnabled = NO;
    self.contentMode = UIViewContentModeRedraw;
  }
  return self;
}

- (void)addBorder:(CGRect)border {
  if (!self.borders) self.borders = [NSMutableArray array];
  [self.borders addObject:[NSValue valueWithCGRect:border]];
  [self setNeedsDisplay];
}

- (void)clearBorders {
  [self.borders removeAllObjects];
  [self setNeedsDisplay];
}

- (void)drawBorders:(CGContextRef)context {
  for (NSValue *value in self.borders) {
    CGRect border = [value CGRectValue];
    CGFloat y = border.origin.y;
    CGFloat x2 = border.origin.x + border.size.width;
    GHCGContextDrawLine(context, border.origin.x, y, x2, y, self.color.CGColor, border.size.height);
  }
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  [self drawBorders:context];
}

@end
