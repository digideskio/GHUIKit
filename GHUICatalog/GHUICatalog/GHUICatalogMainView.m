//
//  GHUICatalogMainView.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogMainView.h"
#import "GHUICatalogItem.h"
#import "GHUICatalogButtons.h"
#import "GHUICatalogAnimations.h"
#import "GHUICatalogActivity.h"
#import "GHUICatalogTemp.h"
#import "GHUICatalogTableView.h"
#import <GHUIKit/GHUIPanel.h>

@interface GHUICatalogMainView ()
@property GHUIPanel *panelTop;
@property GHUIPanel *panelLeft;
@end

@implementation GHUICatalogMainView

- (void)sharedInit {
  [super sharedInit];
  self.navigationTitle = @"Catalog";

  NSMutableArray *items = [NSMutableArray array];
  [items addObject:[GHUICatalogItem itemForTitle:@"Buttons" detail:@"Buttons and labels used by GHUIButton and GHUILabel"]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Animations" detail:@"Animations for view controllers"]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Activity" detail:@"Activity and error views"]];
  //[items addObject:[GHUICatalogItem itemForTitle:@"Temp" detail:@"Temp space"]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Table" detail:@"Table view"]];
  [self.dataSource addObjects:items];

  GHUIListView *buttonGroup = [[GHUIListView alloc] init];
  buttonGroup.viewType = GHUIListViewTypeHorizontal;
  buttonGroup.backgroundColor = [UIColor greenColor]; // Should not be visible since it will all size to fit
  [buttonGroup addView:[[GHUIButton alloc] initWithText:@"Button #1" targetBlock:^(id sender) {}]];
  [buttonGroup addView:[[GHUIButton alloc] initWithText:@"Button #2" targetBlock:^(id sender) {}]];
  _panelTop = [[GHUIPanel alloc] initWithContentView:buttonGroup];
  [self addSubview:_panelTop];
  
  GHUIListView *buttonGroupLeft = [[GHUIListView alloc] init];
  buttonGroupLeft.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  buttonGroupLeft.backgroundColor = [UIColor colorWithWhite:0.94 alpha:0.8];
  [buttonGroupLeft addView:[[GHUIButton alloc] initWithText:@"Button #1" targetBlock:^(id sender) {}]];
  [buttonGroupLeft addView:[[GHUIButton alloc] initWithText:@"Button #2" targetBlock:^(id sender) {}]];
  [buttonGroupLeft addView:[[GHUIButton alloc] initWithText:@"Button #3" targetBlock:^(id sender) {}]];
  [buttonGroupLeft sizeToFit];
  _panelLeft = [[GHUIPanel alloc] initWithContentView:buttonGroupLeft];
  _panelLeft.transition = GHUIPanelTransitionLeft;
  [self addSubview:_panelLeft];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _panelTop.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  _panelLeft.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:_panelTop action:@selector(toggleView)];
  self.navigationDelegate.navigationItem.rightBarButtonItem = rightItem;
  
  UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:_panelLeft action:@selector(toggleView)];
  self.navigationDelegate.navigationItem.leftBarButtonItem = leftItem;
}

- (void)selectItem:(GHUICatalogItem *)item {
  if ([item.title isEqualToString:@"Buttons"]) {
    GHUICatalogButtons *view = [[GHUICatalogButtons alloc] init];
    [self.navigationDelegate pushView:view animated:YES];
  } else if ([item.title isEqualToString:@"Animations"]) {
    GHUICatalogAnimations *view = [[GHUICatalogAnimations alloc] init];
    [self.navigationDelegate pushView:view animated:YES];
  } else if ([item.title isEqualToString:@"Activity"]) {
    GHUICatalogActivity *view = [[GHUICatalogActivity alloc] init];
    [self.navigationDelegate pushView:view animated:YES];
  } else if ([item.title isEqualToString:@"Temp"]) {
    GHUICatalogTemp *view = [[GHUICatalogTemp alloc] init];
    [self.navigationDelegate pushView:view animated:YES];
  } else if ([item.title isEqualToString:@"Table"]) {
    GHUICatalogTableView *view = [[GHUICatalogTableView alloc] init];
    [self.navigationDelegate pushView:view animated:YES];
  }
}

- (void)_addItem {
  GHUICatalogItem *item = [GHUICatalogItem itemForTitle:@"Item" detail:@"We just added this item."];
  [self.dataSource addObjects:@[item]];
  [self.tableView reloadData];
}

@end
