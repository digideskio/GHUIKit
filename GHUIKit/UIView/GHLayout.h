//
//  GHLayout.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef enum {
  GHLayoutOptionsSizeToFit = 1 << 0, // Size to fit the view
  GHLayoutOptionsVariableWidth = 1 << 1,
  
  // Alignment
  // Center the view in the specified size (horizontal + vertical). If you use this with GHLayoutOptionsSizeToFit then the origin width is maintained.
  GHLayoutOptionsCenter = 1 << 2,
  GHLayoutOptionsCenterVertical = 1 << 3, // Center vertically
  GHLayoutOptionsRightAlign = 1 << 4, // After sizing, aligns the view with the right of the passed in rect
  
  // Whether sizeToFit is constrained to the width specified.
  // For example UILabel sizeToFit may return a larger width than was specified,
  // and this will constrain it.
  GHLayoutOptionsSizeToFitConstrainWidth = 1 << 8,
  
  // Whether the size specified is the default. Using this option will
  // use the specified width and/or height (if not 0) when the sizeToFit
  // returns a 0 width.
  // This is useful for an image view that has to load its data and may
  // initially return 0 for sizeThatFits.
  // This option is only available when using
  GHLayoutOptionsSizeToFitDefaultSize = 1 << 9,
  
  // Whether sizeToFit is constrained to the size specified.
  // This is useful for an image view that may need to be constrained to a max
  // size, but still maintain its aspect ratio.
  GHLayoutOptionsSizeToFitConstrainSizeMaintainAspectRatio = 1 << 10,
  
  // Whether width specified will be set as the width. Using this option will
  // use the specified width regardless of the width returned by sizeThatFits.
  GHLayoutOptionsFixedWidth = 1 << 11,
  // Whether width specified will be set as the height. Using this option will
  // use the specified width regardless of the height returned by sizeThatFits.
  GHLayoutOptionsFixedHeight = 1 << 12,
  
} GHLayoutOptions;

@protocol GHLayoutView;
/*!
 Informal protocol for views laid out by GHLayout.
 */
@protocol GHLView <GHLayoutView>

@property (assign, nonatomic) CGRect frame;

- (void)setNeedsLayout;

@end


@protocol GHLayout <NSObject>

/*!
 Layout the subviews.
 
 @param size Size to layout in
 */
- (CGSize)layoutSubviews:(CGSize)size;

/*!
 Size that fits.
 
 @param size Size to layout in; Should have a width specified.
 @result The size needed to display the view
 */
- (CGSize)sizeThatFits:(CGSize)size;

/*!
 Set frame for the (sub)view.
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 
 @param frame Frame
 @param view View should conform to GHLView informal protocol.
 */
- (CGRect)setFrame:(CGRect)frame view:(id)view;

/*!
 Set frame for the (sub)view.
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 
 @param frame Frame
 @param view View should conform to GHLView informal protocol.
 @param needsLayout If YES, calls setNeedsLayout on view.
 */
- (CGRect)setFrame:(CGRect)frame view:(id)view needsLayout:(BOOL)needsLayout;

/*!
 Set the (sub)view frame, then size to fit the view.
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param frame Frame
 @param view View should conform to GHLView informal protocol.
 @param sizeToFit Size to fit
 @result The view frame.
 */
- (CGRect)setFrame:(CGRect)frame view:(id)view sizeToFit:(BOOL)sizeToFit;

/*!
 Set the (sub)view frame.
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param frame Frame
 @param view View should conform to GHLView informal protocol.
 @param options Options for setFrame; See GHLayoutOptions for more info
 @result The view frame.
 */
- (CGRect)setFrame:(CGRect)frame view:(id)view options:(GHLayoutOptions)options;

/*!
 Set the (sub)view frame.
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param frame Frame
 @param inRect Rect to optionally position in for GHLayoutOptionsCenter, GHLayoutOptionsCenterVertical, GHLayoutOptionsRightAlign, etc.
 @param view View
 @param options Options for setFrame; See GHLayoutOptions for more info
 @result The view frame.
 */
- (CGRect)setFrame:(CGRect)frame inRect:(CGRect)inRect view:(id)view options:(GHLayoutOptions)options;

/*!
 Set the (sub)view frame.
 Calls sizeThatFits on the view and then centers it. If inRect.height == 0, we only center horizontally.
 @param inRect The containing rectangle.
 @param view View
 */
- (CGRect)setFrameInRect:(CGRect)inRect view:(id)view;

/*!
 Set origin.
 */
- (CGRect)setOrigin:(CGPoint)origin view:(id)view;
- (CGRect)setOrigin:(CGPoint)origin view:(id)view sizeToFit:(BOOL)sizeToFit;

/*!
 Set size.
 */
- (CGRect)setSize:(CGSize)size view:(id)view;
- (CGRect)setSize:(CGSize)size view:(id)view sizeToFit:(BOOL)sizeToFit;

/*!
 Set origin, x position.
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param x X position
 @param frame Frame
 @param view View should conform to GHLView informal protocol.
 @result The view frame.
 */
- (CGRect)setX:(CGFloat)x frame:(CGRect)frame view:(id)view;

/*!
 Set origin, y position.
 
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param y Y position
 @param frame Frame
 @param view View should conform to GHLView informal protocol.
 @result The view frame.
 */
- (CGRect)setY:(CGFloat)y frame:(CGRect)frame view:(id)view;

/*!
 @deprecated Use setY:frame:view:
 */
- (CGRect)setY:(CGFloat)y view:(UIView *)view;

