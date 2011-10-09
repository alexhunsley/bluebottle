//
//  BLCoord.h
//  BlueLine
//
//  Created by alex hunsley on 18/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLCoord : NSObject {

	
}

@property (readonly, nonatomic) float x;
@property (readonly, nonatomic) float y;

+ (BLCoord *)coordWithX:(float)xIn Y:(float)yIn;
- (id)initWithX:(float)xIn Y:(float)yIn;

@end
