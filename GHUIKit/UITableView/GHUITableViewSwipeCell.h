//
//  GHUITableViewSwipeCell.h
//  GHUIKit
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

//
// Modified version of SWTableViewCell
//

#import "GHUITableViewCell.h"

typedef NS_ENUM (NSUInteger, GHUITableViewSwipeState) {
  GHUITableViewSwipeStateDefault,
  GHUITableViewSwipeStateRight,
  GHUITableViewSwipeStateLeft
};

@class GHUICellScrollView;
@class GHUITableViewSwipeCell;

@protocol GHUITableViewSwipeCellDelegate <NSObject>
@optional
//- (void)tableViewSwipeCell:(GHUITableViewSwipeCell *)cell scrollingToState:(GHUITableViewSwipeState)state;
@end


@interface GHUITableViewSwipeCell : GHUITableViewCell <UIScrollViewDelegate> {
  dispatch_once_t onceToken;
}

@property (nonatomic) NSArray *rightButtons;
@property (nonatomic, readonly) GHUITableViewSwipeState swipeState;

@property (weak) id<GHUITableViewSwipeCellDelegate> delegate;

+ (UIButton *)buttonWithColor:(UIColor *)color title:(NSString *)title target:(id)target action:(SEL)action;

- (void)setAppearanceWithBlock:(void (^)())appearanceBlock tableView:(UITableView *)tableView force:(BOOL)force;

@end


@interface GHUICellScrollView : UIScrollView <UIGestureRecognizerDelegate>
@end