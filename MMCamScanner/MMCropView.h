//
//  MMCropView.h
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGeometry.h"
@interface MMCropView : UIView
{
    CGPoint touchOffset;
    CGPoint a;
    CGPoint b;
    CGPoint c;
    CGPoint d;
    
    BOOL frameMoved;
    int currentIndex,previousIndex;
    int k;
}
@property (nonatomic, strong) UIView *activePoint;

@property (strong, nonatomic) UIView *pointD;
@property (strong, nonatomic) UIView *pointC;
@property (strong, nonatomic) UIView *pointB;
@property (strong, nonatomic) UIView *pointA;
@property (nonatomic, strong) NSMutableArray *points;


- (BOOL)frameEdited;
- (void)resetFrame;
- (CGPoint)coordinatesForPoint: (int)point withScaleFactor: (CGFloat)scaleFactor;

- (void)bottomLeftCornerToCGPoint: (CGPoint)point;
- (void)bottomRightCornerToCGPoint: (CGPoint)point;
- (void)topRightCornerToCGPoint: (CGPoint)point;
- (void)topLeftCornerToCGPoint: (CGPoint)point;


-(void)checkangle:(int)index;
-(void)findPointAtLocation:(CGPoint)location;
- (void)moveActivePointToLocation:(CGPoint)locationPoint;

@end
