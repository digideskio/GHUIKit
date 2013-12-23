//
//  GHUIMessageInputView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/20/13.
//  Copyright (c) 2013 GHUIKit. All rights reserved.
//

#import "GHUIView.h"

@class GHUIMessageInputView;

@protocol GHUIMessageInputViewDelegate
- (void)messageInputView:(GHUIMessageInputView *)messageInputView didSendWithText:(NSString *)text;
@end

@interface GHUIMessageInputView : GHUIView <UITextViewDelegate> {
  UIToolbar *_backgroundView;
  UITextView *_textView;
  UILabel *_placeholderLabel;
  UIButton *_sendButton;  
  UIButton *_textContainer;
}

@property (weak) id<GHUIMessageInputViewDelegate> delegate;
@property CGFloat heightForInput;

- (void)clear;

@end
