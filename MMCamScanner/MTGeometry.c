//
//  MTGeometry.m
//  MTGeometry
//
//  Created by Adam Kirk on 9/3/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTGeometry.h"


#define MT_EPS      1e-4
#define MT_MIN(A,B)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __a : __b; })
#define MT_MAX(A,B)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __b : __a; })
#define MT_ABS(A)	({ __typeof__(A) __a = (A); __a < 0 ? -__a : __a; })


#pragma mark - Points

CGDelta CGDeltaMake(CGFloat deltaX, CGFloat deltaY)
{
	CGDelta delta;
	delta.x = deltaX;
	delta.y = deltaY;
	return delta;
}

CGFloat CGPointDistance(CGPoint p1, CGPoint p2)
{
    CGFloat dx = p1.x - p2.x;
    CGFloat dy = p1.y - p2.y;
    CGFloat dist = sqrt(pow(dx, 2) + pow(dy, 2));
    return dist;
}

CGPoint CGPointAlongLine(CGLine line, CGFloat distance)
{
    CGPoint start           = line.point1;
    CGPoint end             = line.point2;
    CGFloat totalDistance	= CGPointDistance(start, end);
	CGPoint totalDelta		= CGPointMake(end.x - start.x, end.y - start.y);
	CGFloat percent			= distance / totalDistance;
	CGPoint delta			= CGPointMake( totalDelta.x * percent, totalDelta.y * percent );
	return CGPointMake( start.x + delta.x, start.y + delta.y);
}

CGPoint CGPointRotatedAroundPoint(CGPoint point, CGPoint pivot, CGFloat degrees)
{
    CGAffineTransform translation, rotation;
	translation	= CGAffineTransformMakeTranslation(-pivot.x, -pivot.y);
	point		= CGPointApplyAffineTransform(point, translation);
	rotation	= CGAffineTransformMakeRotation(degrees * M_PI/180.0);
	point		= CGPointApplyAffineTransform(point, rotation);
	translation	= CGAffineTransformMakeTranslation(pivot.x, pivot.y);
	point		= CGPointApplyAffineTransform(point, translation);
	return point;
}



#pragma mark - Lines

CGLine CGLineMake(CGPoint point1, CGPoint point2)
{
	CGLine line;
	line.point1.x = point1.x;
	line.point1.y = point1.y;
	line.point2.x = point2.x;
	line.point2.y = point2.y;
	return line;
}

bool CGLineEqualToLine(CGLine line1, CGLine line2)
{
	return CGPointEqualToPoint(line1.point1, line2.point1) && CGPointEqualToPoint(line1.point2, line2.point2);
}

CGPoint CGLineMidPoint(CGLine line)
{
    CGPoint midPoint = CGPointZero;
	midPoint.x = (line.point1.x + line.point2.x) / 2.0;
	midPoint.y = (line.point1.y + line.point2.y) / 2.0;
	return midPoint;
}

CGPoint CGLinesIntersectAtPoint(CGLine line1, CGLine line2)
{
	CGFloat mua,mub;
	CGFloat denom,numera,numerb;

	double x1 = line1.point1.x;
	double y1 = line1.point1.y;
	double x2 = line1.point2.x;
	double y2 = line1.point2.y;
	double x3 = line2.point1.x;
	double y3 = line2.point1.y;
	double x4 = line2.point2.x;
	double y4 = line2.point2.y;

	denom  = (y4-y3) * (x2-x1) - (x4-x3) * (y2-y1);
	numera = (x4-x3) * (y1-y3) - (y4-y3) * (x1-x3);
	numerb = (x2-x1) * (y1-y3) - (y2-y1) * (x1-x3);

	/* Are the lines coincident? */
	if (MT_ABS(numera) < MT_EPS && MT_ABS(numerb) < MT_EPS && MT_ABS(denom) < MT_EPS) {
		return CGPointMake( (x1 + x2) / 2.0 , (y1 + y2) / 2.0);
	}

	/* Are the line parallel */
	if (MT_ABS(denom) < MT_EPS) {
		return NULL_POINT;
	}

	/* Is the intersection along the the segments */
	mua = numera / denom;
	mub = numerb / denom;
	if (mua < 0 || mua > 1 || mub < 0 || mub > 1) {
		return NULL_POINT;
	}
	return CGPointMake(x1 + mua * (x2 - x1), y1 + mua * (y2 - y1));
}

CGFloat CGLineLength(CGLine line)
{
	return CGPointDistance(line.point1, line.point2);
}

CGLine CGLineScale(CGLine line, CGFloat scale)
{
	CGDelta lineDelta = CGLineDelta(line);
	CGFloat scaledDeltaX = lineDelta.x * scale;
	CGFloat scaledDeltaY = lineDelta.y * scale;
	return CGLineMake( CGPointMake(line.point1.x, line.point1.y), CGPointMake(line.point1.x + scaledDeltaX, line.point1.y + scaledDeltaY) );
}

