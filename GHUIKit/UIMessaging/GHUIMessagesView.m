//
//  GHUIMessagesView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/20/13.
//  Copyright (c) 2013 GHUIKit. All rights reserved.
//

#import "GHUIMessagesView.h"
#import "GHUIMessageView.h"
#import <GHKit/GHKitDefines.h>

@implementation GHUIMessagesView

- (void)sharedInit {
  [super sharedInit];
  
  GHWeakSelf blockSelf = self;
  
  _listView = [[GHUICollectionView alloc] init];
  _listView.backgroundColor = [UIColor clearColor];
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  flowLayout.minimumLineSpacing = 0;
  _listView.collectionViewLayout = flowLayout;
  [_listView setRefreshHeaderEnabled:YES];
  
  _listView.refreshBlock = ^(GHUICollectionView *collectionView) {
    [blockSelf refresh];
  };
  [self addSubview:_listView];
  
  _dataSource = [[GHUICollectionViewDataSource alloc] init];
  [_dataSource setCellClass:[GHUIMessageCell class] collectionView:_listView];
  
  _dataSource.cellSetBlock = ^(id cell, id object, NSIndexPath *indexPath) {
    [((GHUIMessageCell *)cell).messageView setMessage:object];
  };
  _listView.dataSource = _dataSource;
  _listView.delegate = _dataSource;
  
  _inputView = [[GHUIMessageInputView alloc] init];
  _inputView.delegate = self;
  [self addSubview:_inputView];
  
  [_keyboardHandler registerKeyboardNotificationsForView:self];
  _keyboardHandler.keyboardBlock = ^(id sender) {
    [blockSelf.listView scrollToBottom:NO];
  };
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGesture)];
  [_listView addGestureRecognizer:tapGesture];
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  CGFloat heightForInput = [_inputView heightForInput];
  
  [layout setFrame:CGRectMake(0, 0, size.width, size.height - heightForInput) view:_listView];
  [layout setFrame:CGRectMake(0, size.height - heightForInput, size.width, heightForInput) view:_inputView];
  
  return CGSizeMake(size.width, size.height);
}

- (void)setMessages:(NSArray *)messages {
  [_dataSource setObjects:messages section:0];
  [_listView reloadData];
  [_listView scrollToBottomAfterReload:NO];
}

- (void)messageInputView:(GHUIMessageInputView *)messageInputView didSendWithText:(NSString *)text {
  [self.delegate messagesView:self didSendWithText:text];
}

- (void)_handleTapGesture {
  [_inputView resignFirstResponder];
}

@end
