//
//  GHUICollectionViewDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

typedef void (^GHUICollectionViewCellSetBlock)(id cell, id object, NSIndexPath *indexPath);
typedef void (^GHUICollectionViewSelectBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);

@interface GHUICollectionViewDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate> {
  NSMutableDictionary *_sections;
  
  NSMutableDictionary *_cellClasses;
  NSMutableDictionary *_cellsForSizing;
}

@property (nonatomic, copy) GHUICollectionViewCellSetBlock cellSetBlock;
@property (nonatomic, copy) GHUICollectionViewSelectBlock selectBlock;

- (NSMutableArray *)objectsForSection:(NSInteger)section;
- (NSMutableArray *)objectsForSection:(NSInteger)section create:(BOOL)create;

- (NSInteger)countForSection:(NSInteger)section;

- (NSInteger)sectionCount;

- (void)addObjects:(NSArray *)objects;
- (void)addObjects:(NSArray *)objects section:(NSInteger)section;
- (void)addObjects:(NSArray *)objects section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)indexOfObject:(id)object inSection:(NSInteger)section;

- (void)removeAllObjects;

- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView;
- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView section:(NSInteger)section;
- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath;

@end
