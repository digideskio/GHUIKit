//
//  GHUIMessagesView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/20/13.
//  Copyright (c) 2013 AppsAgainstHumanity. All rights reserved.
//

#import "GHUIView.h"
#import "GHUICollectionView.h"
#import "GHUICollectionViewDataSource.h"
#import "GHUIMessageInputView.h"
#import "GHUIKeyboardHandler.h"

@class GHUIMessagesView;

@protocol GHUIMessagesViewDelegate <NSObject>
- (void)messagesView:(GHUIMessagesView *)messagesView didSendWithText:(NSString *)text;
@end

@interface GHUIMessagesView : GHUIView <GHUIMessageInputViewDelegate> {
  GHUICollectionViewDataSource *_dataSource;
  GHUIKeyboardHandler *_keyboardHandler;
}

@property GHUICollectionView *listView;
@property GHUIMessageInputView *inputView;
@property (weak) id<GHUIMessagesViewDelegate> delegate;

- (void)setMessages:(NSArray */*of id<GHMessage>*/)messages;

@end
