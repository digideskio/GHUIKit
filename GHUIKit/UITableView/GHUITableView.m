//
//  GHUITableView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITableView.h"

#import "GHUITableViewDataSource.h"

@interface GHUITableView ()
@property GHUITableViewDataSource *defaultDataSource; // Default dataSource/delegate used in init
@end

@implementation GHUITableView

- (void)sharedInit {
  _defaultDataSource = [[GHUITableViewDataSource alloc] init];
  self.dataSource = _defaultDataSource;
  self.delegate = _defaultDataSource;
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self sharedInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    [self sharedInit];
  }
  return self;
}

- (void)setObjects:(NSArray *)objects animated:(BOOL)animated {
  [self setObjects:objects section:0 animated:animated];
}

- (void)setObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated {
  NSMutableArray *indexPathsToRemove = [NSMutableArray array];
  NSMutableArray *indexPathsToAdd = [NSMutableArray array];
  if (animated) [self beginUpdates];
  [self.dataSource setObjects:objects section:section indexPathsToRemove:&indexPathsToRemove indexPathsToAdd:&indexPathsToAdd];
  if (animated) {
    [self deleteRowsAtIndexPaths:indexPathsToRemove withRowAnimation:UITableViewRowAnimationAutomatic];
    [self insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
  } else {
    [self reloadData];
  }
}

- (void)replaceObjects:(NSArray *)replaceObjects withObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated {
  NSMutableArray *indexPathsToAdd = [NSMutableArray array];
  NSMutableArray *indexPathsToReload = [NSMutableArray array];
  if (animated) [self beginUpdates];
  [self.dataSource replaceObjects:replaceObjects withObjects:objects section:section indexPathsToAdd:&indexPathsToAdd indexPathsToReload:&indexPathsToReload];
  if (animated) {
    if ([indexPathsToReload count] > 0) [self reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:(animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone)];
    if ([indexPathsToAdd count] > 0) [self insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:(animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone)];
    [self endUpdates];
  } else {
    [self reloadData];
  }
}

- (void)registerClasses:(NSArray */*of Class*/)classes {
  for (Class clazz in classes) {
    [self registerClass:clazz forCellReuseIdentifier:NSStringFromClass(clazz)];
  }
}

@end
