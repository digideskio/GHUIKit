//
//  GHUITableView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITableViewDataSource.h"

@interface GHUITableView : UITableView

@property (nonatomic, assign) GHUITableViewDataSource *dataSource;

- (void)setObjects:(NSArray *)objects;

@end
