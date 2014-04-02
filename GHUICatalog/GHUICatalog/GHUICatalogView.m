//
//  GHUICatalogView.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogView.h"

#import "GHUICatalogItem.h"
#import <GHUIKit/GHUILabel.h>


@interface GHUICatalogView ()
@property GHUITableView *tableView;
@property GHUITableViewDataSource *dataSource;
@end

@implementation GHUICatalogView

- (void)sharedInit {
  [super sharedInit];
  
  GHWeakSelf blockSelf = self;
  _tableView = [[GHUITableView alloc] init];
  [self addSubview:_tableView];
  
  _dataSource = [[GHUITableViewDataSource alloc] init];
  [_dataSource setCellClass:[GHUITableViewDetailCell class] tableView:_tableView section:0];
  _dataSource.cellSetBlock = ^(GHUITableViewDetailCell *cell, GHUICatalogItem *item, NSIndexPath *indexPath, UITableView *tableView) {
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.detail;
  };
  _dataSource.selectBlock = ^(UITableView *tableView, NSIndexPath *indexPath, GHUICatalogItem *item) {
    [blockSelf selectItem:item];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  };
  _dataSource.deleteBlock = ^(UITableView *tableView, NSIndexPath *indexPath, GHUICatalogItem *item) {
    [blockSelf removeItem:item];
  };
  
  _tableView.dataSource = _dataSource;
  _tableView.delegate = _dataSource;  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)selectItem:(GHUICatalogItem *)item {
  NSAssert(NO, @"Abstract");
}

- (void)removeItem:(GHUICatalogItem *)item {
  GHDebug(@"Removed item: %@", item);
}

- (GHUIContentView *)testView:(NSString *)description {
  GHUILabel *label = [[GHUILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  label.backgroundColor = [UIColor whiteColor];
  label.text = description;
  label.textAlignment = NSTextAlignmentCenter;
  label.userInteractionEnabled = YES;
  GHUIContentView *contentView = [GHUIContentView contentViewForView:label];
  contentView.navigationTitle = @"Navigation Title";
  return contentView;
}


@end
