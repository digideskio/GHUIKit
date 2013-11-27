//
//  GHUICollectionViewDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

typedef void (^GHUICollectionViewCellSetBlock)(id cell, id object, NSIndexPath *indexPath);
typedef void (^GHUICollectionViewSelectBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, id object);
typedef BOOL (^GHUICollectionViewShouldSelectBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, id object);

@interface GHUICollectionViewDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate> {
  NSMutableDictionary *_sections;
  
  NSMutableDictionary *_cellClasses;
  NSMutableDictionary *_cellsForSizing;
  
  NSMutableDictionary *_headerTexts;
}

@property (readonly) NSInteger sectionCount;
@property UIEdgeInsets sectionInset;
@property (copy) GHUICollectionViewCellSetBlock cellSetBlock;
@property (copy) GHUICollectionViewSelectBlock selectBlock;
@property (copy) GHUICollectionViewShouldSelectBlock shouldSelectBlock;
@property (weak) id<UIScrollViewDelegate> scrollViewDelegate;

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
- (void)removeAllObjectsFromSection:(NSInteger)section;

- (void)setObjects:(NSArray *)objects section:(NSInteger)section;

- (NSIndexPath *)updateObject:(id)object inSection:(NSInteger)section;

- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView;
- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView section:(NSInteger)section;
- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath;

#pragma mark Headers

- (void)setHeaderText:(NSString *)headerText collectionView:(UICollectionView *)collectionView section:(NSInteger)section;
- (NSString *)headerTextForSection:(NSInteger)section;

@end
