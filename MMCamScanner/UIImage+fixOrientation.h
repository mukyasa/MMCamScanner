//
//  UIImage+fixOrientation.h
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;
+(UIImage*)renderImage:(NSString *)imagName;
+(UIImage *) scaleAndRotateImage:(UIImage *)image;
@end