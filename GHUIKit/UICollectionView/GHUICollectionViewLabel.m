//
//  GHUICollectionViewLabel.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/14/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionViewLabel.h"

@implementation GHUICollectionViewLabel

- (void)sharedInit {
  _label = [[GHUILabel alloc] init];
  [self addSubview:_label];
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self sharedInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    [self sharedInit];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (CGSize)sizeThatFits:(CGSize)size {
  return [_label sizeThatFits:size];
}

@end
