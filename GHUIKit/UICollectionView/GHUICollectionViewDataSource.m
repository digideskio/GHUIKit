//
//  GHUICollectionViewDataSource.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionViewDataSource.h"
#import "GHUICollectionViewCell.h"
#import <GHKit/GHNSArray+Utils.h>
#import "GHUICollectionViewLabel.h"

@implementation GHUICollectionViewDataSource

- (NSMutableArray *)objectsForSection:(NSInteger)section create:(BOOL)create {
  //NSAssert(section > 0, @"Section must be > 0");

  if (!_sections && create) _sections = [[NSMutableDictionary alloc] init];
  
  NSMutableArray *objectsForSection = [_sections objectForKey:@(section)];
  if (create && !objectsForSection) {
    objectsForSection = [NSMutableArray array];
    [_sections setObject:objectsForSection forKey:[NSNumber numberWithInteger:section]];
    if ((section + 1) > _sectionCount) _sectionCount = (section + 1);
  }
  return objectsForSection;
}

- (NSMutableArray *)objectsForSection:(NSInteger)section {
  return [self objectsForSection:section create:NO];
}

- (NSInteger)countForSection:(NSInteger)section {
  return [[self objectsForSection:section] count];
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

- (NSIndexPath *)updateObject:(id)object inSection:(NSInteger)section {
  NSInteger index = [self indexOfObject:object inSection:0];
  NSIndexPath *indexPath = nil;
  if (index != NSNotFound) {
    indexPath = [NSIndexPath indexPathForRow:index inSection:section];
    [self replaceObjectAtIndexPath:indexPath withObject:object];
  }
  return indexPath;
}

- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView {
  [self setCellClass:cellClass collectionView:collectionView section:-1];
}

- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView section:(NSInteger)section {
  //NSAssert(section > 0, @"Section must be > 0");
  if (!_cellClasses) _cellClasses = [[NSMutableDictionary alloc] init];
  [_cellClasses setObject:cellClass forKey:@(section)];
  [collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = [_cellClasses objectForKey:@(indexPath.section)];
  if (!cellClass) cellClass = [_cellClasses objectForKey:@(-1)];
  return cellClass;
}

- (void)setHeaderText:(NSString *)headerText collectionView:(UICollectionView *)collectionView section:(NSInteger)section {
  if (!_headerTexts) {
    _headerTexts = [NSMutableDictionary dictionary];
    [collectionView registerClass:[GHUICollectionViewLabel class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
  }
  [_headerTexts setObject:headerText forKey:@(section)];
}

- (NSString *)headerTextForSection:(NSInteger)section {
  return [_headerTexts objectForKey:@(section)];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  GHUICollectionViewLabel *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
  NSString *text = [self headerTextForSection:indexPath.section];
  view.label.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
  view.label.titleColor = [UIColor colorWithRed:255.0f/255.0f green:125.0f/255.0f blue:0.0f/255.0f alpha:1.0];
  view.label.titleFont = [UIFont systemFontOfSize:18];
  view.label.insets = UIEdgeInsetsMake(0, 10, 0, 10);
  [view.label setBorderStyle:GHUIBorderStyleTopBottom color:[UIColor colorWithWhite:230.0f/255.0f alpha:1.0] width:1.0 cornerRadius:0];
  view.label.title = text;
  return view;
}

#pragma mark UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  id object = [self objectAtIndexPath:indexPath];
  
  // Can't dequeue because that will cause this method and will infinite recurse.
  if (!_cellsForSizing) _cellsForSizing = [[NSMutableDictionary alloc] init];
  id cellForSizing = [_cellsForSizing objectForKey:@(indexPath.section)];
  if (!cellForSizing) {
    Class cellClass = [self cellClassForIndexPath:indexPath];
    cellForSizing = [[cellClass alloc] init];
    [_cellsForSizing setObject:cellForSizing forKey:@(indexPath.section)];
  }
  [cellForSizing setNeedsLayout];
  self.cellSetBlock(cellForSizing, object, indexPath);
  CGSize size = [cellForSizing sizeThatFits:collectionView.bounds.size];
  return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  if ([self countForSection:section] == 0) {
    return UIEdgeInsetsZero;
  }
  return self.sectionInset;
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
  return (self.selectBlock != NULL);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  if ([self countForSection:section] == 0) return CGSizeZero;
  NSString *text = [self headerTextForSection:section];
  if (text) return CGSizeMake(320, 38);
  return CGSizeZero;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [self.scrollViewDelegate scrollViewDidScroll:scrollView];
}

@end
