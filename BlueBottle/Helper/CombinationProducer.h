//
//  CombinationProducer.h
//  BlueBottle
//
//  Created by alex hunsley on 02/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    COMBO_MODE_SEQUENTIAL,
    COMBO_MODE_RANDOM,
    COMBO_MODE_RANDOM_EXHAUSTIVE,
    COMBO_MODE_SENTINEL  
} EComboMode;


@interface CombinationProducer : NSObject {
    NSArray *comboSpec;
    EComboMode comboMode;
}

- (id)initWithComboSpec:(NSArray *)comboSpecIn mode:(EComboMode)comboModeIn;
- (NSArray *)nextCombo;

  
    
@end
