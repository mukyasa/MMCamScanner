//
//  MTGeometry.h
//  MTGeometry
//
//  Created by Adam Kirk on 9/3/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "TargetConditionals.h"
#import <math.h>


#if TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
#else
#import <ApplicationServices/ApplicationServices.h>
#endif


#define NULL_NUMBER         INFINITY
#define NULL_POINT          CGPointMake(NULL_NUMBER, NULL_NUMBER)
#define RADIANS(degrees)    ((degrees * M_PI) / 180.0)


// A delta point representing the distance of a translation transform
typedef CGPoint CGDelta;

// A line is defined as two points
typedef struct {
	CGPoint point1;
	CGPoint point2;
} CGLine;




#pragma mark - Points

// Create a delta from a delta x and y
CGDelta CGDeltaMake(CGFloat deltaX, CGFloat deltaY);

// Get the distance between two points
CGFloat	CGPointDistance(CGPoint p1, CGPoint p2);

// A point along a line distance from point1.
CGPoint CGPointAlongLine(CGLine line, CGFloat distance);

// A point rotated around the pivot point by degrees.
CGPoint CGPointRotatedAroundPoint(CGPoint point, CGPoint pivot, CGFloat degrees);




#pragma mark - Lines

// Create a line from 2 points.
CGLine CGLineMake(CGPoint point1, CGPoint point2);

// Returns true if two lines are exactly coincident
bool CGLineEqualToLine(CGLine line1, CGLine line2);

// Get a lines midpoint
CGPoint CGLineMidPoint(CGLine line);

// Get the point at which two lines intersect. Returns NULL_POINT if they don't intersect.
CGPoint CGLinesIntersectAtPoint(CGLine line1, CGLine line2);

// Get the length of a line
CGFloat CGLineLength(CGLine line);

// Returns a scaled line. Point 1 acts as the base and Point 2 is extended.
CGLine CGLineScale(CGLine line, CGFloat scale);

// Returns a line translated by delta.
CGLine CGLineTranslate(CGLine line, CGDelta delta);

// Returns a scaled line with the same midpoint.
CGLine CGLineScaleOnMidPoint(CGLine line, CGFloat scale);

// Returns the delta x and y of the line from point 1 to point 2.
CGDelta CGLineDelta(CGLine line);

// Returns true if two lines are parallel
bool CGLinesAreParallel(CGLine line1, CGLine line2);




#pragma mark - Rectangles

// Corners points of a CGRect
CGPoint CGRectTopLeftPoint(CGRect rect);
CGPoint CGRectTopRightPoint(CGRect rect);
CGPoint CGRectBottomLeftPoint(CGRect rect);
CGPoint CGRectBottomRightPoint(CGRect rect);

// Returns a resized rect with the same centerpoint.
CGRect	CGRectResize(CGRect rect, CGSize newSize);

// Similar to CGRectInset but only insets one edge. All other edges do not move.
CGRect	CGRectInsetEdge(CGRect rect, CGRectEdge edge, CGFloat amount);

/**
 Calculates the stacking of rectangles within a larger rectangle.
 The resulting rectangle is stacked counter clockwise along the edge specified. As soon as
 there are more rects than will fit, a new row is started, thus, they are stacked by column,
 then by row. `reverse` will cause them to be stacked counter-clockwise along the specified edge.
*/
CGRect	CGRectStackedWithinRectFromEdge(CGRect rect, CGSize size, int count, CGRectEdge edge, bool reverse);

// Find the centerpoint of a rectangle.
CGPoint CGRectCenterPoint(CGRect rect);

// Assigns the closest two corner points to point1 and point2 of the rect to the passed in point.
void	CGRectClosestTwoCornerPoints(CGRect rect, CGPoint point, CGPoint *point1, CGPoint *point2);

// The point at which a line, extended infinitely past its second point, intersects
// the rectangle. Returns NULL_POINT if no interseciton is found.
CGPoint CGLineIntersectsRectAtPoint(CGRect rect, CGLine line);




#pragma mark - Arcs

// The control points for an arc from startPoint to endPoint with radius.
// To determine the right hand rule: make an arc with your right hand, placing your pinky on the screen and your
// thumb pointing out from the screen. With the base of your hand at the start point, the curvature of your hand
// indicates what direction the arc will curve to the endpoint.
void CGControlPointsForArcBetweenPointsWithRadius(CGPoint startPoint,
                                                  CGPoint endPoint,
                                                  CGFloat radius,
                                                  bool rightHandRule,
                                                  CGPoint *controlPoint1,
                                                  CGPoint *controlPoint2);




