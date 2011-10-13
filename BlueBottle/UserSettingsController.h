//
//  UserSettingsController.h
//  BlueBottle
//
//  Created by alex hunsley on 13/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CALLS_TYPE_NONE,
    CALLS_TYPE_BOBS,
    CALLS_TYPE_SINGLES,
    CALLS_TYPE_BOTH,
    CALLS_TYPE_SENTINEL
} CallsType;

@interface UserSettingsController : NSObject {
    
}
+ (void)setRealisticPBOrder:(bool)b;
+ (bool)realisticPBOrder;
+ (void)setCallsMode:(CallsType)b;
+ (CallsType)callsMode;

@end
