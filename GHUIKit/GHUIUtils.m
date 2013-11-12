//
//  GHUIUtils.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/5/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUIUtils.h"

@implementation GHUIUtils

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font {
  return [self sizeWithText:text font:font width:CGFLOAT_MAX];
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
  return [self sizeWithText:text font:font width:width multiline:YES truncate:NO];
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width multiline:(BOOL)multiline truncate:(BOOL)truncate {
  return [self sizeWithText:text font:font size:(CGSize){width, CGFLOAT_MAX} multiline:multiline truncate:truncate];
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size {
  return [self sizeWithText:text font:font size:size multiline:YES truncate:NO];
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size multiline:(BOOL)multiline truncate:(BOOL)truncate {
  if (!text) return CGSizeZero;
  NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
  NSStringDrawingOptions options = 0;
  if (multiline) options |= NSStringDrawingUsesLineFragmentOrigin;
  if (truncate) options |= NSStringDrawingTruncatesLastVisibleLine;
  CGRect rect = [attributedText boundingRectWithSize:size options:options context:nil];
  return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

+ (void)drawText:(NSString *)text rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment multiline:(BOOL)multiline truncate:(BOOL)truncate {
  NSStringDrawingOptions options = 0;
  if (multiline) options |= NSStringDrawingUsesLineFragmentOrigin;
  if (truncate) options |= NSStringDrawingTruncatesLastVisibleLine;
  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [paragraphStyle setAlignment:alignment];
  [text drawWithRect:rect options:options attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:color} context:nil];
}

@end
