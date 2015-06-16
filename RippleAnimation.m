//
//  RippleAnimation.m
//  MaterialDesign
//
//  Created by mukesh mandora on 26/02/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "RippleAnimation.h"

@implementation RippleAnimation
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.8f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    isPresenting=self.isPresentingRipple;
    
    UIViewController *fromVC =[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* containerView = [transitionContext containerView];
    
    if(isPresenting){
        
        [containerView addSubview:toVC.view];
        
        
        
        UIBezierPath *circleMaskPathInitial = [UIBezierPath bezierPathWithOvalInRect:_touchPoint];
        CGPoint extremePoint=CGPointMake(fromVC.view.center.x, fromVC.view.center.y-CGRectGetHeight(toVC.view.bounds));
        
        CGFloat radius=sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y));
        
        UIBezierPath *circleMaskPathFinal = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(fromVC.view.frame, -radius, -radius)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.path = circleMaskPathFinal.CGPath;
        toVC.view.layer.mask = maskLayer;
        
        CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        maskLayerAnimation.fromValue = (__bridge id)(circleMaskPathInitial.CGPath);
        maskLayerAnimation.toValue = (__bridge id)(circleMaskPathFinal.CGPath);
        maskLayerAnimation.duration = 0.8;
        maskLayerAnimation.delegate = self;
        maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
        
        
    }
    else{
        
        [containerView addSubview:toVC.view];
        [containerView addSubview:fromVC.view];
        
        UIBezierPath *circleMaskPathFinal = [UIBezierPath bezierPathWithOvalInRect:_touchPoint];
        
        CGPoint extremePoint=CGPointMake(toVC.view.center.x, toVC.view.center.y-CGRectGetHeight(toVC.view.bounds));
        
        CGFloat radius=sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y));
        
        UIBezierPath *circleMaskPathInitial = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(toVC.view.frame, -radius, -radius)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.path = circleMaskPathFinal.CGPath;
        fromVC.view.layer.mask = maskLayer;
        
        
        CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        maskLayerAnimation.fromValue = (__bridge id)(circleMaskPathInitial.CGPath);
        maskLayerAnimation.toValue = (__bridge id)(circleMaskPathFinal.CGPath);
        maskLayerAnimation.duration = 0.8;
        maskLayerAnimation.delegate = self;
        maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
        
    }
    
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    self.isPresentingRipple=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.isPresentingRipple=NO;
    return self;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}


@end
