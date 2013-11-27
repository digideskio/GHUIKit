//
//  GHUICollectionView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/23/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

@class GHUICollectionView;

typedef void (^GHUICollectionViewRefreshBlock)(GHUICollectionView *collectionView);

@interface GHUICollectionView : UICollectionView <UICollectionViewDelegate>

@property (readonly, nonatomic) UIRefreshControl *refreshControl;
@property (copy, nonatomic) GHUICollectionViewRefreshBlock refreshBlock;

/*!
 Shared init.
 */
- (void)sharedInit;

/*!
 Set refreshing indicator.
 
 @param refreshing YES if refreshing
 */
- (void)setHeaderRefreshing:(BOOL)refreshing;

/*!
 Enable or disable the header.
 
 @param enabled YES to enable
 */
- (void)setRefreshHeaderEnabled:(BOOL)enabled;

/*!
 Check if refresh header is enabled.
 */
- (BOOL)isRefreshHeaderEnabled;

/*!
 Check if header is refreshing.
 */
- (BOOL)isHeaderRefreshing;

- (void)scrollToBottom:(BOOL)animated;

@end