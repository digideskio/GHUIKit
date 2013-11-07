//
//  GHUIUtils.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/5/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHUIUtils : NSObject

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width multiline:(BOOL)multiline truncate:(BOOL)truncate;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size multiline:(BOOL)multiline truncate:(BOOL)truncate;

+ (void)drawText:(NSString *)text rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment multiline:(BOOL)multiline truncate:(BOOL)truncate;

@end
