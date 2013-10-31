//
//  GHUICollectionView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/23/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionView.h"

@implementation GHUICollectionView

- (void)sharedInit {
  self.alwaysBounceVertical = YES;
}

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    [self sharedInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]])) {
    [self sharedInit];
  }
  return self;
}

- (void)setHeaderRefreshing:(BOOL)refreshing {
  if (refreshing && !_refreshControl.refreshing) {
    [_refreshControl beginRefreshing];
  } else if (!refreshing && _refreshControl.refreshing) {
    [_refreshControl endRefreshing];
  }
}

- (void)setRefreshHeaderEnabled:(BOOL)enabled {
  if (enabled && !_refreshControl) {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_refreshControl];
  } else if (!enabled) {
    [_refreshControl removeFromSuperview];
    _refreshControl = nil;
  }
  [self setNeedsLayout];
}

- (BOOL)isRefreshHeaderEnabled {
  return !!_refreshControl;
}

- (void)refresh {
  if (self.refreshBlock) self.refreshBlock(self);
}

@end
