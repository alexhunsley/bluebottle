//
//  CombinationProducer.m
//  BlueBottle
//
//  Created by alex hunsley on 02/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CombinationProducer.h"

// Produces numerical combinations on request for given ranges.
// e.g. if we want combos for (count_0, count_1, count_2),
// combos are produced with range: (0..count_0-1, 0..count_1-1, 0..count_2-1).
// A solid example:
// For combos with spec (2, 3), these are valid combo outputs:
// (0, 0)
// (1, 0)
// (0, 1)
// (1, 1)
// (0, 2)
// (1, 2)
//
// Combos produced can be completely random, or exhaustive random (random but 
// no repeats appear until the current combo space has been used up completely).
// If you use this class for exhaustive combinations, note that memory is used
// proportional to the amount of possible combinations (i.e. count_0*count_1*count_2*...)

@interface CombinationProducer ()

- (NSArray *)removeOneRandomlyFromComboPool;
- (NSArray *)removeFromComboPoolAtPosition:(int)pos;

@property (retain, nonatomic) NSMutableArray *comboPool;

@end


@implementation CombinationProducer

@synthesize comboPool;

- (id)initWithComboSpec:(NSArray *)comboSpecIn mode:(EComboMode)comboModeIn {
    if ((self = [super init])) {
        comboSpec = comboSpecIn;
        [comboSpec retain];
        comboMode = comboModeIn;
        lockedIndex = -1;
        lockedToValue = 0;
    }
    return self;
}

- (NSNumber *)randomIntUpTo:(int)max {
    return [NSNumber numberWithInt:rand() % max];
}

- (void)setupComboPool {
    self.comboPool = [NSMutableArray array];
    int comboSpecSize = [comboSpec count];

    int *currentIndexCount = malloc([comboSpec count] * sizeof(int));
    // TODO need this?
    memset(currentIndexCount, 0, sizeof(int) * comboSpecSize);
    
    if (lockedIndex >= 0) {
        currentIndexCount[lockedIndex] = lockedToValue;
    }
        
//    int currentIndex = 0;

    bool finished = false;    
    while (!finished) {
        NSMutableArray *combo = [NSMutableArray arrayWithCapacity:comboSpecSize];
        
        for (int i = 0; i < comboSpecSize; i++) {
            [combo addObject:[NSNumber numberWithInt:currentIndexCount[i]]];
        }
        [comboPool addObject:combo];
        NSLog(@" adding this combo to pool: %@", combo);
        int incrementIdx = -1;
        bool digitTickedOver;
        
        do {
            incrementIdx++;
            if (incrementIdx == comboSpecSize) {
                finished = true;
                break;
            }
            digitTickedOver = false;
            if (incrementIdx == lockedIndex) {
                digitTickedOver = true;

            }
            else {
                currentIndexCount[incrementIdx] += 1;
                if (currentIndexCount[incrementIdx] == [[comboSpec objectAtIndex:incrementIdx]  intValue]) {
                    currentIndexCount[incrementIdx] = 0;
                    digitTickedOver = true;
                }
            }
        } while (digitTickedOver);
    }
}

- (NSArray *)removeOneRandomlyFromComboPool {
    int idx = rand() % [comboPool count];
    return [self removeFromComboPoolAtPosition:idx];
}

- (NSArray *)removeFromComboPoolAtPosition:(int)pos {
    NSArray *obj = [[[comboPool objectAtIndex:pos] retain] autorelease];
    [comboPool removeObject:obj];
    return obj;    
}

- (NSArray *)nextCombo {
    int comboSpecSize = [comboSpec count];
    
    if (comboMode == COMBO_MODE_RANDOM) {

        NSMutableArray *combo = [NSMutableArray arrayWithCapacity:comboSpecSize];
        
        for (NSNumber *componentSize in comboSpec) {
            [combo addObject:[self randomIntUpTo:[componentSize intValue]]];
        }
        return combo;
    }

    if (![comboPool count]) {
        [self setupComboPool];
    }

    if (comboMode == COMBO_MODE_SEQUENTIAL) {
        return [self removeFromComboPoolAtPosition:0];
    }
    
    // comboMode == COMBO_MODE_RANDOM_EXHAUSTIVE
    if (![comboPool count]) {
        [self setupComboPool];
    }
    return [self removeOneRandomlyFromComboPool];
}

- (void)removeIndexLock {
    lockedIndex = -1;
    [self setupComboPool];
}

- (void)lockIndex:(int)idx toValue:(int)value {
    lockedIndex = idx;
    lockedToValue = value;
    [self setupComboPool];
}


- (void)dealloc {
    [comboPool release];
    [comboSpec release];
    [super dealloc];
}
@end
