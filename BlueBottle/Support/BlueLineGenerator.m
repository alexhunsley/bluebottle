//
//  BlueLineGenerator.m
//  BlueLine
//
//  Created by alex hunsley on 18/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlueLineGenerator.h"
#import "Method.h"
#import "BLCoord.h"

@implementation BlueLineGenerator

@synthesize method;
@synthesize points;

- (id)initWithMethod:(Method *)newMethod {
	if ((self = [super init])) {
		method = newMethod, [method retain];
	}
	return self;
}

- (NSMutableArray *)generateLineForBell:(int)bell {
	NSString *bellStr = [NSString stringWithFormat:@"%d", bell];
	
	NSMutableArray *pointsGen = [NSMutableArray arrayWithCapacity:100];
	
	
	int bellPos = bell - 1;
	int currentMoveDir = -10; // unknown direction

	[pointsGen addObject:[BLCoord coordWithX:bellPos Y:0]];
	
	int currChange = 1;
	int lineStartChange = currChange;
	
	//NSLog(@" numchanges = %d",  method.numChanges);
	
	do {
		NSString *changeStr = [method.changes objectAtIndex:currChange];
		NSRange range = [changeStr rangeOfString:bellStr];
		int newBellPos = range.location;
		int newMoveDir = newBellPos - bellPos;
		//NSLog(@" newMoveDir = %d", newMoveDir);
		if (currentMoveDir >= -1 && newMoveDir != currentMoveDir) {
			[pointsGen addObject:[BLCoord coordWithX:bellPos Y:currChange - 1]];
			currentMoveDir = newMoveDir;
			lineStartChange = currChange;
		}
		
		currentMoveDir = newMoveDir;
		bellPos = newBellPos;
		currChange++;
//		if (currChange == method.numChanges) {
		if ((currChange % method.leadEndLength) == 1) {
			break;
		}
	} while (YES);
	
	[pointsGen addObject:[BLCoord coordWithX:bellPos Y:currChange - 1]];

	return pointsGen;
}

- (void)generateBlueLines {
	self.points = [self generateLineForBell:2];
	NSLog(@" points = %@", points);
}

- (void)generateForBell:(int)bell {
	self.points = [self generateLineForBell:bell];
	NSLog(@" points = %@", points);    
}

- (void)dealloc {
	[method release];
	[super dealloc];
}

@end
