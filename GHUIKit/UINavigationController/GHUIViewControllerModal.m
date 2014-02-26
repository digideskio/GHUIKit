// From VCTransitions project

#import "GHUIViewControllerModal.h"

@interface GHUIViewControllerModal ()
@property UIView *coverView;
@property NSArray *constraints;
@end

@implementation GHUIViewControllerModal

- (id)init {
  if ((self = [super init])) {
    _insets = UIEdgeInsetsMake(30, 30, 30, 30);
  }
  return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIView *containerView = [transitionContext containerView];
  
  if (self.animationType == GHUIViewControllerAnimationTypePresent) {
    UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    if (!_coverView) _coverView = [[UIView alloc] init];

    _coverView.alpha = 0.0;
    _coverView.frame = containerView.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:self.shadowAlpha];
    [containerView addSubview:_coverView];
    
    modalView.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:modalView];
    NSDictionary *views = NSDictionaryOfVariableBindings(containerView, modalView);
    _constraints = [
                    [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%d-[modalView]-%d-|", (int)_insets.left, (int)_insets.right] options:0 metrics:nil views:views] arrayByAddingObjectsFromArray:
                    [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%d-[modalView]-%d-|", (int)_insets.top, (int)_insets.bottom] options:0 metrics:nil views:views]];
    [containerView addConstraints:_constraints];
    
    modalView.frame = UIEdgeInsetsInsetRect(containerView.frame, _insets);
    switch (self.startPosition) {
      case GHUIViewControllerModalStartPositionTop:
        modalView.frame = CGRectOffset(modalView.frame, 0, -containerView.frame.size.height);
        break;
      case GHUIViewControllerModalStartPositionLeft:
        modalView.frame = CGRectOffset(modalView.frame, -containerView.frame.size.width, 0);
        break;
      case GHUIViewControllerModalStartPositionBottom:
        modalView.frame = CGRectOffset(modalView.frame, 0, containerView.frame.size.height);
        break;
      case GHUIViewControllerModalStartPositionRight:
        modalView.frame = CGRectOffset(modalView.frame, containerView.frame.size.width, 0);
        break;
    }
    
    CGRect endFrame = UIEdgeInsetsInsetRect(containerView.frame, _insets);
    
    [containerView bringSubviewToFront:modalView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:0 animations:^{
      modalView.frame = endFrame;
      _coverView.alpha = 1.0;
    } completion:^(BOOL finished) {
      [transitionContext completeTransition:YES];
    }];
  } else if (self.animationType == GHUIViewControllerAnimationTypeDismiss) {
    UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
    CGRect endFrame;
    switch (self.startPosition) {
      case GHUIViewControllerModalStartPositionTop:
        endFrame = CGRectMake(modalView.frame.origin.x, -containerView.frame.size.height, modalView.frame.size.width, modalView.frame.size.height);
        break;
      case GHUIViewControllerModalStartPositionLeft:
        endFrame = CGRectMake(-containerView.frame.size.width, modalView.frame.origin.y, modalView.frame.size.width, modalView.frame.size.height);
        break;
      case GHUIViewControllerModalStartPositionBottom:
        endFrame = CGRectMake(modalView.frame.origin.x, containerView.frame.size.height, modalView.frame.size.width, modalView.frame.size.height);
        break;
      case GHUIViewControllerModalStartPositionRight:
        endFrame = CGRectMake(containerView.frame.size.width, modalView.frame.origin.y, modalView.frame.size.width, modalView.frame.size.height);
        break;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:0 animations:^{
      modalView.frame = endFrame;
      _coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
      [_coverView removeFromSuperview];
      [containerView removeConstraints:_constraints];
      [transitionContext completeTransition:YES];
    }];
  }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 1.0;
}

@end
