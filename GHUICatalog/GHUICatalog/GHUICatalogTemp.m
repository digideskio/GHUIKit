//
//  GHUICatalogTemp.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 2/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogTemp.h"

@implementation GHUICatalogTemp

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  self.navigationTitle = @"Buttons";
  
  _listView = [[GHUIListView alloc] init];
  _listView.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  _listView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
  
  GHUIButton *primaryButton = [[GHUIButton alloc] init];
  primaryButton.backgroundColor = [UIColor clearColor];
  primaryButton.text = @"text";
  primaryButton.textColor = GHUIColorFromRGB(0x333333);
  primaryButton.font = [UIFont boldSystemFontOfSize:15];
  primaryButton.fillColor = [UIColor whiteColor];
  primaryButton.borderColor = GHUIColorFromRGB(0xcccccc);
  primaryButton.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  primaryButton.text = @"Primary";
  primaryButton.textColor = [UIColor whiteColor];
  primaryButton.fillColor = GHUIColorFromRGB(0x428bca);
  primaryButton.borderColor = GHUIColorFromRGB(0x357ebd);
  primaryButton.highlightedFillColor = [UIColor colorWithRed:0.0f/255.0f green:60.0f/255.0f blue:180.0f/255.0f alpha:1.0];
  [_listView addView:primaryButton];

  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.backgroundColor = [UIColor whiteColor];
  [self addSubview:_scrollView];
  [_scrollView addSubview:_listView];
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  [layout setFrame:CGRectMake(0, 0, size.width, size.height) view:_scrollView];
  [layout setFrame:CGRectMake(0, 0, size.width, 0) view:_listView sizeToFit:YES];
  return size;
}

@end
