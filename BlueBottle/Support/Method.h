//
//  Method.h
//  BlueLine
//
//  Created by alex hunsley on 09/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Method : NSObject {

}

@property (retain, nonatomic) NSString* title;
@property (nonatomic) int numBells;
@property (retain, nonatomic) NSString* placeNotation;
@property (nonatomic) int leadEndLength;
@property (nonatomic) int methodLength;
@property (readonly, nonatomic) NSMutableArray *changes;
@property (readonly, nonatomic) int numChanges;
@property (nonatomic, retain) NSString *rounds;
@property (nonatomic, retain) NSString *leadEnd;
@property (nonatomic, retain) NSString *placeBellOrder;


- (id)initWithTitle:(NSString*)newTitle numBells:(int)newNumBells
		   notation:(NSString*)newPlaceNotation leadEnd:(NSString *)newLeadEnd;
- (int)nextPlaceBellFromPlaceBell:(int)currPlaceBell;

@end
