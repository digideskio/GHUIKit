//
//  GHUICellDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

typedef void (^GHUICellSetBlock)(id cell, id object, NSIndexPath *indexPath);
typedef void (^GHUICellSelectBlock)(id sender, NSIndexPath *indexPath, id object);
typedef BOOL (^GHUICellShouldSelectBlock)(id sender, NSIndexPath *indexPath, id object);

@interface GHUICellDataSource : NSObject  {
  NSMutableDictionary *_sections;
  NSInteger _sectionCount;
  NSMutableDictionary *_cellClasses;
  NSMutableDictionary *_cellsForSizing;
  NSMutableDictionary *_headerTexts;
}

@property (readonly) NSInteger sectionCount;
@property UIEdgeInsets sectionInset;

@property (copy) GHUICellSetBlock cellSetBlock;
@property (copy) GHUICellSelectBlock selectBlock;
@property (copy) GHUICellShouldSelectBlock shouldSelectBlock;
@property (weak) id<UIScrollViewDelegate> scrollViewDelegate;


- (NSMutableArray *)objectsForSection:(NSInteger)section;
- (NSMutableArray *)objectsForSection:(NSInteger)section create:(BOOL)create;

- (NSInteger)countForSection:(NSInteger)section;

- (NSInteger)sectionCount;

- (void)addObjects:(NSArray *)objects;
- (void)addObjects:(NSArray *)objects section:(NSInteger)section;
- (void)addObjects:(NSArray *)objects section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
- (void)replaceObjects:(NSArray *)fromObjects withObjects:(NSArray *)objects section:(NSInteger)section;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)indexOfObject:(id)object inSection:(NSInteger)section;

- (void)removeObjects:(NSArray *)objects;
- (void)removeObjects:(NSArray *)objects section:(NSInteger)section;
- (void)removeAllObjects;
- (void)removeAllObjectsFromSection:(NSInteger)section;

- (void)setObjects:(NSArray *)objects;
- (void)setObjects:(NSArray *)objects section:(NSInteger)section;

- (NSIndexPath *)updateObject:(id)object inSection:(NSInteger)section;

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath view:(UIView *)view;

@end
