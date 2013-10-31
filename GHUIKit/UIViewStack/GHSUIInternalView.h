//
//  GHSUIInternalView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

@class GHSUIView;

@interface GHSUIInternalView : GHUIView {
  GHSUIView *_view;
}

@property (retain, nonatomic) GHSUIView *view;

- (void)viewWillAppear:(BOOL)animated;

- (void)viewDidAppear:(BOOL)animated;

- (void)viewWillDisappear:(BOOL)animated;

- (void)viewDidDisappear:(BOOL)animated;

@end
