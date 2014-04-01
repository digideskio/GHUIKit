//
//  GHUIModalView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 2/14/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIModalView.h"

@interface GHUIModalView ()
@property UINavigationBar *navigationBar;
@property GHUIContentView *contentView;
@property (weak) id<GHUIViewNavigationDelegate> navigationDelegate;
@end

@implementation GHUIModalView

- (id)initWithTitle:(NSString *)title navigationDelegate:(id<GHUIViewNavigationDelegate>)navigationDelegate contentView:(GHUIContentView *)contentView {
  if ((self = [super init])) {
    self.layout = [GHLayout layoutForView:self];
    self.navigationDelegate = navigationDelegate;
    self.contentView = contentView;
    
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    
    self.navigationBar = [[UINavigationBar alloc] init];
    self.navigationBar.backgroundColor = [UIColor colorWithWhite:248.0/255.0 alpha:1.0];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor blackColor], NSForegroundColorAttributeName,
                                            [UIFont systemFontOfSize:20], NSFontAttributeName, nil]];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:title];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(_close)];
    navigationItem.rightBarButtonItem = rightItem;
    [self.navigationBar setItems:@[navigationItem]];
    [self addSubview:self.navigationBar];
    
    [self addSubview:self.contentView];
  }
  return self;
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  [layout setFrame:CGRectMake(0, 0, size.width, 44) view:_navigationBar];
  [layout setFrame:CGRectMake(0, 44, size.width, size.height - 44) view:_contentView];
  return CGSizeMake(size.width, size.height);
}

- (void)viewWillAppear:(BOOL)animated {
  [_contentView viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [_contentView viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [_contentView viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [_contentView viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
  [_contentView viewDidLayoutSubviews];
}

- (void)_close {
  [self.navigationDelegate dismissViewAnimated:YES completion:nil];
}

@end
