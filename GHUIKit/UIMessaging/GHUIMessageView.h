//
//  GHUIMessageView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/20/13.
//  Copyright (c) 2013 AppsAgainstHumanity. All rights reserved.
//

#import "GHUIImageView.h"
#import "GHMessage.h"
#import "GHUICollectionViewCell.h"

@interface GHUIMessageView : GHUIView {
  GHUIImageView *_userImageView;
  UIImageView *_bubbleView;
  UILabel *_label;
  UILabel *_secondaryLabel;
}
@property (nonatomic) id<GHMessage> message;
@end

@interface GHUIMessageCell : GHUICollectionViewCell
@property (strong, nonatomic) GHUIMessageView *messageView;
@end