//
//  BlueBottleViewController.h
//  BlueBottle
//
//  Created by alex hunsley on 23/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueBottleViewController : UIViewController {
    
    UILabel *methodLabel;
    UILabel *stageLabel;
}
- (IBAction)buttonPressed:(id)sender;
@property (nonatomic, retain) IBOutlet UILabel *methodLabel;
@property (nonatomic, retain) IBOutlet UILabel *stageLabel;

@end
