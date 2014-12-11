//
//  GHUICatalogCell.h
//  GHUICatalog
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GHUIKit/GHUIView.h>
#import <GHUIKit/GHUITableViewCell.h>

@interface GHUICatalogCellView : GHUIView
- (void)setName:(NSString *)name description:(NSString *)description image:(UIImage *)image;
@end

@interface GHUICatalogCell : GHUITableViewCell
- (void)setName:(NSString *)name description:(NSString *)description image:(UIImage *)image;
@end

