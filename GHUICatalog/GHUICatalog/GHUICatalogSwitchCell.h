//
//  GHUICatalogSwitchCell.h
//  GHUICatalog
//
//  Created by Gabriel Handford on 3/31/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"
#import "GHUITableViewCell.h"

#import "GHUIImageView.h"
#import "GHUILabel.h"

@interface GHUICatalogSwitchView : GHUIView

@property GHUILabel *label;
@property UISwitch *switchView;

- (void)setTitle:(NSString *)title description:(NSString *)description on:(BOOL)on;

@end

@interface GHUICatalogSwitchCell : GHUITableViewCell
- (void)setTitle:(NSString *)title description:(NSString *)description on:(BOOL)on;
@end
