//
//  GHUIMessageInputView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/20/13.
//  Copyright (c) 2013 GHUIKit. All rights reserved.
//

#import "GHUIMessageInputView.h"
#import <GHKit/GHNSString+Utils.h>

@implementation GHUIMessageInputView

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  
  _backgroundView = [[UIToolbar alloc] init];
  [self addSubview:_backgroundView];
  
  _sendButton = [[UIButton alloc] init];
  _sendButton.backgroundColor = [UIColor clearColor];
  [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
  UIColor *disabledColor = [UIColor colorWithHue:240.0f/360.0f saturation:0.03f brightness:0.58f alpha:1.0f];
  [_sendButton setTitleColor:disabledColor forState:UIControlStateDisabled];
  UIColor *enabledColor = [UIColor colorWithHue:211.0f/360.0f saturation:1.0f brightness:1.0f alpha:1.0f];
  [_sendButton setTitleColor:enabledColor forState:UIControlStateNormal];
  [_sendButton addTarget:self action:@selector(_didSend) forControlEvents:UIControlEventTouchUpInside];
  UILabel *label = [_sendButton titleLabel];
  label.font = [UIFont boldSystemFontOfSize:17.0f];
  [self addSubview:_sendButton];
  
  _textContainer = [UIButton buttonWithType:UIButtonTypeCustom];
  [_textContainer setClipsToBounds:YES];
  [_textContainer setBackgroundColor:[UIColor colorWithWhite:0.98f alpha:1.0f]];
  CALayer *layer = [_textContainer layer];
  UIColor *borderColor = [UIColor colorWithHue:240.0f/360.0f saturation:0.02f brightness:0.8f alpha:1.0f];
  [layer setBorderColor:[borderColor CGColor]];
  [layer setBorderWidth:0.5f];
  [layer setCornerRadius:5.25f];
  [self addSubview:_textContainer];
  
  _textView = [[UITextView alloc] init];
  _textView.scrollIndicatorInsets = UIEdgeInsetsMake(8.0f, 0.0f, 8.0f, 0.5f);
  _textView.backgroundColor = [UIColor clearColor];
  _textView.delegate = self;
  _textView.font = [UIFont systemFontOfSize:17.0f];
  [self addSubview:_textView];
  [_textContainer addTarget:_textView action:@selector(becomeFirstResponder) forControlEvents:UIControlEventTouchUpInside];
  
  _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  _placeholderLabel.text = @"Send a Message";
  [_placeholderLabel setBackgroundColor:[UIColor clearColor]];
  [_placeholderLabel setUserInteractionEnabled:NO];
  [_placeholderLabel setFont:[UIFont systemFontOfSize:17.0f]];
  [_placeholderLabel setTextColor:[UIColor colorWithHue:240.0f/360.0f saturation:0.02f brightness:0.8f alpha:1.0f]];
  [_placeholderLabel setAdjustsFontSizeToFitWidth:YES];
  [self addSubview:_placeholderLabel];
  
  [self _viewDidChange];  
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  [layout setFrame:CGRectMake(0, 0, size.width, size.height) view:_backgroundView];
  
  CGSize buttonSize = [_sendButton sizeThatFits:size];
  
  [layout setFrame:CGRectMake(size.width - buttonSize.width - 8, size.height - buttonSize.height - 8, buttonSize.width, buttonSize.height) view:_sendButton];
  
  CGFloat inputWidth = size.width - buttonSize.width - 24;
  [layout setFrame:CGRectMake(8, 8, inputWidth, size.height - 16) view:_textContainer];
  
  [layout setFrame:CGRectMake(16, 8, inputWidth - 16, size.height - 16) view:_placeholderLabel];
  [layout setFrame:CGRectMake(11, 6, inputWidth - 8, size.height - 16) view:_textView];
  
  return CGSizeMake(size.width, size.height);
}

- (BOOL)resignFirstResponder {
  return [_textView resignFirstResponder];
}

- (void)_didSend {
  [_textView resignFirstResponder];
  [self.delegate messageInputView:self didSendWithText:_textView.text];
}

- (void)clear {
  _textView.text = @"";
  [self _viewDidChange];
}

- (void)_viewDidChange {
  _placeholderLabel.hidden = ![_textView.text isEqualToString:@""];
  _sendButton.enabled = [_textView.text gh_isPresent];
  self.heightForInput = [self _heightForInput];
  [self _adjustHeight];
}

- (CGFloat)textHeight {
  CGFloat height = [_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, FLT_MAX)].height;
  return ceilf(height);
}

- (CGFloat)_heightForInput {
  CGFloat textHeight = [self textHeight] + 12;
  CGFloat maxViewHeight = 200.0f;
  return MIN(textHeight, maxViewHeight);
}

- (void)_adjustHeight {
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.heightForInput);
}

- (void)textViewDidChange:(UITextView *)textView {
  [self _viewDidChange];
}

@end

//- (void)scrollToCaretIfNeeded {
//  UITextRange *selectedTextRange = [_textView selectedTextRange];
//  if ([selectedTextRange isEmpty]) {
//    UITextPosition *position = [selectedTextRange start];
//    CGPoint offset = [_textView contentOffset];
//    CGFloat relativeCaretY = [_textView caretRectForPosition:position].origin.y - offset.y - 7.0f;
//    CGFloat offsetYDelta = 0.0f;
//    // Caret is above visible part of text view:
//    if (relativeCaretY < 0.0f) {
//      offsetYDelta = relativeCaretY;
//    }
//    // Caret is in or below visible part of text view:
//    else if (relativeCaretY > 0.0f) {
//      CGFloat maxY = self.bounds.size.height - 44;
//      // Caret is below visible part of text view:
//      if (relativeCaretY > maxY)
//        offsetYDelta = relativeCaretY - maxY;
//    }
//
//    if (offsetYDelta) {
//      offset.y += offsetYDelta;
//      [_textView setContentOffset:offset];
//    }
//  }
//}
