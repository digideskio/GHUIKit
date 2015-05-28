//
//  GHUICatalogStaticTableView.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 4/8/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogStaticTableView.h"

#import <GHUITable/GHUITable.h>
#import <GHUIKit/GHUITableViewTitleCell.h>

#import "GHUICatalogSwitchCell.h"

@interface GHUICatalogStaticTableView ()
@property GHUITableView *tableView;
@end

@implementation GHUICatalogStaticTableView

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  _tableView = [[GHUITableView alloc] init];
  [self addSubview:_tableView];

  GHUITableViewTitleCell *cell1 = [[GHUITableViewTitleCell alloc] init];
  [cell1 setName:@"Name1" description:@"This is a description #1" imageName:@"Preview2"];
  
  GHUITableViewTitleView *view2 = [[GHUITableViewTitleView alloc] init];
  [view2 setName:@"Name2" description:@"This is a description #2" imageName:@"Preview2-Filled"];
  [_tableView.dataSource addObjects:@[cell1, view2] section:0];
  
  GHUICatalogSwitchCell *cell3 = [[GHUICatalogSwitchCell alloc] init];
  [cell3 setTitle:@"Title" description:@"Description" on:YES];
  [_tableView.dataSource addObjects:@[cell3] section:1];
  
  _tableView.dataSource.selectBlock = ^(UITableView *tableView, NSIndexPath *indexPath, NSString *object) {
    NSLog(@"Selected: %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  };
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  [layout setFrame:CGRectMake(0, 0, size.width, size.height) view:_tableView];
  return size;
}

@end
