//
//  GHUIView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHLayout.h"

typedef void (^GHUIViewSubviewNeedsLayoutBlock)(UIView *view, BOOL animated);

/*!
 View with custom, programatic layout (via GHLayout).
 
 Instead of subclassing UIView, you can subclass GHUIView and implement
 sharedInit and layout:size:. See GHLayout for more details.
 
 
      - (void)sharedInit {
         [super sharedInit];
         self.layout = [GHLayout layoutForView:self];
         self.backgroundColor = [UIColor whiteColor];
      }
 
      - (CGSize)layout:(id<GHLayout>)layout size:(CGSize)size {
         [layout setFrame:CGRectMake(0, 0, size.width, 30)];
         return CGSizeMake(size.width, 30);
      }
 
 
 */
@interface GHUIView : UIView <GHLayoutView> { }

@property GHLayout *layout;
@property (copy) GHUIViewSubviewNeedsLayoutBlock needsLayoutBlock;

/*!
 Subclasses can override this method to perform initialization tasks that occur during both initWithFrame: and initWithCoder:
 */
- (void)sharedInit;

/*!
 Set if needs refresh.
 If visible, will immediately trigger refresh. Otherwise will call refresh when becoming visible.
 */
@property BOOL needsRefresh;

/*!
 Force the layout, if using GHLayout.
 You can use this instead of setNeedsLayout + layoutIfNeeded.
 This is also useful when using animations and setNeedsLayout + layoutIfNeeded don't work as expected.
 */
- (void)layoutView;

/*!
 Calls needsLayoutBlock, in the case where you want to make the superview trigger an layout update.
 @param animated YES if the layout should animate
 */
- (void)notifyNeedsLayout:(BOOL)animated;

#pragma mark Attributes

/*!
 Add a list of attributed that will call setNeedsDisplay and setNeedsLayout on change.
 */
- (void)setAttributesNeedUpdate:(NSArray *)attributes;

#pragma mark Refresh

- (void)refresh;

- (void)refreshIfNeeded;

@end
