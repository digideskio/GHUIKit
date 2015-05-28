//
//  GHUICatalogTableView.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogTableView.h"

#import <GHUITable/GHUITable.h>
#import <GHUIKit/GHUITableViewTitleCell.h>

#import "GHUICatalogCell.h"
#import "GHUICatalogSwitchCell.h"

@interface GHUICatalogTableView ()
@property GHUITableView *tableView;
@property BOOL pauseUpdate;
//@property NSMutableSet *indexPathsSwiping;
@end

@implementation GHUICatalogTableView

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  
  //_indexPathsSwiping = [NSMutableSet set];
  
  _tableView = [[GHUITableView alloc] init];
  [self addSubview:_tableView];
    //
  // For dynamic cell setups based on the objects themselves, you can use:
  // (GHUICellClassBlock)classBlock to pick a cell class per row (see example below).
  //
  // For simpler cell setups you can register cell classes by section or for all cells.
  //
  [_tableView registerClasses:@[[GHUICatalogSwitchCell class], [GHUITableViewTitleCell class], [GHUICatalogCell class]]];
  _tableView.dataSource.classBlock = ^Class(id object, NSIndexPath *indexPath) {
    if (object[@"on"]) return [GHUICatalogSwitchCell class];
    if (indexPath.section == 1) return [GHUITableViewTitleCell class];
    return [GHUICatalogCell class];
  };
  
  _tableView.dataSource.cellSetBlock = ^(id cell, NSDictionary *dict, NSIndexPath *indexPath, UITableView *tableView, BOOL dequeued) {
    // If we are a swipe cell set that up
//    if ([cell respondsToSelector:@selector(setAppearanceWithBlock:tableView:force:)]) {
//      __weak GHUICatalogCell *weakCell = cell;
//      [cell setAppearanceWithBlock:^{
//        NSMutableArray *rightButtons = [NSMutableArray array];
//        [rightButtons addObject:[weakCell rightButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0] title:@"More" index:1]];
//        [rightButtons addObject:[weakCell rightButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete" index:2]];
//        [weakCell setRightButtons:rightButtons];
//      } tableView:tableView force:NO];
//      
//      weakCell.delegate = blockSelf;
//    }
    
    if ([cell isKindOfClass:[GHUICatalogSwitchCell class]]) {
      [cell setTitle:dict[@"title"] description:dict[@"description"] on:[dict[@"on"] boolValue]];
    } else if ([cell isKindOfClass:[GHUITableViewTitleCell class]]) {
      [cell setName:dict[@"name"] description:dict[@"description"] imageName:dict[@"imageName"]];
    } else {
      [cell setName:dict[@"name"] description:dict[@"description"] image:[UIImage imageNamed:dict[@"imageName"]]];
    }
  };
  _tableView.dataSource.selectBlock = ^(UITableView *tableView, NSIndexPath *indexPath, NSString *object) {
    NSLog(@"Selected: %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  };
  
  [_tableView.dataSource setHeaderText:@"Section 1" section:0];
  [_tableView.dataSource setHeaderText:@"Section 2 (Multi-line)" section:1];
  [_tableView.dataSource setHeaderText:@"Section 3 (Switch)" section:2];
  
  [_tableView setObjects:
   @[
     @{@"name": @"Name1", @"description": @"This is a description #1", @"imageName": @"Preview2"},
     @{@"name": @"Name2", @"description": @"This is a description #2", @"imageName": @"Preview2-Filled"}] animated:NO];

  [_tableView setObjects:
   @[
     @{@"name": @"Gastropub swag pork belly, butcher selvage mustache chambray scenester pour-over.",
       @"description": @"Cosby sweater stumptown Carles letterpress, roof party deep v gastropub next level. Tattooed bitters distillery, scenester PBR&B pork belly swag twee DIY. Mixtape plaid Carles photo booth sustainable you probably haven't heard of them. Vice normcore fap Thundercats Williamsburg Truffaut paleo small batch, plaid PBR&B Brooklyn jean shorts. Next level lomo direct trade farm-to-table, cred hoodie post-ironic fingerstache pop-up put a bird on it. Keytar PBR literally, DIY Bushwick Pinterest bicycle rights.",
       @"imageName": @"Preview2"},
     @{@"name": @"YOLO irony beard",
       @"description": @"Raw denim Tumblr roof party beard gentrify pickled, art party ethical",
       @"imageName": @"http://placehold.it/350x150"}
     ] section:1 animated:NO];
  
  [_tableView setObjects:
   @[
     @{@"title": @"Normcore pug ennui,",
       @"description": @"Vice Brooklyn salvia bicycle rights Odd Future stumptown lo-fi occupy try-hard.",
       @"on": @(YES)},
     @{@"title": @"3 wolf moon flexitarian fashion axe",
       @"description": @"Actually trust fund hashtag, distillery put a bird on it",
       @"on": @(NO)}
     ] section:2 animated:NO];
  
  
  // Timer to change data so we can test queued reloads when in swipe mode
  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(_updateCells) userInfo:nil repeats:YES];
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  [layout setFrame:CGRectMake(0, 0, size.width, size.height) view:_tableView];
  return size;
}

// Called to update cells on a time to test what happens on cell updates when in swipable mode
- (void)_updateCells {
  static NSInteger gCount = 2;
  NSDictionary *obj = @{@"name": @"Name1", @"description": [NSString stringWithFormat:@"This is a description #%d", (int)gCount++], @"imageName": @"Preview2"};
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [_tableView.dataSource replaceObjectAtIndexPath:indexPath withObject:obj];
  [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
//
//- (void)tableViewSwipeCell:(GHUITableViewSwipeCell *)cell scrollingToState:(GHUITableViewSwipeState)state {
//  BOOL pauseUpdate = (state != GHUITableViewSwipeStateDefault);
//  NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
//  if (!indexPath) return;
//  if (pauseUpdate) {
//    [_tableView queueReloadForIndexPath:indexPath];
//  }
//}
//
//- (void)tableViewSwipeCell:(GHUITableViewSwipeCell *)cell didScrollToState:(GHUITableViewSwipeState)state {
//  BOOL pauseUpdate = (state != GHUITableViewSwipeStateDefault);
//  if (!pauseUpdate) {
//    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
//    [_tableView flushReloadForIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
//  }
//}
//
//- (void)tableViewSwipeCell:(GHUITableViewSwipeCell *)cell didTriggerRightButtonWithIndex:(NSInteger)index {
//  if (index == 1) {
//    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//    NSLog(@"More: %@", cellIndexPath);
//  } else if (index == 2) {
//    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//    NSLog(@"Delete: %@", cellIndexPath);
//  }
//}
//
@end
