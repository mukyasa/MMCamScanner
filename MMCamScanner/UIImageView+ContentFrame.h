//
//  UIImageView+ContentFrame.h
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIImageView (UIImageView_ContentFrame)

-(CGRect)contentFrame;
- (CGFloat) contentScale;
- (CGSize) contentSize;

@end
