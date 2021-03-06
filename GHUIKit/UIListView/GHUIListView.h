//
//  GHUIListView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/5/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

typedef NS_ENUM (NSInteger, GHUIListViewType) {
  GHUIListViewTypeVerticalFill,
  GHUIListViewTypeVertical,
  GHUIListViewTypeHorizontal
};

@interface GHUIListView : GHUIView {
  NSMutableArray *_views;
}

@property UIEdgeInsets insets;
@property UIEdgeInsets viewInsets;
@property GHUIListViewType viewType;

- (NSArray *)views;

@end
