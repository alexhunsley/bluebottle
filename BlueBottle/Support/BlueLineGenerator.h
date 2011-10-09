//
//  BlueLineGenerator.h
//  BlueLine
//
//  Created by alex hunsley on 18/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Method;

@interface BlueLineGenerator : NSObject {

}

- (id)initWithMethod:(Method *)newMethod;
- (void)generateBlueLines;
//- (NSMutableArray *)generateLineForBell:(int)bell;
- (void)generateForBell:(int)bell;

@property (readonly, nonatomic) Method *method;
@property (retain, nonatomic) NSMutableArray *points;


@end
