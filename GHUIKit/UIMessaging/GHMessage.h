//
//  GHMessage.h
//  GHUIKit
//
//  Created by Gabriel Handford on 12/23/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

typedef NS_ENUM(NSUInteger, GHMessageType) {
  GHMessageTypeIncoming,
  GHMessageTypeOutgoing
};

@protocol GHMessage
@property (readonly) NSString *text;
@property (readonly) NSDate *dateCreated;
@property (readonly) GHMessageType messageType;
@property (readonly) NSString *shortUserName;
@property (readonly) NSString *userImageURLString;
@end
