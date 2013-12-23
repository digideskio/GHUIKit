//
//  GHUIMessageView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/20/13.
//  Copyright (c) 2013 AppsAgainstHumanity. All rights reserved.
//

#import "GHUIMessageView.h"
#import "GHUIImage+Utils.h"
#import "GHUIColor+Utils.h"

@implementation GHUIMessageView

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  self.backgroundColor = [UIColor whiteColor];
  
  _userImageView = [[GHUIImageView alloc] init];
  _userImageView.fillColor = [UIColor grayColor];
  _userImageView.contentMode = UIViewContentModeScaleAspectFill;
  _userImageView.cornerRadiusPercentage = 50;
  [self addSubview:_userImageView];
  
  _label = [[UILabel alloc] init];
  _label.backgroundColor = [UIColor clearColor];
  _label.numberOfLines = 0;
  //_label.textAlignment = NSTextAlignmentRight;
  _label.font = [UIFont systemFontOfSize:16];
  _label.textColor = [UIColor whiteColor];
  [self addSubview:_label];
  
  _secondaryLabel = [[UILabel alloc] init];
  _secondaryLabel.backgroundColor = [UIColor clearColor];
  _secondaryLabel.numberOfLines = 0;
  _secondaryLabel.textColor = [UIColor colorWithWhite:153.0f/255.0f alpha:1.0];
  //_secondaryLabel.textAlignment = NSTextAlignmentRight;
  _secondaryLabel.font = [UIFont systemFontOfSize:12.0f];
  [self addSubview:_secondaryLabel];
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  if (_message.messageType == GHMessageTypeIncoming) {
    return [self layoutIncoming:layout size:size];
  } else {
    return [self layoutOutgoing:layout size:size];
  }
}

- (CGSize)layoutIncoming:(id<GHLayout>)layout size:(CGSize)size {
  CGFloat y = 10;
  CGFloat maxBubbleWidth = 200;
  CGSize labelSize = [_label sizeThatFits:CGSizeMake(maxBubbleWidth - 37, CGFLOAT_MAX)];
  CGFloat bubbleX = 46;
  
  [layout setFrame:CGRectMake(bubbleX, y, labelSize.width + 27, labelSize.height + 20) view:_bubbleView];
  
  [layout setFrame:CGRectMake(bubbleX + 17, y + 10, labelSize.width, labelSize.height) view:_label];
  y += labelSize.height + 20;
  
  [layout setFrame:CGRectMake(10, y - 36, 40, 40) view:_userImageView];
  y += 4;
  
  CGSize secondaryLabelSize = [_secondaryLabel sizeThatFits:CGSizeMake(size.width - 70, CGFLOAT_MAX)];
  CGRect secondaryLabelFrame = [layout setFrame:CGRectMake(10, y, size.width - 20, secondaryLabelSize.height) view:_secondaryLabel];
  y += secondaryLabelFrame.size.height + 10;
  
  return CGSizeMake(size.width, y);
}

- (CGSize)layoutOutgoing:(id<GHLayout>)layout size:(CGSize)size {
  CGFloat y = 10;
  CGFloat maxBubbleWidth = 200;
  CGSize labelSize = [_label sizeThatFits:CGSizeMake(maxBubbleWidth - 37, CGFLOAT_MAX)];
  //CGSize labelSize = [GHUIUtils sizeWithText:_label.text font:_label.font width:(maxBubbleWidth - 27) multiline:YES truncate:NO];
  CGFloat bubbleWidth = labelSize.width + 27;
  CGFloat bubbleX = size.width - bubbleWidth - 46;
  
  [layout setFrame:CGRectMake(bubbleX, y, bubbleWidth, labelSize.height + 20) view:_bubbleView];
  
  [layout setFrame:CGRectMake(bubbleX + 10, y + 10, labelSize.width, labelSize.height) view:_label];
  y += labelSize.height + 20;
  
  [layout setFrame:CGRectMake(size.width - 50, y - 36, 40, 40) view:_userImageView];
  y += 4;
  
  CGSize secondaryLabelSize = [_secondaryLabel sizeThatFits:CGSizeMake(size.width - 70, CGFLOAT_MAX)];
  CGRect secondaryLabelFrame = [layout setFrame:CGRectMake(10, y, size.width - 20, secondaryLabelSize.height) view:_secondaryLabel];
  y += secondaryLabelFrame.size.height + 10;
  
  return CGSizeMake(size.width, y);
}

- (void)setMessage:(id<GHMessage>)message {
  _message = message;
  _label.text = message.text;
  if (!_label.text) _label.text = @"";
  //_secondaryLabel.text = [NSString stringWithFormat:@"%@ %@ ago", [message.user name], [message.dateCreated gh_timeAgo:NO]];
  NSString *dateString = [NSDateFormatter localizedStringFromDate:message.dateCreated dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
  
  [_userImageView setImageWithURL:[NSURL URLWithString:message.userImageURLString]];
  
  [_bubbleView removeFromSuperview];
  UIImageView *bubbleView = [self bubbleImageViewForMessage:message];
  [self addSubview:bubbleView];
  _bubbleView = bubbleView;
  [self sendSubviewToBack:_bubbleView];
  
  if (_message.messageType == GHMessageTypeIncoming) {
    _label.textColor = [UIColor blackColor];
    _secondaryLabel.text = [NSString stringWithFormat:@"%@ %@", [message shortUserName], dateString];
    _secondaryLabel.textAlignment = NSTextAlignmentLeft;
  } else {
    _label.textColor = [UIColor whiteColor];
    _secondaryLabel.text = [NSString stringWithFormat:@"%@ %@", dateString, [message shortUserName]];
    _secondaryLabel.textAlignment = NSTextAlignmentRight;
  }
  
  [self setNeedsLayout];
}

- (UIImageView *)bubbleImageViewForMessage:(id<GHMessage>)message {
  UIImage *bubble = [UIImage imageNamed:@"bubble-min"];
  
  UIColor *color = (message.messageType == GHMessageTypeOutgoing ? [UIColor colorWithRed:28.0f/255.0f green:145.0f/255.0f blue:252.0f/255.0f alpha:1.0f] : [UIColor colorWithWhite:230.0f/255.0f alpha:1.0f]);
  
  UIImage *normalBubble = [bubble gh_imageMaskWithColor:color];
  UIImage *highlightedBubble = [bubble gh_imageMaskWithColor:[color gh_darkenColorWithValue:0.12f]];
  
  if (message.messageType == GHMessageTypeIncoming) {
    normalBubble = [normalBubble gh_imageFlippedHorizontal];
    highlightedBubble = [highlightedBubble gh_imageFlippedHorizontal];
  }
  
  UIEdgeInsets capInsets = UIEdgeInsetsMake(15.0f, 20.0f, 15.0f, 20.0f);
  
  return [[UIImageView alloc] initWithImage:[normalBubble resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] highlightedImage:[highlightedBubble resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch]];
}


@end


@implementation GHUIMessageCell

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    _messageView = [[GHUIMessageView alloc] initWithFrame:self.bounds];
    [self setViewForContent:_messageView];
  }
  return self;
}

@end