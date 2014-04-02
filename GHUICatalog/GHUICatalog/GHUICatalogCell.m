//
//  GHUICatalogCell.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogCell.h"
#import <GHUIKit/GHUILabel.h>

@interface GHUICatalogCellView ()
@property UILabel *nameLabel;
@property UILabel *descriptionLabel;
@property UIImageView *imageView;
@end

@implementation GHUICatalogCellView

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  self.backgroundColor = [UIColor clearColor];
  
  _imageView = [[UIImageView alloc] init];
  [self addSubview:_imageView];
  
  _nameLabel = [[UILabel alloc] init];
  _nameLabel.font = [UIFont systemFontOfSize:20];
  [self addSubview:_nameLabel];
  
  _descriptionLabel = [[UILabel alloc] init];
  _descriptionLabel.font = [UIFont systemFontOfSize:16];
  [self addSubview:_descriptionLabel];
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  CGFloat x = 10;
  CGFloat y = 10;
  
  [layout setFrame:CGRectMake(x, y, 50, 50) view:_imageView];
  x += 50 + 10;
  
  CGRect nameLabelFrame = [layout setFrame:CGRectMake(x, y, size.width - x - 10, 0) view:_nameLabel options:GHLayoutOptionsSizeToFit|GHLayoutOptionsSizeToFitConstrainWidth];
  y += nameLabelFrame.size.height + 4;
  
  if ([_descriptionLabel.text gh_isPresent]) {
    CGRect descriptionLabelFrame = [layout setFrame:CGRectMake(x, y, size.width - x - 10, 0) view:_descriptionLabel options:GHLayoutOptionsSizeToFit|GHLayoutOptionsFixedWidth];
    y += descriptionLabelFrame.size.height + 10;
  }
  
  if (y < 70) y = 70;
  
  return CGSizeMake(size.width, y);
}

- (void)setName:(NSString *)name description:(NSString *)description image:(UIImage *)image {
  _nameLabel.text = name;
  _descriptionLabel.text = description;
  _imageView.image = image;
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

@end


@implementation GHUICatalogCell

+ (Class)contentViewClass {
  return [GHUICatalogCellView class];
}

- (void)setName:(NSString *)name description:(NSString *)description image:(UIImage *)image {
  [self.viewForContent setName:name description:description image:image];
}

@end
