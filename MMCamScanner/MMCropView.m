//
//  MMCropView.m
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import "MMCropView.h"
#define kCropButtonSize 30
@implementation MMCropView
@synthesize pointD = _pointD;
@synthesize pointC = _pointC;
@synthesize pointB = _pointB;
@synthesize pointA = _pointA;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //INIT
        self.points=[[NSMutableArray alloc] init];
        _pointA=[[UIView alloc] init];
        _pointB=[[UIView alloc] init];
        _pointC=[[UIView alloc] init];
        _pointD=[[UIView alloc] init];
        
        //middle Points
         _pointE=[[UIView alloc] init];
         _pointF=[[UIView alloc] init];
         _pointG=[[UIView alloc] init];
         _pointH=[[UIView alloc] init];
        
        _pointA.alpha=0.5;_pointB.alpha=0.5;_pointC.alpha=0.5;_pointD.alpha=0.5,_pointE.alpha=0.5,_pointF.alpha=0.5,_pointG.alpha=0.5,_pointH.alpha=0.5;
        
        _pointA.layer.cornerRadius = kCropButtonSize/2;
        _pointB.layer.cornerRadius = kCropButtonSize/2;
        _pointC.layer.cornerRadius = kCropButtonSize/2;
        _pointD.layer.cornerRadius = kCropButtonSize/2;
        
        //middle
         _pointE.layer.cornerRadius = kCropButtonSize/2;
         _pointF.layer.cornerRadius = kCropButtonSize/2;
         _pointG.layer.cornerRadius = kCropButtonSize/2;
         _pointH.layer.cornerRadius = kCropButtonSize/2;
        
        [self addSubview:_pointA];
        [self addSubview:_pointB];
        [self addSubview:_pointC];
        [self addSubview:_pointD];
        
        //middle
        [self addSubview:_pointE];
        [self addSubview:_pointF];
        [self addSubview:_pointG];
        [self addSubview:_pointH];
        
        [self.points addObject:_pointD];
        [self.points addObject:_pointC];
        [self.points addObject:_pointB];
        [self.points addObject:_pointA];
        
        
        //middle
         [self.points addObject:_pointE];
         [self.points addObject:_pointF];
         [self.points addObject:_pointG];
         [self.points addObject:_pointH];
       
        
        //COLOR
        _pointA.backgroundColor=[UIColor grayColor];
         _pointB.backgroundColor=[UIColor grayColor];
         _pointC.backgroundColor=[UIColor grayColor];
         _pointD.backgroundColor=[UIColor grayColor];
        
        //middle
        _pointE.backgroundColor=[UIColor grayColor];
        _pointF.backgroundColor=[UIColor grayColor];
        _pointG.backgroundColor=[UIColor grayColor];
        _pointH.backgroundColor=[UIColor grayColor];
        
        
        
        
        
        [self setPoints];
        [self setClipsToBounds:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        [self setContentMode:UIViewContentModeRedraw];
        [self setButtons];
   
        
    }
    return self;
}

- (NSArray *)getPoints
{
    NSMutableArray *p = [NSMutableArray array];
    
    for (uint i=0; i<self.points.count; i++)
    {
        UIView *v = [self.points objectAtIndex:i];
        CGPoint point = CGPointMake(v.frame.origin.x +kCropButtonSize/2, v.frame.origin.y +kCropButtonSize/2);
        [p addObject:[NSValue valueWithCGPoint:point]];
    }
    
    return p;
}


- (void) resetFrame
{
    [self setPoints];
    [self setNeedsDisplay];
    [self drawRect:self.bounds];
    
    [self setButtons];
}

- (BOOL) frameEdited
{
    return frameMoved;
}

- (CGPoint)coordinatesForPoint: (int)point withScaleFactor: (CGFloat)scaleFactor
{
    CGPoint tmp = CGPointMake(0, 0);
    
    switch (point) {
        case 1:
            tmp = CGPointMake((_pointA.frame.origin.x+15) / scaleFactor, (_pointA.frame.origin.y+15) / scaleFactor);
            break;
        case 2:
            tmp = CGPointMake((_pointB.frame.origin.x+15) / scaleFactor, (_pointB.frame.origin.y+15) / scaleFactor);
            break;
        case 3:
            tmp = CGPointMake((_pointC.frame.origin.x+15) / scaleFactor, (_pointC.frame.origin.y+15) / scaleFactor);
            break;
        case 4:
            tmp =  CGPointMake((_pointD.frame.origin.x+15) / scaleFactor, (_pointD.frame.origin.y+15) / scaleFactor);
            break;
    }
    
    //NSLog(@"%@", NSStringFromCGPoint(tmp));
    
    return tmp;
}

