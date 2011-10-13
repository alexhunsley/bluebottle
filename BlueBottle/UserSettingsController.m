//
//  UserSettingsController.m
//  BlueBottle
//
//  Created by alex hunsley on 13/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserSettingsController.h"


#define PREF_PB_ORDER @"PREF_PB_ORDER"
#define PREF_CALLS_TYPE @"PREF_CALLS_TYPE"

@implementation UserSettingsController

+ (void)setRealisticPBOrder:(bool)b {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:b forKey:PREF_PB_ORDER];    
}

+ (bool)realisticPBOrder {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults boolForKey:PREF_PB_ORDER]; 
}

+ (void)setCallsMode:(CallsType)callsType {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:callsType forKey:PREF_CALLS_TYPE];    
}

+ (CallsType)callsMode {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults integerForKey:PREF_CALLS_TYPE]; 
}


@end
