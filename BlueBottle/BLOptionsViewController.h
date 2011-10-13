//
//  BLOptionsViewController.h
//  BlueBottle
//
//  Created by alex hunsley on 12/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BLOptionsViewController : UIViewController {
    
    UIView *callsView;
    UISwitch *pbOrderSwitch;
    UISegmentedControl *callsTypeSegment;
}
- (IBAction)placeBellOrderToggleChanged:(id)sender;
- (IBAction)callsSegmentedValueChanged:(id)sender;
@property (nonatomic, retain) IBOutlet UIView *callsView;
@property (nonatomic, retain) IBOutlet UISwitch *pbOrderSwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl *callsTypeSegment;

@end
