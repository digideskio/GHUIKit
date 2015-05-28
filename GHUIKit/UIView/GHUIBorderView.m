//
//  GHUIBorderView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 5/23/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIBorderView.h"

@interface GHUIBorderView ()
@end

@implementation GHUIBorderView

- (void)sharedInit {
  [super sharedInit];  
  self.borderWidth = 1.0;
  self.borderColor = [UIColor grayColor];
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  GHCGContextDrawBorder(context, UIEdgeInsetsInsetRect(self.bounds, self.insets), self.borderStyle, NULL, self.borderColor.CGColor, self.borderWidth, self.borderRadius);
}

@end
