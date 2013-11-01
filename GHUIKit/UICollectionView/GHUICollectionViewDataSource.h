//
//  GHUICollectionViewDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

typedef Class (^GHUICollectionViewCellClassBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, id object);

typedef void (^GHUICollectionViewCellSetBlock)(id cell, id object, NSIndexPath *indexPath);

@interface GHUICollectionViewDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate> {
  NSMutableDictionary *_sections;
  
  id _cellForSizing;
}

@property (nonatomic, copy) GHUICollectionViewCellClassBlock cellClassBlock;
@property (nonatomic, copy) GHUICollectionViewCellSetBlock cellSetBlock;

- (NSMutableArray *)objectsForSection:(NSInteger)section;
- (NSMutableArray *)objectsForSection:(NSInteger)section create:(BOOL)create;

- (NSInteger)countForSection:(NSInteger)section;

- (NSInteger)sectionCount;

- (void)addObjects:(NSArray *)objects section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (void)removeAllObjects;

@end
