//
//  BlueBottleViewController.h
//  BlueBottle
//
//  Created by alex hunsley on 23/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueLineView.h"

typedef enum {
    LOCK_TYPE_NONE,
    LOCK_TYPE_PLACE_BELL,
    LOCK_TYPE_METHOD,
    LOCK_TYPE_SENTINEL
} LockType;


@interface BlueBottleViewController : UIViewController {
    
    UILabel *methodLabel;
    UILabel *stageLabel;
    UIButton *lineOrNameToggleButton;
    bool showingBlueLine;
    NSArray *methods;
    BlueLineView *blueLineView;
    UIView *methodNameView;
    LockType lockType;
}
- (IBAction)buttonPressed:(id)sender;
@property (nonatomic, retain) IBOutlet UILabel *methodLabel;
@property (nonatomic, retain) IBOutlet UILabel *stageLabel;
@property (nonatomic, retain) IBOutlet UIButton *lineOrNameToggleButton;
@property (nonatomic, retain) NSArray *methods;

- (IBAction)lineOrNameToggleButtonTouched:(id)sender;
@property (nonatomic, retain) IBOutlet BlueLineView *blueLineView;
@property (nonatomic, retain) IBOutlet UIView *methodNameView;
- (IBAction)noLockButtonTouched:(id)sender;
- (IBAction)lockPlaceBellButtonTouched:(id)sender;
- (IBAction)lockMethodButtonTouched:(id)sender;
- (IBAction)optionsButtonTouched:(id)sender;

@end
