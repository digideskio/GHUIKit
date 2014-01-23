//
//  GHUITableViewDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICellDataSource.h"

@interface GHUITableViewDataSource : GHUICellDataSource <UITableViewDataSource, UITableViewDelegate>

- (void)setCellClass:(Class)cellClass tableView:(UITableView *)tableView section:(NSInteger)section;

@end
