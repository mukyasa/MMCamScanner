//
//  RippleAnimation.h
//  MaterialDesign
//
//  Created by mukesh mandora on 26/02/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RippleAnimation : NSObject <UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>
{
     BOOL isPresenting;
    
}
@property (nonatomic) CGRect touchPoint;

@property(nonatomic) BOOL isPresentingRipple;
@property(nonatomic,strong)id<UIViewControllerContextTransitioning>transitionContext;
@end
