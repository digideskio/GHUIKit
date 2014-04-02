//
//  GHUICatalogAnimations.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 2/7/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogAnimations.h"

#import "GHUICatalogItem.h"

#import <GHUIKit/GHUIViewControllerSlide3D.h>
#import <GHUIKit/GHUIViewControllerModal.h>
#import <GHUIKit/GHUIViewControllerDrop.h>
#import <GHUIKit/GHUIViewControllerDropUp.h>
#import <GHUIKit/GHUIViewControllerReveal.h>
#import <GHUIKit/GHUILabel.h>
#import <GHUIKit/GHUIModalView.h>

@implementation GHUICatalogAnimations

- (void)sharedInit {
  [super sharedInit];
  self.navigationTitle = @"Animations";
  
  NSMutableArray *items = [NSMutableArray array];
  [items addObject:[GHUICatalogItem itemForTitle:@"Reveal" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Drop Down" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Drop Up" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Modal (Bottom)" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Modal (Right)" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Modal (Left)" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Modal (Top)" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Modal (Bottom+Nav)" detail:nil]];
  [items addObject:[GHUICatalogItem itemForTitle:@"Slide" detail:nil]];
  [self.dataSource addObjects:items];
}

- (void)_dismiss {
  [self.navigationDelegate dismissViewAnimated:YES completion:nil];
}

- (void)presentModalWithView:(GHUIContentView *)view insets:(UIEdgeInsets)insets startPosition:(GHUIViewControllerModalStartPosition)startPosition {
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismiss)];
  [view addGestureRecognizer:tapRecognizer];
  GHUIViewControllerModal *animation = [[GHUIViewControllerModal alloc] init];
  animation.insets = insets;
  animation.startPosition = startPosition;
  animation.shadowAlpha = 0.5;
  [self.navigationDelegate presentView:view animation:animation completion:nil];
}

- (void)selectItem:(GHUICatalogItem *)item {
  if ([item.title isEqualToString:@"Reveal"]) {
    GHUIViewControllerReveal *animation = [[GHUIViewControllerReveal alloc] init];
    [self.navigationDelegate pushView:[self testView:item.title] animation:animation];
  } else if ([item.title isEqualToString:@"Drop Down"]) {
    GHUIViewControllerDrop *animation = [[GHUIViewControllerDrop alloc] init];
    [self.navigationDelegate pushView:[self testView:item.title] animation:animation];
  } else if ([item.title isEqualToString:@"Drop Up"]) {
    GHUIViewControllerDropUp *animation = [[GHUIViewControllerDropUp alloc] init];
    [self.navigationDelegate pushView:[self testView:item.title] animation:animation];
  } else if ([item.title isEqualToString:@"Modal (Bottom)"]) {
    GHUIContentView *view = [self testView:item.title];
    GHUIModalView *modalView = [[GHUIModalView alloc] initWithTitle:@"Title" navigationDelegate:self.navigationDelegate contentView:view];
    [self presentModalWithView:modalView insets:UIEdgeInsetsMake(30, 30, 30, 30) startPosition:GHUIViewControllerModalStartPositionBottom];
  } else if ([item.title isEqualToString:@"Modal (Right)"]) {
    [self presentModalWithView:[self testView:item.title] insets:UIEdgeInsetsMake(0, 60, 0, 0) startPosition:GHUIViewControllerModalStartPositionRight];
  } else if ([item.title isEqualToString:@"Modal (Left)"]) {
    [self presentModalWithView:[self testView:item.title] insets:UIEdgeInsetsMake(0, 0, 0, 60) startPosition:GHUIViewControllerModalStartPositionLeft];
  } else if ([item.title isEqualToString:@"Modal (Top)"]) {
    GHUIContentView *view = [self testView:item.title];
    [self presentModalWithView:view insets:UIEdgeInsetsMake(64, 0, 200, 0) startPosition:GHUIViewControllerModalStartPositionTop];
  } else if ([item.title isEqualToString:@"Slide"]) {
    GHUIViewControllerSlide3D *animation = [[GHUIViewControllerSlide3D alloc] init];
    [self.navigationDelegate pushView:[self testView:item.title] animation:animation];
  } else if ([item.title isEqualToString:@"Modal (Bottom+Nav)"]) {
    GHUIContentView *view = [self testView:item.title];
    id<GHUIViewNavigationDelegate> navigationDelegate = [self.navigationDelegate presentNavigationView:view animated:YES completion:NULL];
    navigationDelegate.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(_dismiss)];
  }
}

@end
