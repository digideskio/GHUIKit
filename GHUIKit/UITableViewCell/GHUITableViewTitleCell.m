//
//  GHUITableViewTitleCell.m
//  GHUIKit
//
//  Created by Gabriel Handford on 3/31/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITableViewTitleCell.h"

@implementation GHUITableViewTitleView

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  self.backgroundColor = [UIColor clearColor];
  
  _imageView = [[GHUIImageView alloc] init];
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  [self addSubview:_imageView];
  
  _nameLabel = [[GHUILabel alloc] init];
  _nameLabel.font = [UIFont systemFontOfSize:20];
  [self addSubview:_nameLabel];
  
  _descriptionLabel = [[GHUILabel alloc] init];
  _descriptionLabel.font = [UIFont systemFontOfSize:16];
  [self addSubview:_descriptionLabel];
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  CGFloat x = 10;
  CGFloat y = 10;
  
  if (!_imageView.hidden) {
    [layout setFrame:CGRectMake(x, y, 50, 50) view:_imageView];
    x += 50 + 10;
  }
  
  CGRect nameLabelFrame = [layout setFrame:CGRectMake(x, y, size.width - x - 10, 0) view:_nameLabel sizeToFit:YES];
  y += nameLabelFrame.size.height + 4;
  
  if (_descriptionLabel.text) {
    CGRect descriptionLabelFrame = [layout setFrame:CGRectMake(x, y, size.width - x - 10, 0) view:_descriptionLabel sizeToFit:YES];
    y += descriptionLabelFrame.size.height + 10;
  }
  
  if (y < 70) y = 70;
  
  return CGSizeMake(size.width, y);
}

- (void)setName:(NSString *)name description:(NSString *)description imageName:(NSString *)imageName {
  _nameLabel.text = name;
  _descriptionLabel.text = description;
  if (imageName) {
    _imageView.hidden = NO;
    if ([imageName hasPrefix:@"http"] || [imageName hasPrefix:@"https"]) {
      [_imageView setImageWithURL:[NSURL URLWithString:imageName]];
    } else {
      _imageView.image = [UIImage imageNamed:imageName];
    }
  } else {
    _imageView.hidden = YES;
  }
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

@end


@implementation GHUITableViewTitleCell

+ (Class)contentViewClass {
  return [GHUITableViewTitleView class];
}

- (void)setName:(NSString *)name description:(NSString *)description imageName:(NSString *)imageName {
  [self.viewForContent setName:name description:description imageName:imageName];
}

@end

