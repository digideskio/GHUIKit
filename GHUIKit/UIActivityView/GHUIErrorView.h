//
//  GHUIErrorView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 2/24/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

@interface GHUIErrorView : GHUIView

- (void)setText:(NSString *)text detailText:(NSString *)detailText;

- (void)presentInView:(UIView *)view keyboardRect:(CGRect)keyboardRect dismissAfter:(NSTimeInterval)dismissAfter;

- (void)dismissView;

@end
