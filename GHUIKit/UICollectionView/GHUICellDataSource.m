//
//  GHUICellDataSource.m
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICellDataSource.h"

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

- (void)replaceObjects:(NSArray *)fromObjects withObjects:(NSArray *)objects section:(NSInteger)section {
  [self removeObjects:fromObjects section:section];
  [self addObjects:objects section:section];
}

- (void)removeAllObjectsFromSection:(NSInteger)section {
  NSMutableArray *objectsForSection = [self objectsForSection:section create:NO];
  [objectsForSection removeAllObjects];
}

- (void)removeObjects:(NSArray *)objects {
  [self removeObjects:objects section:0];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray *objectsForSection = [self objectsForSection:indexPath.section create:NO];
  [objectsForSection removeObjectAtIndex:indexPath.row];
}

- (void)removeObjects:(NSArray *)objects section:(NSInteger)section {
  NSMutableArray *objectsForSection = [self objectsForSection:section create:NO];
  [objectsForSection removeObjectsInArray:objects];
}

- (void)removeAllObjects {
  [_sections removeAllObjects];
}

- (void)setObjects:(NSArray *)objects {
  [self setObjects:objects section:0];
}

- (void)setObjects:(NSArray *)objects section:(NSInteger)section {
  [self removeAllObjectsFromSection:section];
  [self addObjects:objects section:section];
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

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath view:(UIView *)view {
  id object = [self objectAtIndexPath:indexPath];
  
  // We can't dequeue because that will cause this method and will infinite recurse.
  
  Class cellClass = [self cellClassForIndexPath:indexPath];
  if (!_cellsForSizing) _cellsForSizing = [NSMutableDictionary dictionary];
  id cellForSizing = _cellsForSizing[NSStringFromClass(cellClass)];
  if (!cellForSizing) {
    cellForSizing = [[cellClass alloc] init];
    _cellsForSizing[NSStringFromClass(cellClass)] = cellForSizing;
  }
  
  [cellForSizing setNeedsLayout];
  self.cellSetBlock(cellForSizing, object, indexPath);
  CGSize size = [cellForSizing sizeThatFits:view.bounds.size];
  return size;
}

@end
