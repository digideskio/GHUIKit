//
//  GHUICatalogItem.h
//  GHUICatalog
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHUICatalogItem : NSObject
@property NSString *title;
@property NSString *detail;

+ (GHUICatalogItem *)itemForTitle:(NSString *)title detail:(NSString *)detail;

@end
