//
//  GHUILongPressGestureRecognizer.m
//  GHUIKit
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUILongPressGestureRecognizer.h"

@implementation GHUILongPressGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  self.state = UIGestureRecognizerStateFailed;
}

@end