/*!
 If layout is required. Otherwise cached value may be returned.
 This should be called when a views data changes.
 */
- (void)setNeedsLayout;

/*!
 For subclasses, in rare cases, if they need to know whether the layout will
 be applied or not via setFrame:view:
 
 @result YES if we are only sizing, NO if we are setting frames
 */
- (BOOL)isSizing;

@end


/*
 UIViews can implement this protocol, to enable custom layouts.
 */
@protocol GHLayoutView <NSObject>

/*!
 Layout object belonging to the class implementing this protocol.
 */
@property id <GHLayout>layout;

@optional

/*!
 Layout or size the current view, with the specified size as a hint.
 Return the size used. The returned size.width should match the width that was
 passed in.
 
 You should never setFrame on subviews in this method. Instead use the methods
 in layout in order to setFrame, and use what those methods return to layout other
 subviews. This is because setFrame calls are no-ops when the view is only sizing.
 
 This method must be implemented if self.layout is not nil.
 
 @param layout Layout
 @param size Size to layout in
 */
- (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size;

@end

/*!
 Subviews added to GHLayout need to implement these methods.
 */
@protocol GHLayoutDrawable <NSObject>

/*!
 @result Size of drawable
 */
- (CGRect)frame;

/*!
 @result Whether drawable is hidden
 */
- (BOOL)isHidden;

/*!
 @result Set needs layout
 */
- (void)layoutIfNeeded;

/*!
 @result Draw the drawable
 */
- (void)drawInRect:(CGRect)rect;

@end


/*!
 GHLayout is a way to size and layout views without having to implement layoutSubview and
 sizeToFit separately.
 
 It also provides a basic cache to avoid layout when the view is unchanged.
 
 GHLayout calculates a size that best fits the receiver’s subviews,
 without altering the subviews frames, or affecting layoutSubviews call hierarchy.
 
 Instead of defining both sizeThatFits: and layoutSubviews, you define a single method called:
 
 - (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size;
 
 Then in this method you use the layout instance to set the subview frames (if sizing).
 
 This prevents your code from altering subviews when you are sizing (for sizeThatFits:).
 
 For example,
 
 CGRect titleLabelFrame = [layout setFrame:CGRectMake(x, y, 400, 0) view:_titleLabel options:GHLayoutOptionsSizeToFit];
 // titleLabelFrame may have a different width and will have a valid height
 
 You can combine GHLayoutOptionsSizeToFit and GHLayoutOptionsCenter to have it be centered with a variable height.
 For example,
 
 CGRect titleLabelFrame = [layout setFrame:CGRectMake(x, y, 400, 0) view:_titleLabel options:GHLayoutOptionsSizeToFit|GHLayoutOptionsCenter];
 // titleLabelFrame may have a different width and will have a valid height and will have an x position so it is centered
 
 You can also combine GHLayoutOptionsSizeToFit with GHLayoutOptionsConstraintWidth
 to make sure the width isn't set larger than expected. For example,
 
 CGRect titleLabelFrame = [layout setFrame:CGRectMake(x, y, 400, 0) view:_titleLabel options:GHLayoutOptionsSizeToFit|GHLayoutOptionsConstraintWidth];
 // titleLabelFrame may have a different width but it won't be larger than 400
 
 You can combine GHLayoutOptionsSizeToFit, GHLayoutOptionsConstraintWidth, and GHLayoutOptionsDefaultWidth to make sure
 a view sizes to fit with max and default width (when 0).
 */
@interface GHLayout : NSObject <GHLayout> {
  
  BOOL _needsLayout;
  BOOL _needsSizing;
  CGSize _cachedSize;
  CGSize _cachedLayoutSize;
  
  NSMutableArray *_subviews; // For manual subview handling
  
  CGSize _sizeThatFits;
}

@property (readonly, nonatomic, getter=isSizing) BOOL sizing;
@property (weak) UIView *view;

/*!
 Set a custon/fixed size that fits.
 Override the size that is returned by sizeThatFits:(CGSize)size.
 Defaults to CGSizeZero, which is unset.
 If height is not set (is 0), then we will use this size value for sizeThatFits:.
 */
@property (assign, nonatomic) CGSize sizeThatFits;

/*!
 Create layout for view.
 
 @param view View for layout (weak reference).
 */
- (id)initWithView:(UIView *)view;

/*!
 Default layout.
 @param view View for layout (weak reference).
 @result Layout
 */
+ (GHLayout *)layoutForView:(UIView *)view;

/*!
 Add subview.
 
 Call GHLayout#drawSubviews in the superview drawRect: method to
 draw GHLayout managed subviews.
 
 Subviews managed by the layout don't automatically handle re-display,
 or touches. Layout managed subviews are intended for simple views
 or views in table view cells that need better scrolling performance.
 For resizing you may need to adjust the contentMode.
 
 @param view View to add. Must respond to:
 drawInRect:(CGRect)rect
 (CGRect)frame
 */
- (void)addSubview:(id)view;

/*!
 Remove subview.
 
 @param view View to remove
 */
- (void)removeSubview:(id)view;

/*!
 Draw subviews that were added.
 Each view is drawn at their view frame.
 
 @param rect Offset to draw in; TODO(gabe): Use rect.size?
 */
- (void)drawSubviewsInRect:(CGRect)rect;

/*!
 Remove view reference and all subviews.
 */
- (void)clear;

/*!
 Assert layout parameters are correct.
 */
void GHLayoutAssert(UIView *view, id<GHLayout> layout);

@end
