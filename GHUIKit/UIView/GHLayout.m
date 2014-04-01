//
//  GHLayout.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHLayout.h"
#import <GHKit/GHCGUtils.h>

@implementation GHLayout

- (id)init {
  [NSException raise:NSDestinationInvalidException format:@"Layout must be associated with a view; Use initWithView:"];
  return nil;
}

- (id)initWithView:(UIView *)view {
  if ((self = [super init])) {
    
    if (![view respondsToSelector:@selector(layout:size:)]) {
      [NSException raise:NSObjectNotAvailableException format:@"Layout is not supported for this view. Implement layout:size:."];
      return nil;
    }
    
    _view = view;
    _needsLayout = YES;
    _needsSizing = YES;
  }
  return self;
}

+ (GHLayout *)layoutForView:(UIView *)view {
  return [[GHLayout alloc] initWithView:view];
}

- (CGSize)_layout:(CGSize)size sizing:(BOOL)sizing {
  if (!_view) return size;
  
  // Disable caching
//  if (GHCGSizeIsEqual(size, _cachedSize) && ((!_needsSizing && sizing) || (!_needsLayout && !sizing))) {
//    return _cachedLayoutSize;
//  }
  
  _sizing = sizing;
  _cachedSize = size;
  CGSize layoutSize = [(id<GHLayoutView>)_view layout:self size:size];
  _cachedLayoutSize = layoutSize;
  if (!_sizing) {
    _needsLayout = NO;
  }
  _needsSizing = NO;
  _sizing = NO;
  return layoutSize;
}

- (void)setNeedsLayout {
  _needsLayout = YES;
  _needsSizing = YES;
  _cachedSize = CGSizeZero;
}

- (CGSize)layoutSubviews:(CGSize)size {
  CGSize layoutSize = [self _layout:size sizing:NO];
  for (id view in _subviews) {
    if ([view respondsToSelector:@selector(layoutIfNeeded)]) [view layoutIfNeeded];
  }
  return layoutSize;
}

- (CGSize)sizeThatFits:(CGSize)size {
  if (_sizeThatFits.width > 0 && _sizeThatFits.height > 0) return _sizeThatFits;
  if (_sizeThatFits.width > 0) size = _sizeThatFits;
  return [self _layout:size sizing:YES];
}

- (CGRect)setFrame:(CGRect)frame view:(id)view sizeToFit:(BOOL)sizeToFit {
  return [self setFrame:frame view:view options:(sizeToFit ? GHLayoutOptionsSizeToFit : 0)];
}

- (CGRect)setFrame:(CGRect)frame view:(id)view options:(GHLayoutOptions)options {
  return [self setFrame:frame inRect:CGRectZero view:view options:options];
}

- (CGRect)setFrameInRect:(CGRect)inRect view:(id)view {
  CGSize sizeThatFits = [view sizeThatFits:CGSizeMake(inRect.size.width, inRect.size.height)];
  inRect.size.height = sizeThatFits.height;
  return [self setFrame:CGRectMake(0, 0, sizeThatFits.width, sizeThatFits.height) inRect:inRect view:view options:GHLayoutOptionsCenter];
}

- (CGRect)setFrame:(CGRect)frame inRect:(CGRect)inRect view:(id)view options:(GHLayoutOptions)options {
  CGRect originalFrame = frame;
  BOOL sizeToFit = ((options & GHLayoutOptionsSizeToFit) == GHLayoutOptionsSizeToFit)
  || ((options & GHLayoutOptionsVariableWidth) == GHLayoutOptionsVariableWidth)
  || ((options & GHLayoutOptionsSizeToFitConstrainSizeMaintainAspectRatio) == GHLayoutOptionsSizeToFitConstrainSizeMaintainAspectRatio);
  
  CGSize sizeThatFits = CGSizeZero;
  if (sizeToFit) {
    sizeThatFits = [view sizeThatFits:frame.size];
    
    // If size that fits returns a larger width, then we'll need to constrain it.
    if (((options & GHLayoutOptionsSizeToFitConstrainWidth) == GHLayoutOptionsSizeToFitConstrainWidth) && sizeThatFits.width > frame.size.width) {
      sizeThatFits.width = frame.size.width;
    }
    
    // If size that fits returns a larger width or height, constrain it, but also maintain the aspect ratio from sizeThatFits
    if (((options & GHLayoutOptionsSizeToFitConstrainSizeMaintainAspectRatio) == GHLayoutOptionsSizeToFitConstrainSizeMaintainAspectRatio) && (sizeThatFits.height > frame.size.height || sizeThatFits.width > frame.size.width)) {
      CGFloat aspectRatio = sizeThatFits.width / sizeThatFits.height;
      // If we're going to constrain by width
      if (sizeThatFits.width / frame.size.width > sizeThatFits.height / frame.size.height) {
        sizeThatFits.width = frame.size.width;
        sizeThatFits.height = roundf(frame.size.width / aspectRatio);
        // If we're going to constrain by height
      } else {
        sizeThatFits.height = frame.size.height;
        sizeThatFits.width = roundf(frame.size.height * aspectRatio);
      }
    }
    
    if (sizeThatFits.width == 0 && ((options & GHLayoutOptionsSizeToFitDefaultSize) == GHLayoutOptionsSizeToFitDefaultSize)) {
      sizeThatFits.width = frame.size.width;
    }
    
    if (sizeThatFits.height == 0 && ((options & GHLayoutOptionsSizeToFitDefaultSize) == GHLayoutOptionsSizeToFitDefaultSize)) {
      sizeThatFits.height = frame.size.height;
    }
    
    // If size that fits returns different width than passed in, it can cause weirdness when sizeToFit is called multiple times in succession.
    // Here we assert the size passed into sizeThatFits returns the same width, unless you explicitly override this behavior.
    // This is because most views are sized based on a width. If you had a view (a button, for example) with a variable width, then you should specify the
    // GHLayoutOptionsVariableWidth to override this check.
    // This check only applies to GHUIView subclasses.
    if (((options & GHLayoutOptionsVariableWidth) != GHLayoutOptionsVariableWidth)
        && ((options & GHLayoutOptionsSizeToFitConstrainSizeMaintainAspectRatio) != GHLayoutOptionsSizeToFitConstrainSizeMaintainAspectRatio)
        && ((options & GHLayoutOptionsFixedWidth) != GHLayoutOptionsFixedWidth)
        && sizeThatFits.width != frame.size.width && [view conformsToProtocol:@protocol(GHLayoutView)]) {
      NSAssert(NO, @"sizeThatFits: returned width different from passed in width. If you have a variable width view, you can pass in the option GHLayoutOptionsVariableWidth to avoid this check.");
    }
    
    if (frame.size.width > 0 && (options & GHLayoutOptionsVariableWidth) != GHLayoutOptionsVariableWidth) {
      NSAssert(sizeThatFits.width > 0, @"sizeThatFits: on view returned 0 width; Make sure that layout:size: doesn't return a zero width size");
    }
    
    frame.size = sizeThatFits;
  }
  
  if ((options & GHLayoutOptionsFixedWidth) == GHLayoutOptionsFixedWidth) {
    frame.size.width = originalFrame.size.width;
  }
  
  if ((options & GHLayoutOptionsFixedHeight) == GHLayoutOptionsFixedHeight) {
    frame.size.height = originalFrame.size.height;
  }

  
  CGSize sizeForAlign = frame.size;
  CGRect rect = originalFrame;
  if (!CGRectIsEmpty(inRect)) rect = inRect;
  
  if ((options & GHLayoutOptionsCenter) == GHLayoutOptionsCenter) {
    frame = GHCGRectToCenterInRect(sizeForAlign, rect);
  }
  
  if ((options & GHLayoutOptionsCenterVertical) == GHLayoutOptionsCenterVertical) {
    frame = GHCGRectToCenterYInRect(frame, originalFrame);
  }
  
  if ((options & GHLayoutOptionsRightAlign) == GHLayoutOptionsRightAlign) {
    frame = GHCGRectRightAlignWithRect(frame, rect);
  }
  
  [self setFrame:frame view:view];
  return frame;
}

