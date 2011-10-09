//
//  BellTrace.h
//  BlueLine
//
//  Comprises one or more segments. A segment is a collection of points
//  which forms a wriggly line.
//
//  Created by alex hunsley on 18/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BellTrace : NSObject {

}

@property (retain, nonatomic) UIColor *colour;
// each segment in this array is a further NSArray containing points!
@property (retain, nonatomic) NSMutableArray *segments;

@end
