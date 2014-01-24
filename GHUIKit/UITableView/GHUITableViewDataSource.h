//
//  GHUITableViewDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICellDataSource.h"

typedef void (^GHUICellDeleteBlock)(id sender, NSIndexPath *indexPath, id object);

@interface GHUITableViewDataSource : GHUICellDataSource <UITableViewDataSource, UITableViewDelegate>

@property (copy) GHUICellDeleteBlock deleteBlock;

- (void)setCellClass:(Class)cellClass tableView:(UITableView *)tableView section:(NSInteger)section;

@end
