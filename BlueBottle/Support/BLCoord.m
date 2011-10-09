//
//  BLCoord.m
//  BlueLine
//
//  Created by alex hunsley on 18/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BLCoord.h"


@implementation BLCoord

@synthesize x;
@synthesize y;

+ (BLCoord *)coordWithX:(float)xIn Y:(float)yIn {
	return [[[BLCoord alloc] initWithX:xIn Y:yIn] autorelease];
}	

- (id)initWithX:(float)xIn Y:(float)yIn {
	if (self == [super init]) {
		x = xIn;
		y = yIn;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"(%f, %f)", x, y];
}

@end
