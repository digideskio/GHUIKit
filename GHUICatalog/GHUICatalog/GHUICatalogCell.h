//
//  GHUICatalogCell.h
//  GHUICatalog
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GHUIKit/GHUIView.h>
//#import <GHUIKit/GHUITableViewCell.h>
#import <GHUIKit/GHUITableViewSwipeCell.h>

@interface GHUICatalogCellView : GHUIView
- (void)setName:(NSString *)name description:(NSString *)description image:(UIImage *)image;
@end

@interface GHUICatalogCell : GHUITableViewSwipeCell
- (void)setName:(NSString *)name description:(NSString *)description image:(UIImage *)image;
@end

