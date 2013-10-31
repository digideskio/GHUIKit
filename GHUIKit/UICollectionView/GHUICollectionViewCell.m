//
//  GHUICollectionViewCell.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/25/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionViewCell.h"

@implementation GHUICollectionViewCell

- (void)sharedInit {
  UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
  backgroundView.backgroundColor = [UIColor whiteColor];
  self.backgroundView = backgroundView;
  
  UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
  selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:(217.0f/255.0f) alpha:1.0f];
  self.selectedBackgroundView = selectedBackgroundView;
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self sharedInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self sharedInit];
  }
  return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
  if (self.viewForContent) {
    return [self.viewForContent sizeThatFits:size];
  }
  return [super sizeThatFits:size];
}

- (void)setViewForContent:(UIView *)viewForContent {
  _viewForContent = viewForContent;
  [self.contentView addSubview:_viewForContent];
}

@end
