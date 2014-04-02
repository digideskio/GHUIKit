//
//  GHUITableViewSwipeCell.m
//  GHUIKit
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITableViewSwipeCell.h"
#import "GHUICellButtonView.h"
#import "GHUILongPressGestureRecognizer.h"
#import "GHUITapGestureRecognizer.h"

@interface GHUITableViewSwipeCell ()
@property GHUICellScrollView *cellScrollView;
@property UIView *scrollViewContentView;
@property GHUICellButtonView *scrollViewButtonViewRight;
@property GHUICellButtonView *scrollViewButtonViewLeft;
@property (nonatomic) GHUITableViewSwipeState swipeState;
@property UITapGestureRecognizer *tapGestureRecognizer;
@property GHUILongPressGestureRecognizer *longPressGestureRecognizer;
@property UITableView *tableView;
@property BOOL showingSelection;
@end

@implementation GHUITableViewSwipeCell

- (void)setupContentView:(UIView *)contentView {
  self.scrollViewContentView = [[UIView alloc] init];
  self.scrollViewContentView.backgroundColor = [UIColor whiteColor];
  [self.scrollViewContentView addSubview:contentView];
  
  self.cellScrollView = [[GHUICellScrollView alloc] init];
  self.cellScrollView.delegate = self;
  self.cellScrollView.showsHorizontalScrollIndicator = NO;
  self.cellScrollView.scrollsToTop = NO;
  self.cellScrollView.scrollEnabled = YES;
  self.cellScrollView.backgroundColor = [UIColor whiteColor];
  [self.cellScrollView addSubview:self.scrollViewContentView];
  
  GHUICellButtonView *scrollViewButtonViewRight = [[GHUICellButtonView alloc] init];
  scrollViewButtonViewRight.backgroundColor = [UIColor purpleColor];
  [self.cellScrollView insertSubview:scrollViewButtonViewRight belowSubview:self.scrollViewContentView];
  self.scrollViewButtonViewRight = scrollViewButtonViewRight;
  
  [self.contentView addSubview:self.cellScrollView];
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewUp:)];
  tapGestureRecognizer.cancelsTouchesInView = NO;
  [self.cellScrollView addGestureRecognizer:tapGestureRecognizer];
  self.tapGestureRecognizer = tapGestureRecognizer;
  
  GHUILongPressGestureRecognizer *longPressGestureRecognizer = [[GHUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
  longPressGestureRecognizer.cancelsTouchesInView = NO;
  longPressGestureRecognizer.minimumPressDuration = 0.1;
  [self.cellScrollView addGestureRecognizer:longPressGestureRecognizer];
  self.longPressGestureRecognizer = longPressGestureRecognizer;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.cellScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  self.cellScrollView.contentOffset = CGPointMake(0, 0);
  self.cellScrollView.contentSize = CGSizeMake(self.frame.size.width + [self buttonsWidth], self.frame.size.height);
  
  self.scrollViewButtonViewLeft.frame = CGRectMake([self leftButtonsWidth], 0, 0, self.frame.size.height);

  self.scrollViewButtonViewRight.frame = CGRectMake(self.frame.size.width - [self rightButtonsWidth], 0, 0, self.frame.size.height);
  
  self.scrollViewContentView.frame = CGRectMake([self leftButtonsWidth], 0, self.frame.size.width, self.frame.size.height);
  
  self.showingSelection = NO;
}

- (void)setAppearanceWithBlock:(void (^)())appearanceBlock tableView:(UITableView *)tableView force:(BOOL)force {
  self.tableView = tableView;
  if (force) {
    appearanceBlock();
  } else {
    dispatch_once(&onceToken, ^{
      appearanceBlock();
    });
  }
}

- (void)setRightButtons:(NSArray *)rightButtons {
  _rightButtons = rightButtons;
  [self.scrollViewButtonViewRight setButtonViews:_rightButtons];
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (void)rightButtonHandler:(id)sender {
  NSInteger index = [(GHUITapGestureRecognizer *)sender index];
  [self.delegate tableViewSwipeCell:self didTriggerRightButtonWithIndex:index];
}

- (UIButton *)rightButtonWithColor:(UIColor *)color title:(NSString *)title index:(NSInteger)index {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.backgroundColor = color;
  [button setTitle:title forState:UIControlStateNormal];
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  GHUITapGestureRecognizer *tapGestureRecognizer = [[GHUITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonHandler:)];
  tapGestureRecognizer.index = index;
  [button addGestureRecognizer:tapGestureRecognizer];
  return button;
}

- (void)hideUtilityButtonsAnimated:(BOOL)animated {
  if (self.swipeState == GHUITableViewSwipeStateDefault) return;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.cellScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
  });
  self.swipeState = GHUITableViewSwipeStateDefault;
}

