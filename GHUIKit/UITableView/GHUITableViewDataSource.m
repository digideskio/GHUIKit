//
//  GHUITableViewDataSource.m
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITableViewDataSource.h"
#import "GHUILabel.h"

@implementation GHUITableViewDataSource

- (void)setCellClass:(Class)cellClass tableView:(UITableView *)tableView section:(NSInteger)section {
  //NSAssert(section > 0, @"Section must be > 0");
  if (!_cellClasses) _cellClasses = [[NSMutableDictionary alloc] init];
  [_cellClasses setObject:cellClass forKey:@(section)];
  [tableView registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)setHeaderText:(NSString *)headerText section:(NSInteger)section {
  if (!_headerTexts) {
    _headerTexts = [NSMutableDictionary dictionary];
  }
  [_headerTexts setObject:headerText forKey:@(section)];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self countForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = [self cellClassForIndexPath:indexPath];
  id cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
  self.cellSetBlock(cell, [self objectAtIndexPath:indexPath], indexPath, tableView);
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger sectionCount = [self sectionCount];
  if (sectionCount == 0) return 1; // Always need at least 1 section
  return sectionCount;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return (!!self.deleteBlock);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath && editingStyle == UITableViewCellEditingStyleDelete) {
    id object = [self objectAtIndexPath:indexPath];
    if (self.deleteBlock) self.deleteBlock(tableView, indexPath, object);
    [self removeObjectAtIndexPath:indexPath];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//  return [self headerTextForSection:section];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([self headerTextForSection:section]) {
    return 50;
  }
  return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  GHUILabel *label = [[GHUILabel alloc] init];
  label.insets = UIEdgeInsetsMake(30, 15, 0, 0);
  label.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1.0];
  label.text = [self headerTextForSection:section];
  label.font = [UIFont systemFontOfSize:14];
  label.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
  return label;
}

#pragma mark UICollectionViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self sizeForCellAtIndexPath:indexPath view:tableView].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectBlock) {
    id object = [self objectAtIndexPath:indexPath];
    self.selectBlock(tableView, indexPath, object);
  }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.shouldSelectBlock) {
    id object = [self objectAtIndexPath:indexPath];
    return self.shouldSelectBlock(tableView, indexPath, object);
  }
  return (self.selectBlock != NULL);
}

@end
