//
//  GHUIActivityView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/30/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

/*!
 View with activity indicator and label.
 */
@interface GHUIActivityView : GHUIView {
  UIActivityIndicatorView *_activityIndicator;
  BOOL _activityEnabled;
}

@property (assign, nonatomic) UIActivityIndicatorViewStyle activityStyle;
@property (retain, nonatomic) UILabel *label;

/*!
 Set text.
 @param text
 */
- (void)setText:(NSString *)text;

- (void)setAnimating:(BOOL)animating;
- (BOOL)isAnimating;

- (void)start;
- (void)stop;
- (void)setErrorWithDescription:(NSString *)description;

@end