- (CGFloat)rightButtonsWidth {
  return [self.scrollViewButtonViewRight sizeThatFits:self.frame.size].width;
}

- (CGFloat)leftButtonsWidth {
  return 0;
}

- (CGFloat)buttonsWidth {
  return [self rightButtonsWidth] + [self leftButtonsWidth];
}

- (void)scrollToRight:(inout CGPoint *)contentOffset {
  contentOffset->x = [self rightButtonsWidth];
  self.swipeState = GHUITableViewSwipeStateRight;
  
  self.longPressGestureRecognizer.enabled = NO;
  self.tapGestureRecognizer.enabled = NO;
}

- (void)scrollToCenter:(inout CGPoint *)contentOffset {
  contentOffset->x = 0;
  self.swipeState = GHUITableViewSwipeStateDefault;
  
  self.longPressGestureRecognizer.enabled = YES;
  self.tapGestureRecognizer.enabled = NO;
}

- (void)scrollToLeft:(inout CGPoint *)contentOffset {
  contentOffset->x = 0;
  self.swipeState = GHUITableViewSwipeStateLeft;
  
  self.longPressGestureRecognizer.enabled = NO;
  self.tapGestureRecognizer.enabled = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
  switch (self.swipeState) {
    case GHUITableViewSwipeStateDefault:
      if (velocity.x >= 0.5f) {
        [self scrollToRight:targetContentOffset];
      } else if (velocity.x <= -0.5f) {
        [self scrollToLeft:targetContentOffset];
      } else {
        CGFloat rightThreshold = [self buttonsWidth] - ([self rightButtonsWidth] / 2);
        CGFloat leftThreshold = [self leftButtonsWidth] / 2;
        if (targetContentOffset->x > rightThreshold) {
          [self scrollToRight:targetContentOffset];
        } else if (targetContentOffset->x < leftThreshold) {
          [self scrollToLeft:targetContentOffset];
        } else {
          [self scrollToCenter:targetContentOffset];
        }
      }
      break;
    case GHUITableViewSwipeStateLeft:
      if (velocity.x >= 0.5f) {
        [self scrollToCenter:targetContentOffset];
      } else if (velocity.x <= -0.5f) {
        // No-op
      } else {
        if (targetContentOffset->x >= ([self buttonsWidth] - [self rightButtonsWidth] / 2)) {
          [self scrollToRight:targetContentOffset];
        } else if (targetContentOffset->x > [self leftButtonsWidth] / 2) {
          [self scrollToCenter:targetContentOffset];
        } else {
          [self scrollToLeft:targetContentOffset];
        }
      }
      break;
    case GHUITableViewSwipeStateRight:
      if (velocity.x >= 0.5f) {
        // No-op
      } else if (velocity.x <= -0.5f) {
        [self scrollToCenter:targetContentOffset];
      } else {
        if (targetContentOffset->x <= [self leftButtonsWidth] / 2) {
          [self scrollToLeft:targetContentOffset];
        } else if (targetContentOffset->x < ([self buttonsWidth] - [self rightButtonsWidth] / 2)) {
          [self scrollToCenter:targetContentOffset];
        } else {
          [self scrollToRight:targetContentOffset];
        }
      }
      break;
    default:
      break;
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  self.tapGestureRecognizer.enabled = NO;
  if (scrollView.contentOffset.x > [self leftButtonsWidth]) {
    if ([self rightButtonsWidth] > 0) {
      CGFloat scrollViewWidth = MIN(scrollView.contentOffset.x - [self leftButtonsWidth], [self rightButtonsWidth]);
      
      self.scrollViewButtonViewRight.frame = CGRectMake(scrollView.contentOffset.x + (self.frame.size.width - scrollViewWidth), 0.0f, scrollViewWidth, self.frame.size.height);
      
      CGRect scrollViewBounds = self.scrollViewButtonViewRight.bounds;
      scrollViewBounds.origin.x = MAX([self rightButtonsWidth] - scrollViewWidth, [self rightButtonsWidth] - scrollView.contentOffset.x);
      self.scrollViewButtonViewRight.bounds = scrollViewBounds;
    } else {
      [scrollView setContentOffset:CGPointMake([self leftButtonsWidth], 0)];
      self.tapGestureRecognizer.enabled = YES;
    }
  } else {
    if ([self leftButtonsWidth] > 0) {
      CGFloat scrollViewWidth = MIN(scrollView.contentOffset.x - [self leftButtonsWidth], [self leftButtonsWidth]);
      self.scrollViewButtonViewLeft.frame = CGRectMake([self leftButtonsWidth], 0.0f, scrollViewWidth, self.frame.size.height);

    } else {
      [scrollView setContentOffset:CGPointMake(0, 0)];
      self.tapGestureRecognizer.enabled = YES;
    }
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self updateSwipeState];
  self.tapGestureRecognizer.enabled = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  [self updateSwipeState];
  self.tapGestureRecognizer.enabled = YES;
  if (self.swipeState == GHUITableViewSwipeStateDefault) {
    self.longPressGestureRecognizer.enabled = YES;
  }
}

- (void)updateSwipeState {
  if ([self.cellScrollView contentOffset].x == [self leftButtonsWidth]) {
    self.swipeState = GHUITableViewSwipeStateDefault;
  } else if ([self.cellScrollView contentOffset].x == 0) {
    self.swipeState = GHUITableViewSwipeStateLeft;
  } else if ([self.cellScrollView contentOffset].x == [self rightButtonsWidth]) {
    self.swipeState = GHUITableViewSwipeStateRight;
  }
  NSLog(@"Swipe state: %d", (int)self.swipeState);
}

- (void)setSwipeState:(GHUITableViewSwipeState)swipeState {
  _swipeState = swipeState;
  //NSLog(@"Swipe state: %d", _swipeState);
}

#pragma mark Selection

- (void)scrollViewPressed:(id)sender {
  GHUILongPressGestureRecognizer *longPressGestureRecognizer = (GHUILongPressGestureRecognizer *)sender;
  if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
    // Gesture recognizer ended without failing so we select the cell
    [self selectCell];
    [self setSelected:NO];
  } else {
    // Handle the highlighting of the cell
    if (self.isHighlighted) {
      [self setHighlighted:NO];
    } else {
      [self highlightCell];
    }
  }
}

