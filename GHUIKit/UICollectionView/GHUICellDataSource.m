//
//  GHUICellDataSource.m
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICellDataSource.h"
#import "GHCGUtils.h"

@implementation GHUICellDataSource

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

  for(NSInteger i = 0, count = [objects count]; i < count; i++) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(i + previousCount) inSection:section];
    [self invalidate:indexPath];
    if (indexPaths) [*indexPaths addObject:indexPath];
  }
}

- (void)replaceObjects:(NSArray *)replaceObjects withObjects:(NSArray *)objects section:(NSInteger)section indexPathsToAdd:(NSMutableArray **)indexPathsToAdd indexPathsToReload:(NSMutableArray **)indexPathsToReload {
  
  NSAssert([replaceObjects count] == [objects count], @"Objects length mismatch");
  
  for (NSInteger i = 0; i < [objects count]; i++) {
    id replaceObject = [replaceObjects objectAtIndex:i];
    id object = [objects objectAtIndex:i];
    NSIndexPath *indexPath = [self indexPathOfObject:replaceObject section:section];
    if (indexPath) {
      [self replaceObjectAtIndexPath:indexPath withObject:object];
      if (indexPathsToReload) [*indexPathsToReload addObject:indexPath];
    } else {
      [self addObjects:@[object] section:section indexPaths:indexPathsToAdd];
    }
  }
  
}

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
  NSMutableArray *objectsForSection = [self objectsForSection:indexPath.section create:YES];
  [objectsForSection replaceObjectAtIndex:indexPath.row withObject:object];
  [self invalidate:indexPath];
}

- (void)removeObjectsFromSection:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths {
  NSMutableArray *objectsForSection = [self objectsForSection:section create:NO];
  if (indexPaths) {
    for (NSInteger i = 0; i < [objectsForSection count]; i++) [*indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:section]];
  }
  [objectsForSection removeAllObjects];
  [self invalidateAll];
}

- (void)removeObjects:(NSArray *)objects {
  [self removeObjects:objects section:0 indexPaths:nil];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray *objectsForSection = [self objectsForSection:indexPath.section create:NO];
  [objectsForSection removeObjectAtIndex:indexPath.row];
  [self invalidate:indexPath];
}

- (void)removeObjects:(NSArray *)objects section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths {
  NSMutableArray *objectsForSection = [self objectsForSection:section create:NO];
  if (!objectsForSection) return;
  for (id object in objects) {
    NSInteger index = [objectsForSection indexOfObject:object];
    if (index != NSNotFound) {
      [objectsForSection removeObjectAtIndex:index];
      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
      [self invalidate:indexPath];
      if (indexPaths) [*indexPaths addObject:indexPath];
    }
  }
}

- (void)invalidate:(NSIndexPath *)indexPath {
  [_sizeCache removeObjectForKey:indexPath];
}

- (void)invalidateAll {
  [_sizeCache removeAllObjects];
}

- (void)removeAllObjects {
  [_sections removeAllObjects];
  [self invalidateAll];
}

- (void)setObjects:(NSArray *)objects {
  [self setObjects:objects section:0 indexPathsToRemove:nil indexPathsToAdd:nil];
}

- (void)setObjects:(NSArray *)objects section:(NSInteger)section {
  [self setObjects:objects section:section indexPathsToRemove:nil indexPathsToAdd:nil];
}

- (void)setObjects:(NSArray *)objects section:(NSInteger)section indexPathsToRemove:(NSMutableArray **)indexPathsToRemove indexPathsToAdd:(NSMutableArray **)indexPathsToAdd {
  [self removeObjectsFromSection:section indexPaths:indexPathsToRemove];
  [self addObjects:objects section:section indexPaths:indexPathsToAdd];
  [self invalidateAll];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *objects = [self objectsForSection:indexPath.section];
  return [objects objectAtIndex:indexPath.row];
}

- (id)lastObjectInSection:(NSInteger)section {
  NSInteger count = [self countForSection:section];
  if (count == 0) return nil;
  return [self objectAtIndexPath:[NSIndexPath indexPathForItem:(count - 1) inSection:section]];
}

- (NSUInteger)indexOfObject:(id)object section:(NSInteger)section {
  NSArray *objectsForSection = [self objectsForSection:section create:NO];
  if (!objectsForSection) return NSNotFound;
  return [objectsForSection indexOfObject:object];
}

- (NSIndexPath *)indexPathOfObject:(id)object section:(NSInteger)section {
  NSUInteger index = [self indexOfObject:object section:section];
  if (index != NSNotFound) {
    return [NSIndexPath indexPathForRow:index inSection:section];
  }
  return nil;
}

- (NSIndexPath *)replaceObject:(id)object section:(NSInteger)section {
  NSIndexPath *indexPath = [self indexPathOfObject:object section:0];
  if (indexPath) {
    [self replaceObjectAtIndexPath:indexPath withObject:object];
    [self invalidate:indexPath];
  }
  return indexPath;
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath {
  if (self.classBlock) {
    id object = [self objectAtIndexPath:indexPath];
    return self.classBlock(object, indexPath);
  }
  
  Class cellClass = [_cellClasses objectForKey:@(indexPath.section)];
  if (!cellClass) cellClass = [_cellClasses objectForKey:@(-1)];
  return cellClass;
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath view:(UIView */*UITableView or UICollectionView*/)view {
  if (GHCGSizeIsEqual(view.bounds.size, CGSizeZero)) return CGSizeZero;
  
  id object = [self objectAtIndexPath:indexPath];
  
  NSValue *sizeCacheValue = [_sizeCache objectForKey:indexPath];
  if (sizeCacheValue) return [sizeCacheValue CGSizeValue];
  
  // We can't dequeue because that will cause this method and will infinite recurse.
  
  Class cellClass = [self cellClassForIndexPath:indexPath];
  NSAssert(cellClass, @"No cell class for indexPath: %@", indexPath);
  if (!_cellsForSizing) _cellsForSizing = [NSMutableDictionary dictionary];
  id cellForSizing = _cellsForSizing[NSStringFromClass(cellClass)];
  if (!cellForSizing) {
    cellForSizing = [[cellClass alloc] init];
    _cellsForSizing[NSStringFromClass(cellClass)] = cellForSizing;
  }
  
  [cellForSizing setNeedsLayout];
  self.cellSetBlock(cellForSizing, object, indexPath, view);
  
  //NSAssert(!GHCGSizeIsEqual(view.bounds.size, CGSizeZero), @"View size is empty");
  
  CGSize size = [cellForSizing sizeThatFits:view.bounds.size];
  
  //NSLog(@"(%@) %d.%d size: %@ in %@", [cellForSizing class], indexPath.section, indexPath.row, NSStringFromCGSize(size), NSStringFromCGSize(view.bounds.size));
  
  if (!_sizeCache) _sizeCache = [NSMutableDictionary dictionary];
  [_sizeCache setObject:[NSValue valueWithCGSize:size] forKey:indexPath];
  
  return size;
}

- (NSString *)headerTextForSection:(NSInteger)section {
  return [_headerTexts objectForKey:@(section)];
}

@end
