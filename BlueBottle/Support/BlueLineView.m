//
//  BlueLineView.m
//  BlueLine
//
//  Created by alex hunsley on 09/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlueLineView.h"
#import "BlueLineGenerator.h"
#import "BLCoord.h"
#import "Method.h"

@interface BlueLineView ()

@property (nonatomic) int actualLeftMargin;
@property (nonatomic) int actualRightMargin;
@property (nonatomic) int actualTopMargin;
@property (nonatomic) int actualBottomMargin;
@property (nonatomic) int xGridDelta;
@property (nonatomic) int yGridDelta;
@property (nonatomic) float handDrawCurrentX;
@property (nonatomic) float handDrawCurrentY;


@end

@implementation BlueLineView

@synthesize method;
@synthesize leftMargin;
@synthesize rightMargin;
@synthesize topMargin;
@synthesize bottomMargin;
@synthesize actualLeftMargin;
@synthesize actualRightMargin;
@synthesize actualTopMargin;
@synthesize actualBottomMargin;
@synthesize xGridDelta;
@synthesize yGridDelta;
@synthesize handDrawCurrentX;
@synthesize handDrawCurrentY;
@synthesize blg;
@synthesize viewSize;

#pragma mark -
#pragma mark Init, dealloc

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)calcLayout {
	//percentages

//	leftMargin = 0.2f;
//	rightMargin = 0.8f;
    
    leftMargin = 0.04f;
    rightMargin = 1.0f - leftMargin;
    
    int numBells = 8;
	
	
	float w = self.bounds.size.width;
	//float h = self.frame.size.height;
	
	actualLeftMargin = w * leftMargin;
	actualRightMargin = w * rightMargin;
	int diff = actualRightMargin - actualLeftMargin;
	
	int excess = diff % (numBells - 1);
	actualRightMargin -= excess;

	self.xGridDelta = (actualRightMargin - actualLeftMargin) / (numBells - 1);
	NSLog(@" actual margin LR: %d, %d  xDelta = %d", 
		  actualLeftMargin, actualRightMargin, xGridDelta);

	offsetX = actualLeftMargin;
	scaleX = self.xGridDelta;
	
	scaleY = 8.0f;
	
	offsetY = 10.0f;
	
	topMargin = 10.0f;
	bottomMargin = 10.0f;
	
	viewSize = CGRectMake(0.0f, 0.0f, w, topMargin + bottomMargin + method.leadEndLength * scaleY);
	
    //self.bounds = viewSize;
    
    //[self setNeedsLayout];
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Accessors

- (void)setMethod:(Method *)m placeBell:(int)placeBell {
	[m retain];
	[method release];
	method = m;
	
    blg = [[BlueLineGenerator alloc] initWithMethod:method];
    //[blg generateLineForBell:4];
//    [blg generateBlueLines];
    [blg generateForBell:placeBell];

    
	[self calcLayout];
//	self.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 800.0f);
//	[self in
	NSLog(@" setMethod, self.frame = %@", NSStringFromCGRect(self.frame));
}

#pragma mark -
#pragma mark Rendering

CGRect growRectAsymmetric(CGRect rect, CGFloat growWidth, CGFloat growHeight) {
	return CGRectMake(rect.origin.x - growWidth / 2.0f, 
					  rect.origin.y - growHeight / 2.0f, 
					  rect.size.width + growWidth, 
					  rect.size.height + growHeight);
}

CGRect growRect(CGRect rect, CGFloat growAmount) {
	return growRectAsymmetric(rect, growAmount, growAmount);
}

CGRect* splitRectVertically(CGRect rect, int numberParts, float subrectGrowAmount) {
	CGRect* resultRects = malloc(numberParts * sizeof(CGRect));
	
	int subRectHeight = rect.size.height / numberParts;
	
	for (int index = 0; index < numberParts; index++) {
		resultRects[index] = CGRectMake(rect.origin.x,
										rect.origin.y + subRectHeight * index,
										rect.size.width, 
										subRectHeight);
		resultRects[index] = growRect(resultRects[index], subrectGrowAmount);
		NSLog(@" rect = %@", NSStringFromCGRect(rect));
	}
	return resultRects;
}

CGRect* splitRectHorizontally(CGRect rect, int numberParts, float subrectGrowAmount) {
	CGRect* resultRects = malloc(numberParts * sizeof(CGRect));
	
	int subRectWidth = rect.size.width / numberParts;
	
	for (int index = 0; index < numberParts; index++) {
		resultRects[index] = CGRectMake(rect.origin.x + subRectWidth * index,
										rect.origin.y,
										subRectWidth,
										rect.size.height);

		resultRects[index] = growRect(resultRects[index], subrectGrowAmount);
		NSLog(@" rect = %@", NSStringFromCGRect(rect));
	}
	return resultRects;
}

- (void)handDrawMoveToPoint:(CGContextRef)context x:(float)x y:(float)y {
	CGContextMoveToPoint(context, x, y);
	handDrawCurrentX = x;
	handDrawCurrentY = y;
}

- (void)handDrawMoveToPoint:(CGContextRef)context coord:(BLCoord *)coord {
	[self handDrawMoveToPoint:context x:offsetX + scaleX * coord.x y:offsetY + scaleY * coord.y];
}


- (void)handDrawAddLineToPoint:(CGContextRef)context x:(float)x y:(float)y {
	//CGContextMoveToPoint(context, x, y);
	
	// approx segment length to break line down into
	static float segmentLength = 16.0f;
	
	// adjust end point randomly here if need be...
	// todo
	
	float dx = (x - handDrawCurrentX);
	float dy = (y - handDrawCurrentY);

	
	float lineLength = sqrt(dx*dx + dy*dy);
	
	if (segmentLength < lineLength) {
		int numIntermediatePoints = lineLength / segmentLength;
		float iDx = dx / (numIntermediatePoints + 1);
		float iDy = dy / (numIntermediatePoints + 1);
		
		float orthogDx = -iDy;
		float orthogDy = iDx;
		
		//float intermediateSegLength = lineLength / numIntermediatePoints;
		
		for (int i = 1; i <= numIntermediatePoints; i++) {
			//float sideOffsetAmount = 1.5f * (((rand() % 100) / 100.0f) - 0.5f);
			float sideOffsetAmount = 0.0f;
            
            //NSLog(@" side amount = %f", sideOffsetAmount);
			float sideX = orthogDx / 10.0f * sideOffsetAmount;
			float sideY = orthogDy / 10.0f * sideOffsetAmount;
			
			CGContextAddLineToPoint(context, handDrawCurrentX + i * iDx  + sideX, 
									handDrawCurrentY + i * iDy  + sideY);
			//CGContextAddLineToPoint(context, 0.0f, 0.0f);
			//CGContextAddLineToPoint(context, handDrawCurrentX + i * iDx, handDrawCurrentY + i * iDy);
		}
	}
	//NSLog(@" line length = %f", lineLength);
	
	CGContextAddLineToPoint(context, x, y);
	
	handDrawCurrentX = x;
	handDrawCurrentY = y;
}

- (void)handDrawAddLineToPoint:(CGContextRef)context coord:(BLCoord *)coord {
	[self handDrawAddLineToPoint:context x:offsetX + scaleX * coord.x y:offsetY + scaleY * coord.y];
}

- (void)drawRect:(CGRect)rect {
	NSLog(@"  drawRect!");
	
    if (method == nil) {
        return;
    }
	NSLog(@"  drawRect -- actually drawing!");
	//scaleX = 20.0f;
	
    // Drawing code

	//Get the CGContext from this view
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	/// flip for text drawing
	
	CGContextTranslateCTM(context, 0, rect.size.height);
	CGContextScaleCTM(context, 1, -1);
	
	/////// end flip
    float w, h;
    w = rect.size.width;
    h = rect.size.height;
	
    //CGAffineTransform myTextTransform; // 2
    CGContextSelectFont (context, // 3
						 "Helvetica",
						 12,
						 kCGEncodingMacRoman);
	
    CGContextSetCharacterSpacing (context, 0); // 4
    CGContextSetTextDrawingMode (context, kCGTextFillStroke); // 5
	
    CGContextSetRGBFillColor (context, 0, 0, 0, 1.0f); // 6
    //CGContextSetRGBStrokeColor (context, 0, 0, 1, 1); // 7
    //myTextTransform =  CGAffineTransformMakeRotation  (MyRadians (45)); // 8
    //CGContextSetTextMatrix (myContext, myTextTransform); // 9
	
//	float textX = actualLeftMargin + xGridDelta * method.numBells;
//	
//    // DRAW: the - at each place bell end
//    NSLog(@" drawing, numChanges, leadEndLength = %d, %d", method.numChanges, method.leadEndLength);
//	for (int pBell = 0; pBell < method.numChanges / method.leadEndLength; pBell++) {
//		CGContextShowTextAtPoint (context, textX, rect.size.height - 12.0f - pBell * scaleY * method.leadEndLength,
//								  "_", 1); 		
//	}
	
	
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	
	//CGAffineTransform cgAffineTransform = CGAffineTransformMakeTranslation(0.5f, 0.5f);
	
	// When I draw a line of width 1, I want it to have a width of 1, thankyou very much.
	CGContextTranslateCTM (context, 0.5f, 0.5f);
	
	//CGPoint CGPointZeroPointFive = CGPointMake(0.5f, 0.5f);

	
	// DRAW: background grid
	CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.6f green:0.9f blue:1.0f alpha:0.5f] CGColor] );

	for (float xLine = (actualLeftMargin % xGridDelta); xLine < rect.size.width; xLine += xGridDelta) {
		CGContextMoveToPoint(context, xLine, 0.0f);
		CGContextAddLineToPoint(context, xLine, rect.size.height);				
	}