CGLine CGLineTranslate(CGLine line, CGDelta delta)
{
    line.point1.x += delta.x;
    line.point1.y += delta.y;
    line.point2.x += delta.x;
    line.point2.y += delta.y;
    return line;
}

CGLine CGLineScaleOnMidPoint(CGLine line, CGFloat scale)
{
    CGPoint midPoint = CGLineMidPoint(line);
    CGLine scaledLine = CGLineScale(line, scale);
    CGPoint midScaled = CGPointMake(((scaledLine.point2.x - line.point2.x) / 2.0) + line.point2.x,
                                    ((scaledLine.point2.y - line.point2.y) / 2.0) + line.point2.y);
    CGPoint newStartPoint = CGPointRotatedAroundPoint(midScaled, midPoint, 180);
    return CGLineMake(newStartPoint, midScaled);
}

CGDelta CGLineDelta(CGLine line)
{
	return CGDeltaMake(line.point2.x - line.point1.x, line.point2.y - line.point1.y);
}

bool CGLinesAreParallel(CGLine line1, CGLine line2)
{
	CGFloat denom;
    
	double x1 = line1.point1.x;
	double y1 = line1.point1.y;
	double x2 = line1.point2.x;
	double y2 = line1.point2.y;
	double x3 = line2.point1.x;
	double y3 = line2.point1.y;
	double x4 = line2.point2.x;
	double y4 = line2.point2.y;
    
	denom  = (y4-y3) * (x2-x1) - (x4-x3) * (y2-y1);     // m1 - m2
    
	if (MT_ABS(denom) < MT_EPS) {
		return true;
	}
    else {
        return false;
    }
}




#pragma mark - Rectangles

CGPoint CGRectTopLeftPoint(CGRect rect)
{
	return CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
}

CGPoint CGRectTopRightPoint(CGRect rect)
{
	return CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
}

CGPoint CGRectBottomLeftPoint(CGRect rect)
{
	return CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
}

CGPoint CGRectBottomRightPoint(CGRect rect)
{
	return CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

CGRect CGRectResize(CGRect rect, CGSize newSize)
{
    CGFloat dx = (rect.size.width - newSize.width) / 2.0;
    CGFloat dy = (rect.size.height - newSize.height) / 2.0;
	return CGRectInset(rect, dx, dy);
}

CGRect CGRectInsetEdge(CGRect rect, CGRectEdge edge, CGFloat amount)
{
	if (edge == CGRectMinXEdge) {
		rect.origin.x += amount;
		rect.size.width -= amount;
	}
	else if (edge == CGRectMaxXEdge) {
		rect.size.width += amount;
	}
	else if (edge == CGRectMinYEdge) {
		rect.origin.y += amount;
		rect.size.height -= amount;
	}
	else if (edge == CGRectMaxYEdge) {
		rect.size.height += amount;
	}
	return rect;
}

CGRect CGRectStackedWithinRectFromEdge(CGRect rect, CGSize size, int count, CGRectEdge edge, bool reverse)
{
    int max_columns = floor(rect.size.width / size.width);
    int max_rows = floor(rect.size.height / size.height);

    if (edge == CGRectMinYEdge) {
        int current_row = floor(count / max_columns);
        int current_col = (count - 1) % max_columns;
        if (reverse) current_col = max_columns - (current_col + 1);
        if (current_col > max_columns || current_row > max_rows) {
            return CGRectNull;
        }
        else {
            CGFloat x = CGRectGetMinX(rect) + (current_col * size.width);
            CGFloat y = CGRectGetMinY(rect) + (current_row * size.height);
            return CGRectMake(x, y, size.width, size.height);
        }
    }

    else if (edge == CGRectMaxYEdge) {
        int current_row = floor(count / max_columns);
        int current_col = (count - 1) % max_columns;
        if (!reverse) current_col = max_columns - (current_col + 1);
        if (current_col > max_columns || current_row > max_rows) {
            return CGRectNull;
        }
        else {
            CGFloat x = CGRectGetMinX(rect) + (current_col * size.width);
            CGFloat y = CGRectGetMaxY(rect) - size.height - (current_row * size.height);
            return CGRectMake(x, y, size.width, size.height);
        }
    }

    else if (edge == CGRectMinXEdge) {
        int current_col = floor(count / max_columns);
        int current_row = (count - 1) % max_columns;
        if (!reverse) current_row = max_rows - (current_row + 1);
        if (current_col > max_columns || current_row > max_rows) {
            return CGRectNull;
        }
        else {
            CGFloat x = CGRectGetMinX(rect) + (current_col * size.width);
            CGFloat y = CGRectGetMinY(rect) + (current_row * size.height);
            return CGRectMake(x, y, size.width, size.height);
        }
    }

    else if (edge == CGRectMaxXEdge) {
        int current_col = floor(count / max_columns);
        int current_row = (count - 1) % max_columns;
        if (reverse) current_row = max_rows - (current_row + 1);
        if (current_col > max_columns || current_row > max_rows) {
            return CGRectNull;
        }
        else {
            CGFloat x = CGRectGetMaxX(rect) - size.width - (current_col * size.width);
            CGFloat y = CGRectGetMinY(rect) + current_row * size.height;
            return CGRectMake(x, y, size.width, size.height);
        }
    }

    return CGRectNull;
}

CGPoint CGRectCenterPoint(CGRect rect)
{
    CGPoint centerPoint = CGPointZero;
    centerPoint.x = CGRectGetMidX(rect);
    centerPoint.y = CGRectGetMidY(rect);
    return centerPoint;
}

void CGRectClosestTwoCornerPoints(CGRect rect, CGPoint point, CGPoint *point1, CGPoint *point2)
{
	// gather the rects points
    CGPoint rectPoints[4];
    rectPoints[0] = CGPointMake(rect.origin.x, rect.origin.y);
    rectPoints[1] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    rectPoints[2] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    rectPoints[3] = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);

    // bubble sort them
    int changed = 1;
    while (changed) {
        changed = 0;
        for (int i = 0; i < 3; i++) {
            CGPoint p1 = rectPoints[i];
            CGPoint p2 = rectPoints[i+1];
            if (CGPointDistance(point, p1) > CGPointDistance(point, p2)) {
                rectPoints[i] = p2;
                rectPoints[i+1] = p1;
                changed = 1;
            }
        }
    }

	// assign them to the passed in pointers
    *point1 = rectPoints[0];
    *point2 = rectPoints[1];
}

