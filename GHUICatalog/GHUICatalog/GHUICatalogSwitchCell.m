//
//  GHUICatalogSwitchCell.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 3/31/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogSwitchCell.h"

@implementation GHUICatalogSwitchView

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  self.backgroundColor = [UIColor clearColor];
  
  _label = [[GHUILabel alloc] init];
  _label.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  _label.font = [UIFont systemFontOfSize:16];
  _label.secondaryTextFont = [UIFont systemFontOfSize:14];
  [self addSubview:_label];
  
  _switchView = [[UISwitch alloc] init];
  [self addSubview:_switchView];
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  CGFloat y = 0;
  
  CGSize switchSize = [_switchView sizeThatFits:size];
  [layout setFrame:CGRectMake(size.width - switchSize.width - 10, 10, switchSize.width, switchSize.height) view:_switchView];
  
  CGRect labelFrame = [layout setFrame:CGRectMake(0, y, size.width - switchSize.width - 10, 0) view:_label sizeToFit:YES];
  y += labelFrame.size.height;
  
  return CGSizeMake(size.width, y);
}

- (void)setTitle:(NSString *)title description:(NSString *)description on:(BOOL)on {
  _label.text = title;
  _label.secondaryText = description;
  _switchView.on = on;
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

@end


@implementation GHUICatalogSwitchCell

+ (Class)contentViewClass {
  return [GHUICatalogSwitchView class];
}

- (void)setTitle:(NSString *)title description:(NSString *)description on:(BOOL)on {
  [self.viewForContent setTitle:title description:description on:on];
}

@end


