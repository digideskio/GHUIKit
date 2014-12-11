//
//  GHUICatalogOtherView.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 5/23/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogOtherView.h"

#import <GHUIKit/GHUIBorderView.h>

@implementation GHUICatalogOtherView

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  self.navigationTitle = @"Other";
  
  _listView = [[GHUIListView alloc] init];
  _listView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
  _listView.viewType = GHUIListViewTypeVertical;
  _listView.viewInsets = UIEdgeInsetsMake(0, 0, 10, 0);
  
  GHUIBorderView *borderView1 = [[GHUIBorderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  label1.backgroundColor = [UIColor darkGrayColor];
  label1.textColor = [UIColor whiteColor];
  label1.text = @"Bottom Border";
  [borderView1 addSubview:label1];
  borderView1.borderStyle = GHUIBorderStyleBottomOnly;
  borderView1.borderColor = [UIColor redColor];
  [_listView addSubview:borderView1];
  
  GHUIBorderView *borderView2 = [[GHUIBorderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  label2.backgroundColor = [UIColor darkGrayColor];
  label2.textColor = [UIColor whiteColor];
  label2.text = @"Normal Border";
  [borderView2 addSubview:label2];
  borderView2.borderStyle = GHUIBorderStyleNormal;
  borderView2.borderColor = [UIColor redColor];
  [_listView addSubview:borderView2];
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.backgroundColor = [UIColor whiteColor];
  [self addSubview:_scrollView];
  [_scrollView addSubview:_listView];
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  [layout setFrame:CGRectMake(0, 64, size.width, size.height) view:_scrollView];
  [layout setFrame:CGRectMake(0, 0, size.width, 0) view:_listView sizeToFit:YES];
  return size;
}
  
@end
