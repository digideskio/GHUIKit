//
//  GHUICatalogButtons.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/5/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICatalogButtons.h"

#import <GHUIKit/GHUILabel.h>
#import <GHUIKit/GHUIButton.h>

@implementation GHUICatalogButtons

- (void)sharedInit {
  [super sharedInit];
  self.layout = [GHLayout layoutForView:self];
  self.navigationTitle = @"Buttons";
  
  _listView = [[GHUIListView alloc] init];
  _listView.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  _listView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
  _listView.viewType = GHUIListViewTypeVertical;
  
  GHUIButton *button = [[GHUIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
  button.text = @"Text";
  [_listView addView:button];
  
  GHUIButton *buttonDisabled = [[GHUIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
  buttonDisabled.enabled = NO;
  buttonDisabled.text = @"Text (Disabled)";
  [_listView addView:buttonDisabled];
  
  __weak typeof(self) blockSelf = self;
  
  //
  // Roughly in the style of bootstrap 2.x buttons
  //
  
  GHUIButton *defaultButton = [self button];
  defaultButton.text = @"Default";
  defaultButton.fillColor = [UIColor whiteColor];
  defaultButton.textColor = GHUIColorFromRGB(0x333333);
  defaultButton.borderColor = GHUIColorFromRGB(0xcccccc);
  defaultButton.highlightedFillColor = [UIColor colorWithWhite:203.0f/255.0f alpha:1.0];
  [_listView addView:defaultButton];
  defaultButton.targetBlock = ^(id sender) {
    GHUILabel *label = [self label];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"Default";
    label.textAlignment = NSTextAlignmentCenter;
    [blockSelf.navigationDelegate pushView:[GHUIContentView contentViewForView:label] animated:YES];
  };
  
  GHUIButton *primaryButton = [self button];
  primaryButton.text = @"Primary";
  primaryButton.textColor = [UIColor whiteColor];
  primaryButton.fillColor = GHUIColorFromRGB(0x428bca);
  primaryButton.borderColor = GHUIColorFromRGB(0x357ebd);
  primaryButton.highlightedFillColor = [UIColor colorWithRed:0.0f/255.0f green:60.0f/255.0f blue:180.0f/255.0f alpha:1.0];
  [_listView addView:primaryButton];
  
  GHUIButton *primaryDisabledButton = [self button];
  primaryDisabledButton.text = @"Primary (Disabled)";
  primaryDisabledButton.textColor = [UIColor whiteColor];
  primaryDisabledButton.fillColor = [UIColor colorWithRed:0.0f/255.0f green:133.0f/255.0f blue:204.0f/255.0f alpha:1.0];
  primaryDisabledButton.fillColor2 = [UIColor colorWithRed:0.0f/255.0f green:69.0f/255.0f blue:204.0f/255.0f alpha:1.0];
  primaryDisabledButton.borderColor = [UIColor colorWithRed:1.0f/255.0f green:82.0f/255.0f blue:154.0f/255.0f alpha:1.0];
  primaryDisabledButton.highlightedFillColor = [UIColor colorWithRed:0.0f/255.0f green:60.0f/255.0f blue:180.0f/255.0f alpha:1.0];
  primaryDisabledButton.highlightedFillColor2 = [UIColor colorWithRed:0.0f/255.0f green:68.0f/255.0f blue:204.0f/255.0f alpha:1.0];
  primaryDisabledButton.enabled = NO;
  [_listView addView:primaryDisabledButton];
  
  GHUIButton *infoButton = [self button];
  infoButton.text = @"Info";
  infoButton.textColor = [UIColor whiteColor];
  infoButton.fillColor = GHUIColorFromRGB(0x5bc0de);
  infoButton.borderColor = GHUIColorFromRGB(0x46b8da);
  infoButton.highlightedFillColor = [UIColor colorWithRed:41.0f/255.0f green:132.0f/255.0f blue:158.0f/255.0f alpha:1.0];
  [_listView addView:infoButton];
  
  GHUIButton *successButton = [self button];
  successButton.text = @"Success";
  successButton.textColor = [UIColor whiteColor];
  successButton.fillColor = GHUIColorFromRGB(0x5cb85c);
  successButton.borderColor = GHUIColorFromRGB(0x4cae4c);
  successButton.highlightedFillColor = [UIColor colorWithRed:71.0f/255.0f green:143.0f/255.0f blue:71.0f/255.0f alpha:1.0];
  [_listView addView:successButton];
  
  GHUIButton *warningButton = [self button];
  warningButton.text = @"Warning";
  warningButton.textColor = [UIColor whiteColor];
  warningButton.fillColor = GHUIColorFromRGB(0xf0ad4e);
  warningButton.borderColor = GHUIColorFromRGB(0xeea236);
  warningButton.highlightedFillColor = [UIColor colorWithRed:218.0f/255.0f green:130.0f/255.0f blue:5.0f/255.0f alpha:1.0];
  [_listView addView:warningButton];
  
  GHUIButton *dangerButton = [self button];
  dangerButton.text = @"Danger";
  dangerButton.textColor = [UIColor whiteColor];
  dangerButton.fillColor = GHUIColorFromRGB(0xd9534f);
  dangerButton.borderColor = GHUIColorFromRGB(0xd43f3a);
  dangerButton.highlightedFillColor = [UIColor colorWithRed:166.0f/255.0f green:47.0f/255.0f blue:41.0f/255.0f alpha:1.0];
  [_listView addView:dangerButton];
  
  GHUIButton *inverseButton = [self button];
  inverseButton.text = @"Inverse";
  inverseButton.textColor = [UIColor whiteColor];
  inverseButton.fillColor = [UIColor colorWithWhite:66.0f/255.0f alpha:1.0];
  inverseButton.fillColor2 = [UIColor colorWithWhite:35.0f/255.0f alpha:1.0];
  inverseButton.borderColor = [UIColor colorWithWhite:48.0f/255.0f alpha:1.0];
  inverseButton.highlightedFillColor = [UIColor colorWithWhite:30.0f/255.0f alpha:1.0];
  inverseButton.highlightedFillColor2 = [UIColor colorWithWhite:34.0f/255.0f alpha:1.0];
  [_listView addView:inverseButton];
  
  GHUIButton *disabledButton = [self button];
  disabledButton.text = @"Disabled";
  disabledButton.enabled = NO;
  [_listView addView:disabledButton];
  
  //
  // Other examples with icons, accessoryImages, borders
  //
  
  GHUIButton *button1 = [self button];
  button1.text = @"text (accessoryImage)";
  button1.textAlignment = NSTextAlignmentCenter;
  button1.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
  button1.accessoryImage = [UIImage imageNamed:@"ButtonAccessory"];
  button1.style.highlightedAccessoryImage = [UIImage imageNamed:@"ButtonAccessoryHighlighted"];
  [_listView addView:button1];
  
  GHUIButton *button2 = [self button];
  button2.text = @"text (Rounded top)";
  button2.borderStyle = GHUIBorderStyleRoundedTop;
  button2.cornerRadius = 6.0f;
  button2.borderWidth = 1.0f;
  [_listView addView:button2];
  
  GHUIButton *button3 = [self button];
  button3.text = @"text (Top left right)";
  button3.borderStyle = GHUIBorderStyleTopLeftRight;
  button3.cornerRadius = 6.0f;
  button3.borderWidth = 1.0f;
  [_listView addView:button3];
  
  GHUIButton *button4 = [self button];
  button4.text = @"text (Rounded bottom)";
  button4.borderStyle = GHUIBorderStyleRoundedBottom;
  button4.cornerRadius = 6.0f;
  button4.borderWidth = 1.0f;
  [_listView addView:button4];
  
  GHUIButton *button6 = [self button];
  button6.accessoryText = @"Accessory text";
  button6.textInsets = UIEdgeInsetsMake(0, 0, 0, 10);
  button6.accessoryTextFont = [UIFont systemFontOfSize:12];
  button6.accessoryTextColor = [UIColor blueColor];
  [_listView addView:button6];
  
  GHUIButton *button8 = [self button];
  button8.textAlignment = NSTextAlignmentLeft;
  button8.insets = UIEdgeInsetsMake(10, 20, 10, 20);
  button8.accessoryText = @"Accessory text (right align)";
  button8.accessoryTextAlignment = NSTextAlignmentRight;
  button8.accessoryTextFont = [UIFont systemFontOfSize:15];
  button8.accessoryTextColor = [UIColor grayColor];
  [_listView addView:button8];
  
  GHUIButton *button9a = [self button];
  button9a.text = @"Swag food truck excepteur";
  button9a.textAlignment = NSTextAlignmentLeft;
  button9a.secondaryText = @"Marfa lomo fixie salvia ethical";
  button9a.secondaryTextFont = [UIFont systemFontOfSize:14];
  [_listView addView:button9a];
  
  GHUIButton *button9b = [self button];
  button9b.text = @"Swag food truck excepteur freegan, tousled tofu post-ironic distillery";
  button9b.textAlignment = NSTextAlignmentLeft;
  button9b.secondaryText = @"Marfa lomo fixie salvia ethical culpa selvage. Art party whatever ennui banh mi Echo Park. Aesthetic Godard church-key mixtape pop-up";
  button9b.secondaryTextFont = [UIFont systemFontOfSize:14];
  [_listView addView:button9b];
  
  GHUILabel *errorView = [self label];
  errorView.text = @"Oops!";
  errorView.textAlignment = NSTextAlignmentCenter;
  errorView.font = [UIFont boldSystemFontOfSize:22.0f];
  errorView.textColor = [UIColor whiteColor];
  errorView.insets = UIEdgeInsetsMake(20.0f, 30.0f, 20.0f, 30.0f);
  errorView.textInsets = UIEdgeInsetsMake(0, 0, 20.0f, 0);
  errorView.secondaryText = @"Marfa lomo fixie salvia ethical culpa selvage. Art party whatever ennui banh mi Echo Park. Aesthetic Godard church-key mixtape pop-up";
  errorView.secondaryTextColor = [UIColor whiteColor];
  errorView.secondaryTextFont = [UIFont systemFontOfSize:14.0f];
  errorView.secondaryTextAlignment = NSTextAlignmentCenter;
  errorView.fillColor = [UIColor colorWithWhite:0.0f alpha:0.85f];
  errorView.cornerRadius = 10.0f;
  [_listView addView:errorView];
  
  GHUILabel *label = [self label];
  label.fillColor = [UIColor colorWithWhite:0.96 alpha:1.0];
  label.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  label.text = @"The text";
  label.secondaryText = @"Marfa lomo fixie salvia ethical culpa selvage";
  [_listView addView:label];
  
  GHUILabel *label2 = [self label];
  label2.text = @"The text";
  label2.textAlignment = NSTextAlignmentCenter;
  label2.secondaryText = @"Marfa lomo fixie salvia ethical culpa selvage (no backgroundColor or fillColor)";
  label2.secondaryTextAlignment = NSTextAlignmentCenter;
  label2.secondaryTextFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
  [_listView addView:label2];
  
  GHUILabel *label3 = [self label];
  label3.backgroundColor = [UIColor whiteColor];
  label3.borderColor = [UIColor colorWithWhite:245.0/255.0 alpha:1.0];
  label3.text = @"The text";
  label3.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  label3.secondaryText = @"This is a description";
  label3.secondaryTextFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
  label3.imageView.image = [UIImage imageNamed:@"Preview2"];
  label3.imageView.contentMode = UIViewContentModeTopLeft;
  label3.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  label3.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
  [_listView addView:label3];
  
  GHUIButton *buttonSecret = [[GHUIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
  buttonSecret.text = @"Secret";
  buttonSecret.textColor = GHUIColorFromRGB(0x333333);
  buttonSecret.font = [UIFont systemFontOfSize:16];
  buttonSecret.secondaryText = @"This is a secret room. A user just needs to know the name of the room in order to join.";
  buttonSecret.secondaryTextFont = [UIFont systemFontOfSize:14];
  buttonSecret.imageView.image = [UIImage imageNamed:@"Preview2"];
  buttonSecret.imageView.highlightedImage = [UIImage imageNamed:@"Preview2-Filled"];
  buttonSecret.imageView.contentMode = UIViewContentModeLeft;
  buttonSecret.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  buttonSecret.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
  [_listView addView:buttonSecret];
  
  // TODO: This is broken
  GHUILabel *statusLabel = [self label];
  statusLabel.backgroundColor = [UIColor whiteColor];
  statusLabel.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  statusLabel.text = @"Connecting...";
  statusLabel.textAlignment = NSTextAlignmentCenter;
  statusLabel.font = [UIFont systemFontOfSize:20.0];
  statusLabel.textColor = [UIColor blackColor];
  statusLabel.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  [statusLabel setActivityIndicatorAnimating:YES];
  [_listView addView:statusLabel];
  
  GHUIButton *imageButton = [self button];
  imageButton.frame = CGRectMake(20, 20, 100, 100);
  imageButton.text = @"Set Photo";
  imageButton.font = [UIFont systemFontOfSize:30.0];
  imageButton.textAlignment = NSTextAlignmentCenter;
  imageButton.cornerRadiusRatio = 1.0;
  imageButton.borderColor = [UIColor orangeColor];
  imageButton.backgroundImageView.image = [UIImage imageNamed:@"unsplash1.jpg"];
  imageButton.backgroundImageSize = imageButton.frame.size;
  imageButton.textColor = [UIColor whiteColor];
  [_listView addView:imageButton];
  
  GHUIButton *imageButton2 = [self button];
  imageButton2.frame = CGRectMake(20, 20, 100, 100);
  imageButton2.cornerRadiusRatio = 1.0;
  imageButton2.backgroundImageView.image = [UIImage imageNamed:@"unsplash1.jpg"];
  imageButton2.backgroundImageSize = imageButton2.frame.size;
  imageButton2.borderWidth = 0;
  imageButton2.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
  [imageButton2 setActivityIndicatorAnimating:YES];
  [_listView addView:imageButton2];
  
  GHUIButton *imageButton3 = [self button];
  imageButton3.frame = CGRectMake(20, 20, 80, 80);
  imageButton3.text = @"Set Photo";
  imageButton3.font = [UIFont systemFontOfSize:14.0];
  imageButton3.textAlignment = NSTextAlignmentCenter;
  imageButton3.cornerRadiusRatio = 1.0;
  imageButton3.borderColor = [UIColor grayColor];
  imageButton3.textColor = [UIColor blueColor];
  [_listView addView:imageButton3];
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.backgroundColor = [UIColor whiteColor];
  [self addSubview:_scrollView];
  [_scrollView addSubview:_listView];
}

- (GHUILabel *)label {
  GHUILabel *label = [[GHUILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
  return label;
}

- (GHUIButton *)button {
  GHUIButton *button = [[GHUIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
  button.backgroundColor = [UIColor clearColor];
  button.text = @"Text";
  button.textColor = GHUIColorFromRGB(0x333333);
  button.font = [UIFont boldSystemFontOfSize:15];
  button.fillColor = [UIColor whiteColor];
  button.borderColor = GHUIColorFromRGB(0xcccccc);
  button.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  button.borderStyle = GHUIBorderStyleRounded;
  button.cornerRadius = 4.0f;
  button.borderWidth = 1.0f;
  button.highlightedFillColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
  button.shadingType = GHUIShadingTypeLinear;
  button.highlightedShadingType = GHUIShadingTypeLinear;
  button.disabledShadingType = GHUIShadingTypeNone;
  button.disabledFillColor = [UIColor colorWithWhite:239.0f/255.0f alpha:1.0f];
  button.style.disabledTextColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
  button.style.disabledBorderColor = [UIColor colorWithWhite:216.0f/255.0f alpha:1.0f];
  return button;
}

- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
  [layout setFrame:CGRectMake(0, 0, size.width, size.height) view:_scrollView];
  
  CGFloat y = 0;
  CGRect listViewFrame = [layout setFrame:CGRectMake(0, y, size.width, 0) view:_listView sizeToFit:YES];
  y += listViewFrame.size.height;
  
  if (![layout isSizing]) {
    [_scrollView setContentSize:CGSizeMake(size.width, y)];
  }
  
  return CGSizeMake(size.width, size.height);
}

@end
