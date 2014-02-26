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
@property UIView *contentView;
@property (weak) id<GHUIViewNavigationDelegate> navigationDelegate;
@end

@implementation GHUIModalView

- (id)initWithTitle:(NSString *)title navigationDelegate:(id<GHUIViewNavigationDelegate>)navigationDelegate contentView:(UIView *)contentView {
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

- (void)_close {
  [self.navigationDelegate dismissViewAnimated:YES completion:nil];
}

@end
