//
//  GHUIViewController.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/11/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIView.h"

@interface GHUIViewController : UIViewController <GHUIViewNavigationDelegate> {
  GHUIView *_contentView;
}

- (id)initWithView:(GHUIView *)view;

@end
