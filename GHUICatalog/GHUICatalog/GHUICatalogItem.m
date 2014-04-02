//
//  GHUICatalogItem.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogItem.h"

@implementation GHUICatalogItem

+ (GHUICatalogItem *)itemForTitle:(NSString *)title detail:(NSString *)detail {
  GHUICatalogItem *item = [[GHUICatalogItem alloc] init];
  item.title = title;
  item.detail = detail;
  return item;
}

@end
