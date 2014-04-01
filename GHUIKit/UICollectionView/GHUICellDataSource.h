//
//  GHUICellDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

typedef void (^GHUICellSetBlock)(id cell, id object, NSIndexPath *indexPath, id containingView/*UITableView or UICollectionView*/);
typedef void (^GHUICellSelectBlock)(id sender, NSIndexPath *indexPath, id object);
typedef BOOL (^GHUICellShouldSelectBlock)(id sender, NSIndexPath *indexPath, id object);
typedef Class (^GHUICellClassBlock)(id object, NSIndexPath *indexPath);

@interface GHUICellDataSource : NSObject  {
  NSMutableDictionary *_sections;
  NSInteger _sectionCount;
  NSMutableDictionary *_cellClasses;
  NSMutableDictionary *_cellsForSizing;
  NSMutableDictionary *_headerTexts;

  NSMutableDictionary *_sizeCache;
}

@property (readonly) NSInteger sectionCount;
@property UIEdgeInsets sectionInset;

@property (copy) GHUICellSetBlock cellSetBlock;
@property (copy) GHUICellSelectBlock selectBlock;
@property (copy) GHUICellShouldSelectBlock shouldSelectBlock;
@property (copy) GHUICellClassBlock classBlock;
@property (weak) id<UIScrollViewDelegate> scrollViewDelegate;


- (NSMutableArray *)objectsForSection:(NSInteger)section;
- (NSMutableArray *)objectsForSection:(NSInteger)section create:(BOOL)create;

- (NSInteger)countForSection:(NSInteger)section;

- (NSInteger)sectionCount;

// Invalidate cache
- (void)invalidateAll;

- (void)addObjects:(NSArray *)objects;
- (void)addObjects:(NSArray *)objects section:(NSInteger)section;
- (void)addObjects:(NSArray *)objects section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
- (NSIndexPath *)replaceObject:(id)object section:(NSInteger)section;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (id)lastObjectInSection:(NSInteger)section;

- (NSUInteger)indexOfObject:(id)object section:(NSInteger)section;
- (NSIndexPath *)indexPathOfObject:(id)object section:(NSInteger)section;

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeObjects:(NSArray *)objects;
- (void)removeObjects:(NSArray *)objects section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;
- (void)removeAllObjects;
- (void)removeObjectsFromSection:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

- (void)replaceObjects:(NSArray *)replaceObjects withObjects:(NSArray *)objects section:(NSInteger)section indexPathsToAdd:(NSMutableArray **)indexPathsToAdd indexPathsToReload:(NSMutableArray **)indexPathsToReload;

- (void)setObjects:(NSArray *)objects;
- (void)setObjects:(NSArray *)objects section:(NSInteger)section;
- (void)setObjects:(NSArray *)objects section:(NSInteger)section indexPathsToRemove:(NSMutableArray **)indexPathsToRemove indexPathsToAdd:(NSMutableArray **)indexPathsToAdd;


- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath view:(UIView */*UITableView or UICollectionView*/)view;

- (NSString *)headerTextForSection:(NSInteger)section;

@end
