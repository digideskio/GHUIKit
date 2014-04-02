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

- (void)registerClasses:(NSArray */*of Class*/)classes;

- (void)setObjects:(NSArray *)objects animated:(BOOL)animated;
- (void)setObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated;

- (void)addObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated;

- (void)replaceObjects:(NSArray *)replaceObjects withObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated;

@end
