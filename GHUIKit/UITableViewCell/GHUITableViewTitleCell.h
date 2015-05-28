//
//  GHUITableViewTitleCell.h
//  GHUIKit
//
//  Created by Gabriel Handford on 3/31/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

#import "GHUIImageView.h"
#import "GHUILabel.h"
#import <GHUITable/GHUITableViewCell.h>

@interface GHUITableViewTitleView : GHUIView

@property GHUIImageView *imageView;
@property GHUILabel *nameLabel;
@property GHUILabel *descriptionLabel;

- (void)setName:(NSString *)name description:(NSString *)description imageName:(NSString *)imageName;
@end

@interface GHUITableViewTitleCell : GHUITableViewCell
- (void)setName:(NSString *)name description:(NSString *)description imageName:(NSString *)imageName;
@end