- (CGRect)setX:(CGFloat)x frame:(CGRect)frame view:(id)view {
  frame.origin.x = x;
  return [self setFrame:frame view:view needsLayout:NO];
}

- (CGRect)setY:(CGFloat)y frame:(CGRect)frame view:(id)view {
  frame.origin.y = y;
  return [self setFrame:frame view:view needsLayout:NO];
}

- (CGRect)setOrigin:(CGPoint)origin frame:(CGRect)frame view:(id)view {
  frame.origin = origin;
  if (GHCGRectIsEqual(frame, [view frame])) return frame;
  return [self setFrame:frame view:view needsLayout:NO];
}

- (CGRect)setOrigin:(CGPoint)origin view:(id)view {
  return [self setOrigin:origin frame:(view ? [view frame] : CGRectZero) view:view];
}

- (CGRect)setSize:(CGSize)size view:(id)view {
  return [self setFrame:CGRectMake([view frame].origin.x, [view frame].origin.y, size.width, size.height) view:view];
}

- (CGRect)setY:(CGFloat)y view:(id)view {
  return [self setY:y frame:(view ? [view frame] : CGRectZero) view:view];
}

- (CGRect)setFrame:(CGRect)frame view:(id)view {
  return [self setFrame:frame view:view needsLayout:YES];
}

- (CGRect)setFrame:(CGRect)frame view:(id)view needsLayout:(BOOL)needsLayout {
  if (!view) return CGRectZero;
  if (!_sizing) {
    [view setFrame:frame];
    // Since we are applying the frame, the subview will need to
    // apply their layout next at this frame
    if (needsLayout) [view setNeedsLayout];
  }
  return frame;
}

- (void)addSubview:(id)view {
#if YP_DEBUG
  if (![view respondsToSelector:@selector(drawInRect:)]) {
    [NSException raise:NSInvalidArgumentException format:@"Subview should implement the method - (void)drawInRect:(CGRect)rect;"];
    return;
  }
  if (![view respondsToSelector:@selector(frame)]) {
    [NSException raise:NSInvalidArgumentException format:@"Subview should implement the method - (CGRect)frame;"];
    return;
  }
#endif
  if (!_subviews) _subviews = [[NSMutableArray alloc] init];
  [_subviews addObject:view];
}

- (void)clear {
  _view = nil;
  [_subviews removeAllObjects];
}

- (void)removeSubview:(id)view {
  [_subviews removeObject:view];
}

- (void)drawSubviewsInRect:(CGRect)rect {
  for (id view in _subviews) {
    BOOL isHidden = NO;
    if ([view respondsToSelector:@selector(isHidden)]) {
      isHidden = [view isHidden];
    }
    
    if (!isHidden) {
      [view drawInRect:CGRectOffset([view frame], rect.origin.x, rect.origin.y)];
    }
  }
}

void GHLayoutAssert(UIView *view, GHLayout *layout) {
#if DEBUG
  BOOL hasLayoutMethod = ([view respondsToSelector:@selector(layout:size:)]);
  
  if (hasLayoutMethod && !layout) {
    [NSException raise:NSObjectNotAvailableException format:@"Missing layout instance for %@", view];
  }
  if (!hasLayoutMethod && layout) {
    [NSException raise:NSObjectNotAvailableException format:@"Missing layout:size: for %@", view];
  }
#endif
}

@end

