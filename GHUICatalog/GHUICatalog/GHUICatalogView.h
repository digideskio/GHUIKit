//
//  GHUICatalogView.h
//  GHUICatalog
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GHUIKit/GHUIContentView.h>
#import <GHUITable/GHUITable.h>

@interface GHUICatalogView : GHUIContentView
@property (readonly) GHUITableView *tableView;
@property (readonly) GHUITableViewDataSource *dataSource;

- (GHUIContentView *)testView:(NSString *)description;

@end
