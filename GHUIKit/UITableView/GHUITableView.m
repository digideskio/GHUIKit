//
//  GHUITableView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITableView.h"

@implementation GHUITableView

- (void)setObjects:(NSArray *)objects {
  [self beginUpdates];
  NSMutableArray *indexPathsToRemove = [NSMutableArray array];
  NSMutableArray *indexPathsToAdd = [NSMutableArray array];
  [self.dataSource setObjects:objects section:0 indexPathsToRemove:&indexPathsToRemove indexPathsToAdd:&indexPathsToAdd];
  [self deleteRowsAtIndexPaths:indexPathsToRemove withRowAnimation:UITableViewRowAnimationAutomatic];
  [self insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:UITableViewRowAnimationAutomatic];
  [self endUpdates];
}

@end