- (UIImage *)squareButtonWithWidth:(int)width
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blank;
}

- (void)setPoints
{
//    a = CGPointMake(0 + 15, self.bounds.size.height - 15);
//    b = CGPointMake(self.bounds.size.width - 15, self.bounds.size.height - 15);
//    c = CGPointMake(self.bounds.size.width - 15, 0 + 15);
//    d = CGPointMake(0 + 15, 0 + 15);
    a = CGPointMake(0 + 0, self.bounds.size.height - 0);
    b = CGPointMake(self.bounds.size.width - 0, self.bounds.size.height - 0);
    c = CGPointMake(self.bounds.size.width - 0, 0 + 0);
    d = CGPointMake(0 + 0, 0 + 0);
    
    //middle
    e = CGPointMake((a.x+b.x)/2 ,a.y);
    f = CGPointMake(b.x, 0 + (b.y + c.y)/2);
    g = CGPointMake((c.x+d.x)/2, 0 + c.y);
    h = CGPointMake(a.x, 0 + (a.y + d.y)/2);
    

}

- (void)setButtons
{
   
    [_pointD setFrame:CGRectMake(d.x - kCropButtonSize / 2, d.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    [_pointC setFrame:CGRectMake(c.x - kCropButtonSize / 2,c.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    [_pointB setFrame:CGRectMake(b.x - kCropButtonSize / 2, b.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    [_pointA setFrame:CGRectMake(a.x - kCropButtonSize / 2, a.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    
    [_pointE setFrame:CGRectMake(e.x - kCropButtonSize / 2, e.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    [_pointF setFrame:CGRectMake(f.x - kCropButtonSize / 2, f.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    [_pointG setFrame:CGRectMake(g.x - kCropButtonSize / 2, g.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    [_pointH setFrame:CGRectMake(h.x - kCropButtonSize / 2, h.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    
  
}

- (void)bottomLeftCornerToCGPoint: (CGPoint)point
{
    a = point;
    [self needsRedraw];
}

- (void)bottomRightCornerToCGPoint: (CGPoint)point
{
    b = point;
    [self needsRedraw];
}

- (void)topRightCornerToCGPoint: (CGPoint)point
{
    c = point;
    [self needsRedraw];
}

- (void)topLeftCornerToCGPoint: (CGPoint)point
{
    d = point;
    [self needsRedraw];
}

- (void)needsRedraw
{
    
    [self setNeedsDisplay];
    [self setButtons];
    [self cornerControlsMiddle];
    [self drawRect:self.bounds];
}

- (void)drawRect:(CGRect)rect;
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context)
    {
        
        // [UIColor colorWithRed:0.52f green:0.65f blue:0.80f alpha:1.00f];
        
//        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.7f);
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.0f);
        if([self checkForNeighbouringPoints:currentIndex]>=0 ){
            frameMoved=YES;
             CGContextSetRGBStrokeColor(context, 0.1294f, 0.588f, 0.9529f, 1.0f);
            
        }
        else{
            frameMoved=NO;
             CGContextSetRGBStrokeColor(context, 0.9568f, 0.262f, 0.211f, 1.0f);
           
        }
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineWidth(context, 4.0f);
        
        CGRect boundingRect = CGContextGetClipBoundingBox(context);
        CGContextAddRect(context, boundingRect);
        CGContextFillRect(context, boundingRect);
        
        CGMutablePathRef pathRef = CGPathCreateMutable();
        
        CGPathMoveToPoint(pathRef, NULL, _pointA.frame.origin.x+15, _pointA.frame.origin.y+15);
        CGPathAddLineToPoint(pathRef, NULL, _pointB.frame.origin.x+15, _pointB.frame.origin.y+15);
        CGPathAddLineToPoint(pathRef, NULL, _pointC.frame.origin.x+15, _pointC.frame.origin.y+15);
        CGPathAddLineToPoint(pathRef, NULL, _pointD.frame.origin.x+15, _pointD.frame.origin.y+15);
        

        CGPathCloseSubpath(pathRef);
        CGContextAddPath(context, pathRef);
        CGContextStrokePath(context);
        
        CGContextSetBlendMode(context, kCGBlendModeClear);
        
        CGContextAddPath(context, pathRef);
        CGContextFillPath(context);
        
        
        
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        
        
        CGPathRelease(pathRef);
    }
}

#pragma  mark Condition For Valid Rect

-(double)checkForNeighbouringPoints:(int)index{
    NSArray *points=[self getPoints];
    CGPoint p1;
    CGPoint p2 ;
    CGPoint p3;
    //    NSLog(@"%d",index);
    
    for (int i=0; i<points.count; i++) {
        switch (i) {
            case 0:{
                
                p1 = [[points objectAtIndex:0] CGPointValue];
                p2 = [[points objectAtIndex:1] CGPointValue];
                p3 = [[points objectAtIndex:3] CGPointValue];
                
            }
                break;
            case 1:{
                p1 = [[points objectAtIndex:1] CGPointValue];
                p2 = [[points objectAtIndex:2] CGPointValue];
                p3 = [[points objectAtIndex:0] CGPointValue];
                
            }
                break;
            case 2:{
                p1 = [[points objectAtIndex:2] CGPointValue];
                p2 = [[points objectAtIndex:3] CGPointValue];
                p3 = [[points objectAtIndex:1] CGPointValue];
                
            }
                break;
                
            default:{
                p1 = [[points objectAtIndex:3] CGPointValue];
                p2 = [[points objectAtIndex:0] CGPointValue];
                p3 = [[points objectAtIndex:2] CGPointValue];
                
            }
                break;
        }
        
        
        CGPoint ab=CGPointMake( p2.x - p1.x, p2.y - p1.y );
        CGPoint cb=CGPointMake( p2.x - p3.x, p2.y - p3.y );
        float dot = (ab.x * cb.x + ab.y * cb.y); // dot product
        float cross = (ab.x * cb.y - ab.y * cb.x); // cross product
        
        float alpha = atan2(cross, dot);
        
        
        //        NSLog(@"%f", -1*(float) floor(alpha * 180. / 3.14 + 0.5));
        
        
        
        if((-1*(float) floor(alpha * 180. / 3.14 + 0.5))<0){
            return -1*(float) floor(alpha * 180. / 3.14 + 0.5);
        }
        
        
    }
    return 0;
    
}
-(void)swapTwoPoints{
    
    
    if(k==2){
        NSLog(@"Swicth  2");
        if([self checkForHorizontalIntersection]){
            CGRect temp0=[[self.points objectAtIndex:0] frame];
            CGRect temp3=[[self.points objectAtIndex:3] frame];
            
            [[self.points objectAtIndex:0] setFrame:temp3];
            [[self.points objectAtIndex:3] setFrame:temp0];
            [self checkangle:0];
            [self cornerControlsMiddle];
            [self setNeedsDisplay];
        }
        if ([self checkForVerticalIntersection]) {
            CGRect temp0=[[self.points objectAtIndex:2] frame];
            CGRect temp3=[[self.points objectAtIndex:3] frame];
            
            [[self.points objectAtIndex:2] setFrame:temp3];
            [[self.points objectAtIndex:3] setFrame:temp0];
            [self checkangle:0];
            [self cornerControlsMiddle];
            [self setNeedsDisplay];
        }
        
        
    }
    else{
        
        NSLog(@"Swicth More then 2");
        CGRect temp2=[[self.points objectAtIndex:2] frame];
        CGRect temp0=[[self.points objectAtIndex:0] frame];
        
        [[self.points objectAtIndex:0] setFrame:temp2];
        [[self.points objectAtIndex:2] setFrame:temp0];
        [self cornerControlsMiddle];
        [self setNeedsDisplay];
        
    }
    
}

-(void)checkangle:(int)index{
    NSArray *points=[self getPoints];
    CGPoint p1;
    CGPoint p2 ;
    CGPoint p3;
    
    NSLog(@"%d",index);
    k=0;
    
    for (int i=0; i<points.count; i++) {
        switch (i) {
            case 0:{
                
                p1 = [[points objectAtIndex:0] CGPointValue];
                p2 = [[points objectAtIndex:1] CGPointValue];
                p3 = [[points objectAtIndex:3] CGPointValue];
                
            }
                break;
            case 1:{
                p1 = [[points objectAtIndex:1] CGPointValue];
                p2 = [[points objectAtIndex:2] CGPointValue];
                p3 = [[points objectAtIndex:0] CGPointValue];
                
            }
                break;
            case 2:{
                p1 = [[points objectAtIndex:2] CGPointValue];
                p2 = [[points objectAtIndex:3] CGPointValue];
                p3 = [[points objectAtIndex:1] CGPointValue];
                
            }
                break;
                
            default:{
                p1 = [[points objectAtIndex:3] CGPointValue];
                p2 = [[points objectAtIndex:0] CGPointValue];
                p3 = [[points objectAtIndex:2] CGPointValue];
                
            }
                break;
        }
        
        
        CGPoint ab=CGPointMake( p2.x - p1.x, p2.y - p1.y );
        CGPoint cb=CGPointMake( p2.x - p3.x, p2.y - p3.y );
        float dot = (ab.x * cb.x + ab.y * cb.y); // dot product
        float cross = (ab.x * cb.y - ab.y * cb.x); // cross product
        
        float alpha = atan2(cross, dot);
        
        
        if((-1*(float) floor(alpha * 180. / 3.14 + 0.5))<0){
            ++k;
            
        }
        
    }
    
    //    NSLog(@"Last Call%d",previousIndex);
    if(k>=2){
        
        [self swapTwoPoints];
        
    }
    
    previousIndex=currentIndex;
    
}

-(BOOL)checkForHorizontalIntersection{
    
    
    CGLine line1 = CGLineMake(CGPointMake([[self.points objectAtIndex:0] frame].origin.x, [[self.points objectAtIndex:0] frame].origin.y), CGPointMake([[self.points objectAtIndex:1] frame].origin.x, [[self.points objectAtIndex:1] frame].origin.y));
    
    CGLine line2 = CGLineMake(CGPointMake([[self.points objectAtIndex:2] frame].origin.x, [[self.points objectAtIndex:2] frame].origin.y), CGPointMake([[self.points objectAtIndex:3] frame].origin.x, [[self.points objectAtIndex:3] frame].origin.y));
    
    
    
    //    NSLog(@"Horizontal%f %f",CGLinesIntersectAtPoint(line1, line2).x,CGLinesIntersectAtPoint(line1, line2).y);
    
    CGPoint temp=CGLinesIntersectAtPoint(line1, line2);
    if(temp.x!=INFINITY  && temp.y!=INFINITY){
        return YES;
    }
    
    return NO;
    
    
}

-(BOOL)checkForVerticalIntersection{
    CGLine line3 = CGLineMake(CGPointMake([[self.points objectAtIndex:0] frame].origin.x, [[self.points objectAtIndex:0] frame].origin.y), CGPointMake([[self.points objectAtIndex:3] frame].origin.x, [[self.points objectAtIndex:3] frame].origin.y));
    
    CGLine line4 = CGLineMake(CGPointMake([[self.points objectAtIndex:2] frame].origin.x, [[self.points objectAtIndex:2] frame].origin.y), CGPointMake([[self.points objectAtIndex:1] frame].origin.x, [[self.points objectAtIndex:1] frame].origin.y));
    
    //     NSLog(@"Verical %f %f",CGLinesIntersectAtPoint(line3, line4).x,CGLinesIntersectAtPoint(line3, line4).y);
    
    CGPoint temp=CGLinesIntersectAtPoint(line3, line4);
    if(temp.x!=INFINITY  && temp.y!=INFINITY){
        return YES;
    }
    
    return NO;
}

#pragma mark - Support methods


-(CGFloat)distanceBetween:(CGPoint)first And:(CGPoint)last{
    CGFloat xDist = (last.x - first.x);
    if(xDist<0) xDist=xDist*-1;
    CGFloat yDist = (last.y - first.y);
    if(yDist<0) yDist=yDist*-1;
    return sqrt((xDist * xDist) + (yDist * yDist));
}

-(void)findPointAtLocation:(CGPoint)location{
    self.activePoint.backgroundColor = [UIColor blueColor];
    self.activePoint = nil;
    CGFloat smallestDistance = INFINITY;
    int i=0;
    for (UIView *point in self.points)
    {
        
        CGRect extentedFrame = CGRectInset(point.frame, -20, -20);
        
//        NSLog(@"For Point %d Location%f %f and Point %f %f",i,location.x,location.y,point.frame.origin.x,point.frame.origin.y);
        if (CGRectContainsPoint(extentedFrame, location))
        {
            CGFloat distanceToThis = [self distanceBetween:point.frame.origin And:location];
            NSLog(@"Distance%f",distanceToThis);
            if(distanceToThis<smallestDistance){
                self.activePoint = point;
                
                smallestDistance = distanceToThis;
                currentIndex=i;
                
                if(i==4 || i==5 || i==6 || i==7){
                    middlePoint=YES;
                }
                else{
                    middlePoint=NO;
                }
            }
        }
        i++;
    }
    if(self.activePoint) self.activePoint.backgroundColor = [UIColor redColor];
    
    NSLog(@"Active Point%@",self.activePoint);
    
}


- (void)moveActivePointToLocation:(CGPoint)locationPoint
{
    //    NSLog(@"location: %f,%f", locationPoint.x, locationPoint.y);
    CGFloat newX = locationPoint.x;
    CGFloat newY = locationPoint.y;
    //cap off possible values
    if(newX<self.bounds.origin.x){
        newX=self.bounds.origin.x;
    }else if(newX>self.frame.size.width){
        newX = self.frame.size.width;
    }
    if(newY<self.bounds.origin.y){
        newY=self.bounds.origin.y;
    }else if(newY>self.frame.size.height){
        newY = self.frame.size.height;
    }
    locationPoint = CGPointMake(newX, newY);
    
    if (self.activePoint && !middlePoint){
        self.activePoint.frame = CGRectMake(locationPoint.x -kCropButtonSize/2, locationPoint.y -kCropButtonSize/2, kCropButtonSize, kCropButtonSize);
        [self cornerControlsMiddle];
        
//        NSLog(@"Point D %f %f",_pointD.frame.origin.x,_pointD.frame.origin.y);
    }
    else{
        if(![self checkForNeighbouringPoints:currentIndex]){
            [self movePointsForMiddle:locationPoint];
        }
        
      
    }
      [self setNeedsDisplay];
    
}


//Corner Touch

-(void)cornerControlsMiddle{
    
    self.pointE.frame=CGRectMake((self.pointA.frame.origin.x+self.pointB.frame.origin.x)/2, (self.pointA.frame.origin.y+self.pointB.frame.origin.y)/2, kCropButtonSize, kCropButtonSize);
    self.pointG.frame=CGRectMake((self.pointC.frame.origin.x+self.pointD.frame.origin.x)/2, (self.pointC.frame.origin.y+self.pointD.frame.origin.y)/2, kCropButtonSize, kCropButtonSize);
    self.pointF.frame=CGRectMake((self.pointB.frame.origin.x+self.pointC.frame.origin.x)/2, (self.pointB.frame.origin.y+self.pointC.frame.origin.y)/2, kCropButtonSize, kCropButtonSize);
     self.pointH.frame=CGRectMake((self.pointA.frame.origin.x+self.pointD.frame.origin.x)/2, (self.pointA.frame.origin.y+self.pointD.frame.origin.y)/2, kCropButtonSize, kCropButtonSize);
    
}
//Middle Touch
- (void)movePointsForMiddle:(CGPoint)locationPoint
{
    switch (currentIndex) {
        case 4:{
            // 2 and 3
            self.pointA.frame=CGRectMake(self.pointA.frame.origin.x, locationPoint.y -kCropButtonSize/2, kCropButtonSize, kCropButtonSize);
            self.pointB.frame=CGRectMake(self.pointB.frame.origin.x, locationPoint.y -kCropButtonSize/2, kCropButtonSize, kCropButtonSize);
        }
            
            break;
            
        case 5:{
           // 1 and 2
            self.pointB.frame=CGRectMake(locationPoint.x -kCropButtonSize/2,self.pointB.frame.origin.y, kCropButtonSize, kCropButtonSize);
            self.pointC.frame=CGRectMake(locationPoint.x -kCropButtonSize/2,self.pointC.frame.origin.y, kCropButtonSize, kCropButtonSize);

        }
            break;
        case 6:{
            //3 and 4
            self.pointC.frame=CGRectMake(self.pointC.frame.origin.x, locationPoint.y -kCropButtonSize/2, kCropButtonSize, kCropButtonSize);
            self.pointD.frame=CGRectMake(self.pointD.frame.origin.x, locationPoint.y -kCropButtonSize/2, kCropButtonSize, kCropButtonSize);
        }
            break;
        case 7:{
           // 1 and 4
            self.pointA.frame=CGRectMake(locationPoint.x -kCropButtonSize/2,self.pointA.frame.origin.y, kCropButtonSize, kCropButtonSize);
            self.pointD.frame=CGRectMake(locationPoint.x -kCropButtonSize/2,self.pointD.frame.origin.y, kCropButtonSize, kCropButtonSize);
        }
            break;


    }
    [self cornerControlsMiddle];
    
}

@end
