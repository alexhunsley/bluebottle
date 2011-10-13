//
//  Method.m
//  BlueLine
//
//  Created by alex hunsley on 09/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Method.h"

static NSString *roundsTemplate = @"1234567890ET";

@interface Method ()

- (void)prickMethod;

@end


@implementation Method

@synthesize title;
@synthesize numBells;
@synthesize placeNotation;
@synthesize leadEndLength;
@synthesize methodLength;
@synthesize changes;
@synthesize numChanges;
@synthesize rounds;
@synthesize leadEnd;
@synthesize placeBellOrder;

#pragma mark -
#pragma mark Init, dealloc

- (id)initWithTitle:(NSString*)newTitle numBells:(int)newNumBells
		   notation:(NSString*)newPlaceNotation leadEnd:(NSString *)newLeadEnd {
	if ((self = [super init])) {
		title = newTitle;
        [title retain];
		numBells = newNumBells;
		placeNotation = newPlaceNotation;
        [placeNotation retain];
        leadEnd = newLeadEnd;
        [leadEnd retain];
		rounds = [roundsTemplate substringToIndex:numBells];
        [rounds retain];
		changes = [NSMutableArray arrayWithCapacity:1000];
        [changes retain];
        leadEndLength = 0;
		[self prickMethod];
	}
	return self;
}

- (void)dealloc {
	[title release];
	[placeNotation release];
	[changes release];
    [leadEnd release];
	[super dealloc];
}

#pragma mark -
#pragma mark Helpers

- (void)outputChanges {
	
}

// assume PN is in normalized form (not canonical where bits are missing)
- (void)prickMethod {
	[changes addObject:rounds];
	
	NSArray* PN = [placeNotation componentsSeparatedByString:@"."];
	NSMutableArray* singlePN = [NSMutableArray arrayWithArray:PN];

    NSString *lastItem = [singlePN objectAtIndex:[singlePN count] - 1];
    
    if ([lastItem isEqualToString:@"&"]) {
        [singlePN removeLastObject];
        NSMutableArray *pnCopy = [singlePN mutableCopy];
        [pnCopy removeLastObject];
        NSEnumerator *reverseEnum = [pnCopy reverseObjectEnumerator];
        NSArray *reverseAllObjects = [reverseEnum allObjects];
        //NSLog(@" reverseAllObjects: %@", reverseAllObjects);
        [singlePN addObjectsFromArray:reverseAllObjects];
    }
    // TODO why is our reversed list not getting added? Object identity problem?
    [singlePN addObject:leadEnd];

    leadEndLength = [singlePN count];
    
	//NSLog(@" pns = %@", singlePN);
	
	int change = 1;
	
	NSString *oldChange = [changes objectAtIndex:change - 1];
	

	NSRange range = {0, 1};
	NSRange range2 = {0, 1};
	
	NSMutableString *currChange;
	NSMutableString *pbOrder = [NSMutableString string];
    
    //[NSMutableString stringWithString:@"2"];
	do {
        [pbOrder appendFormat:@"%d", 1 + [oldChange rangeOfString:@"2"].location];
		for (NSString *currPN in singlePN) {
			currChange = [NSMutableString stringWithCapacity:numBells];
			
			for (int i = 0; i < numBells; i++) {
				range.location = i;
				NSString *t = [roundsTemplate substringWithRange:range];
				//NSLog(@" t = %@", t);
				if ([currPN rangeOfString:t].location == NSNotFound) {
					range2.location = i + 1;
					[currChange appendString:[oldChange substringWithRange:range2]];
					[currChange appendString:[oldChange substringWithRange:range]];
					i += 1;
				}
				else {
					[currChange appendString:[oldChange substringWithRange:range]];
				}
			}
			//NSLog(@" new change = %@", currChange);
			oldChange = currChange;
			[changes addObject:currChange];
		}
        //NSLog(@" ----------- FINI a bit of PN!");
	} while (! [currChange isEqualToString:rounds]);
	
    placeBellOrder = [[pbOrder description] retain];
    //NSLog(@" pbOrder= %@", placeBellOrder);
    
	//NSLog(@"%@", changes);
	numChanges = [changes count];
	leadEndLength = [singlePN count];
}

- (int)nextPlaceBellFromPlaceBell:(int)currPlaceBell {
    int idx = [placeBellOrder rangeOfString:[NSString stringWithFormat:@"%d", currPlaceBell]].location;
    idx++;
    if (idx >= [placeBellOrder length]) {
        idx = 0;
    }
    return [placeBellOrder characterAtIndex:idx] - '0';  
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(Method: %@, %d, %@, %@, %@)", title, numBells, placeNotation, leadEnd, placeBellOrder];
}
@end
