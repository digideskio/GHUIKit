//
//  GHUICollectionViewDataSource.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionViewDataSource.h"

@implementation GHUICollectionViewDataSource

- (void)removeAllObjects {
  [_sections removeAllObjects];
}

- (NSMutableArray *)objectsForSection:(NSInteger)section create:(BOOL)create {
  if (!_sections && create) _sections = [[NSMutableDictionary alloc] init];
  
  NSMutableArray *objectsForSection = [_sections objectForKey:[NSNumber numberWithInteger:section]];
  if (create && !objectsForSection) {
    objectsForSection = [NSMutableArray array];
    [_sections setObject:objectsForSection forKey:[NSNumber numberWithInteger:section]];
  }
  return objectsForSection;
}

- (NSMutableArray *)objectsForSection:(NSInteger)section {
  return [self objectsForSection:section create:NO];
}

- (NSInteger)countForSection:(NSInteger)section {
  return [[self objectsForSection:section] count];
}

- (NSInteger)sectionCount {
  return (_sections ? [_sections count] : 0);
}

- (void)addObjects:(NSArray *)objects section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths {
  NSMutableArray *objectsForSection = [self objectsForSection:section create:YES];
  NSInteger previousCount = [objectsForSection count];
  [objectsForSection addObjectsFromArray:objects];
  
  if (indexPaths) {
    for(NSInteger i = 0, count = [objects count]; i < count; i++) {
      [*indexPaths addObject:[NSIndexPath indexPathForRow:(i + previousCount) inSection:section]];
    }
  }
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *objects = [self objectsForSection:indexPath.section];
  return [objects objectAtIndex:indexPath.row];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self countForSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  id object = [self objectAtIndexPath:indexPath];
  Class cellClass = self.cellClassBlock(collectionView, indexPath, object);
  id cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
  self.cellSetBlock(cell, [self objectAtIndexPath:indexPath], indexPath);
  return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return [self sectionCount];
}

#pragma mark UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  id object = [self objectAtIndexPath:indexPath];
  Class cellClass = self.cellClassBlock(collectionView, indexPath, object);
  if (!_cellForSizing) _cellForSizing = [[cellClass alloc] init];
  self.cellSetBlock(_cellForSizing, [self objectAtIndexPath:indexPath], indexPath);
  return [_cellForSizing sizeThatFits:collectionView.bounds.size];
}

@end
