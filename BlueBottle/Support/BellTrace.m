//
//  BellTrace.m
//  BlueLine
//
//  ** See header for comment
//
//
//  Created by alex hunsley on 18/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BellTrace.h"


@implementation BellTrace

@synthesize colour;
@synthesize segments;

- (void)dealloc {
	[colour release];
	[segments release];
	[super dealloc];
}

@end
