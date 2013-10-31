//
//  GHUISwitchButton.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"
#import "GHUIButton.h"

@interface GHUISwitchButton : GHUIView

@property (readonly, nonatomic) GHUIButton *button;
@property (readonly, nonatomic) UISwitch *switchControl;

@end
