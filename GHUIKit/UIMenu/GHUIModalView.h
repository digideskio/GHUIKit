//
//  GHUIModalView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 2/14/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

@interface GHUIModalView : GHUIView

- (id)initWithTitle:(NSString *)title navigationDelegate:(id<GHUIViewNavigationDelegate>)navigationDelegate contentView:(UIView *)contentView;

@end