//	for (float yLine = ((int)topMargin % (int)(2.0f*scaleY)); yLine <= rect.size.height; yLine += 2.0f * scaleY) {
//		CGContextMoveToPoint(context, 0.0f, yLine);
//		CGContextAddLineToPoint(context, rect.size.width, yLine);				
//	}
	
	/*
	CGContextMoveToPoint(context, 10.0f, 20.0f);
	CGContextAddLineToPoint(context, 10.0f, 60.0f);		

	CGContextMoveToPoint(context, 20.0f, 10.0f);
	CGContextAddLineToPoint(context, 60.0f, 10.0f);		
*/
	
	//Draw it
	CGContextStrokePath(context);

	CGContextSetLineWidth(context, 2.0f);
	
	//CGContextScaleCTM(context, 10.0f, 10.0f);

	//CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	
    // DRAW: the top black ruled linea across page

    //	CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f] CGColor]);
//
//	BLCoord *lineLeft = [BLCoord coordWithX:-0.5f Y:0.0f];
//	BLCoord *lineRight = [BLCoord coordWithX:method.numBells - 0.5f Y:0.0f];
//	
//	[self handDrawMoveToPoint:context coord:lineLeft];
//	[self handDrawAddLineToPoint:context coord:lineRight];
//	
//	lineLeft = [BLCoord coordWithX:-0.5f Y:method.numChanges-1];
//	lineRight = [BLCoord coordWithX:method.numBells - 0.5f Y:method.numChanges-1];
//	
//	[self handDrawMoveToPoint:context coord:lineLeft];
//	[self handDrawAddLineToPoint:context coord:lineRight];
//	
//	CGContextStrokePath(context);
	
	
	//Set the stroke (pen) color
	//CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);

	CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.6f] CGColor]);

	//[[UIColor colorWithRed:0.6f green:0.9f blue:1.0f alpha:0.5f] CGColor]
	
	NSMutableArray *pointsArray = blg.points;

	NSLog(@" points array = %d", [pointsArray count]);			  
								  
	//CGContextMoveToPoint(context, 20.0f, 20.0f);
	
	[self handDrawMoveToPoint:context coord:[pointsArray objectAtIndex:0]];
	
	for (int idx = 1; idx < [pointsArray count]; idx++) {
		[self handDrawAddLineToPoint:context coord:[pointsArray objectAtIndex:idx]];
	}
	
	CGContextStrokePath(context);
	
	CGContextRestoreGState(context);
}




@end
