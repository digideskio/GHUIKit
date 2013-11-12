//
//  GHUICollectionViewDataSource.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionViewDataSource.h"
#import <GHKit/GHNSArray+Utils.h>

@implementation GHUICollectionViewDataSource

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

- (void)addObjects:(NSArray *)objects {
  [self addObjects:objects section:0 indexPaths:nil];
}

- (void)addObjects:(NSArray *)objects section:(NSInteger)section {
  [self addObjects:objects section:section indexPaths:nil];
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

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
  NSMutableArray *objectsForSection = [self objectsForSection:indexPath.section create:YES];
  [objectsForSection replaceObjectAtIndex:indexPath.row withObject:object];
}

- (void)removeAllObjectsFromSection:(NSInteger)section {
  NSMutableArray *objectsForSection = [self objectsForSection:section create:NO];
  [objectsForSection removeAllObjects];
}

- (void)removeAllObjects {
  [_sections removeAllObjects];
}

- (void)setObjects:(NSArray *)objects section:(NSInteger)section {
  [self removeAllObjectsFromSection:section];
  [self addObjects:objects section:section];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *objects = [self objectsForSection:indexPath.section];
  return [objects objectAtIndex:indexPath.row];
}

- (NSUInteger)indexOfObject:(id)object inSection:(NSInteger)section {
  NSArray *objectsForSection = [self objectsForSection:section create:NO];
  if (!objectsForSection) return NSNotFound;
  return [objectsForSection indexOfObject:object];
}

- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView {
  [self setCellClass:cellClass collectionView:collectionView section:-1];
}

- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView section:(NSInteger)section {
  if (!_cellClasses) _cellClasses = [[NSMutableDictionary alloc] init];
  [_cellClasses setObject:cellClass forKey:@(section)];
  [collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = [_cellClasses objectForKey:@(indexPath.section)];
  if (!cellClass) cellClass = [_cellClasses objectForKey:@(-1)];
  return cellClass;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self countForSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = [self cellClassForIndexPath:indexPath];
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
  Class cellClass = [self cellClassForIndexPath:indexPath];
  
  if (!_cellsForSizing) _cellsForSizing = [[NSMutableDictionary alloc] init];
  id cellForSizing = [_cellsForSizing objectForKey:@(indexPath.section)];
  if (!cellForSizing) {
    cellForSizing = [[cellClass alloc] init];
    [_cellsForSizing setObject:cellForSizing forKey:@(indexPath.section)];
  }
  
  self.cellSetBlock(cellForSizing, object, indexPath);
  return [cellForSizing sizeThatFits:collectionView.bounds.size];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectBlock) {
    id object = [self objectAtIndexPath:indexPath];
    self.selectBlock(collectionView, indexPath, object);
  }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.shouldSelectBlock) {
    id object = [self objectAtIndexPath:indexPath];
    return self.shouldSelectBlock(collectionView, indexPath, object);
  }
  return YES;
}


@end
