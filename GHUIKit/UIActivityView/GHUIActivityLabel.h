//
//  GHUIActivityLabel.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/31/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

/*!
 Label that includes an activity indicator or image and text, with optional detailed text below it.
 For example, the pull to refresh loading indicator.
 */
@interface GHUIActivityLabel : GHUIView {
  UIActivityIndicatorView *_activityIndicator;
  UILabel *_textLabel;
  UILabel *_detailLabel;
}

/*!
 Whether view is hidden if stopped.
 */
@property (assign, nonatomic) BOOL hidesWhenStopped;

/*!
 Start or stop animating.
 */
@property (assign, nonatomic, getter=isAnimating) BOOL animating;

/*!
 Text label.
 */
@property (readonly, nonatomic) UILabel *textLabel;

/*!
 Detail label, which appears under the textLabel.
 */
@property (readonly, nonatomic) UILabel *detailLabel;

/*!
 Image view, when not animating (activity indicator).
 */
@property (readonly, nonatomic) UIImageView *imageView;

/*!
 Activity indicator style.
 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

/*!
 Set image to display when not animating.
 By default no image is shown.
 @param image Image
 */
- (void)setImage:(UIImage *)image;

/*!
 Set text.
 Alternatively, you can set textLabel.text.
 You should call setNeedsLayout.
 @param text Text
 */
- (void)setText:(NSString *)text;

/*!
 Set detail text.
 You should call setNeedsLayout.
 @param detailText Detail text
 */
- (void)setDetailText:(NSString *)detailText;

/*!
 Start activity indicator.
 */
- (void)startAnimating;

/*!
 Stop activity indicator.
 */
- (void)stopAnimating;

@end
