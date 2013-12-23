//
//  GHUITextField.m
//  GHUIKit
//
//  Created by Gabriel Handford on 12/19/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUITextField.h"

@implementation GHUITextField

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  CGContextRef context = UIGraphicsGetCurrentContext();
  GHCGContextDrawBorder(context, self.bounds, self.customBorderStyle, NULL, self.borderColor.CGColor, 1.0, 0.0);
}

@end
