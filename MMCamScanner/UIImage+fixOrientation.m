//
//  UIImage+fixOrientation.m
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "UIImage+fixOrientation.h"

@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation
{
    UIImage *src = [[UIImage alloc] initWithCGImage: self.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationRight];

    return src;
}

+(UIImage*)renderImage:(NSString *)imagName{
    return [[UIImage imageNamed:imagName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