CGPoint CGLineIntersectsRectAtPoint(CGRect rect, CGLine line)
{
	CGLine top		= CGLineMake( CGPointMake( CGRectGetMinX(rect), CGRectGetMinY(rect) ), CGPointMake( CGRectGetMaxX(rect), CGRectGetMinY(rect) ) );
	CGLine right	= CGLineMake( CGPointMake( CGRectGetMaxX(rect), CGRectGetMinY(rect) ), CGPointMake( CGRectGetMaxX(rect), CGRectGetMaxY(rect) ) );
	CGLine bottom	= CGLineMake( CGPointMake( CGRectGetMinX(rect), CGRectGetMaxY(rect) ), CGPointMake( CGRectGetMaxX(rect), CGRectGetMaxY(rect) ) );
	CGLine left		= CGLineMake( CGPointMake( CGRectGetMinX(rect), CGRectGetMinY(rect) ), CGPointMake( CGRectGetMinX(rect), CGRectGetMaxY(rect) ) );

	// ensure the line extends beyond outside the rectangle
	CGFloat topLeftToBottomRight = CGPointDistance(CGRectTopLeftPoint(rect), CGRectBottomRightPoint(rect));
	CGFloat bottomLeftToTopRight = CGPointDistance(CGRectBottomLeftPoint(rect), CGRectTopRightPoint(rect));
	CGFloat maxDimension = MT_MAX(topLeftToBottomRight, bottomLeftToTopRight);
	CGFloat scaleFactor = maxDimension / MT_MIN(CGLineLength(line), maxDimension);
	CGLine extendedLine = CGLineScale(line, scaleFactor + 3);

	CGPoint points[4] = { CGLinesIntersectAtPoint(top, extendedLine), CGLinesIntersectAtPoint(right, extendedLine), CGLinesIntersectAtPoint(bottom, extendedLine), CGLinesIntersectAtPoint(left, extendedLine) };

	for (int i = 0; i < 4; i++) {
		CGPoint p = points[i];
		if (!CGPointEqualToPoint(p, NULL_POINT)) {
			return p;
		}
	}

	return NULL_POINT;
}




#pragma mark - Arcs

void CGControlPointsForArcBetweenPointsWithRadius(CGPoint startPoint,
                                                  CGPoint endPoint,
                                                  CGFloat radius,
                                                  bool rightHandRule,
                                                  CGPoint *controlPoint1,
                                                  CGPoint *controlPoint2)
{
    CGLine line             = CGLineMake(startPoint, endPoint);
    CGPoint midPoint        = CGLineMidPoint(line);
    CGFloat degrees         = rightHandRule ? 90 : -90;
    CGPoint rotatedPoint    = CGPointRotatedAroundPoint(startPoint, midPoint, degrees);
    CGFloat lineLength      = CGLineLength(line);
    if (lineLength > radius * 2) {
        *controlPoint1 = CGPointMake(startPoint.x, startPoint.y);
        *controlPoint2 = CGPointMake(endPoint.x, endPoint.y);
        return;
    }
    CGFloat diameterPercent = lineLength / (radius * 2);
    CGLine perpLine         = CGLineMake(midPoint, rotatedPoint);
    CGLine arcMidLine       = CGLineScale(perpLine, diameterPercent);
    CGDelta arcMidLineDelta = CGLineDelta(arcMidLine);
    CGLine scaledLine       = CGLineScaleOnMidPoint(line, diameterPercent);
    CGLine translatedLine   = CGLineTranslate(scaledLine, arcMidLineDelta);
    *controlPoint1          = translatedLine.point1;
    *controlPoint2          = translatedLine.point2;
}