- (void)scrollViewUp:(id)sender {
  [self selectCellWithTimedHighlight];
}

- (void)selectCell {
  if (self.swipeState == GHUITableViewSwipeStateDefault) { 
    if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
      NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
      [self.tableView selectRowAtIndexPath:cellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
      [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:cellIndexPath];
      [self.tableView deselectRowAtIndexPath:cellIndexPath animated:NO];
    }
  }
}

- (void)selectCellWithTimedHighlight {
  if (self.swipeState == GHUITableViewSwipeStateDefault) {
    if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
      NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
      self.showingSelection = YES;
      [self setSelected:YES];
      [self.tableView selectRowAtIndexPath:cellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
      [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:cellIndexPath];
      NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.20 target:self selector:@selector(timerEndCellHighlight:) userInfo:nil repeats:NO];
      [[NSRunLoop currentRunLoop] addTimer:endHighlightTimer forMode:NSRunLoopCommonModes];
    }
  } else {
    [self hideUtilityButtonsAnimated:YES];
  }
}

- (void)highlightCell {
  if (self.swipeState == GHUITableViewSwipeStateDefault) {
    [self setHighlighted:YES];
  }
}

- (void)timerEndCellHighlight:(id)sender {
  self.showingSelection = NO;
  [self setSelected:NO];
}

#pragma mark -

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [super setBackgroundColor:backgroundColor];
  self.scrollViewContentView.backgroundColor = backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted animated:NO];
  self.scrollViewButtonViewLeft.hidden = highlighted;
  self.scrollViewButtonViewRight.hidden = highlighted;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  [super setHighlighted:highlighted animated:animated];
  self.scrollViewButtonViewLeft.hidden = highlighted;
  self.scrollViewButtonViewRight.hidden = highlighted;
}

- (void)setSelected:(BOOL)selected {
  [self updateHighlight:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [self updateHighlight:selected animated:animated];
}

- (void)updateHighlight:(BOOL)highlight animated:(BOOL)animated {
  if (highlight) {
    [self setHighlighted:YES animated:animated];
  } else {
    // We are unhighlighting
    if (!self.showingSelection) {
      // Make sure we only deselect if we are done showing the selection with a highlight
      [self setHighlighted:NO];
    }
  }
}

@end


@implementation GHUICellScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  // Find out if the user is actively scrolling the tableView of which this is a member.
  // If they are, return NO, and don't let the gesture recognizers work simultaneously.
  //
  // This works very well in maintaining user expectations while still allowing for the user to
  // scroll the cell sideways when that is their true intent.
  if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
    
    // Find the current scrolling velocity in that view, in the Y direction.
    CGFloat yVelocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:gestureRecognizer.view].y;
    
    // Return YES iff the user is not actively scrolling up.
    return fabs(yVelocity) <= 0.25;
    
  }
  return YES;
}

@end

