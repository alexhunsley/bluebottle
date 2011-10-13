//
//  BLOptionsViewController.m
//  BlueBottle
//
//  Created by alex hunsley on 12/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BLOptionsViewController.h"

#define PREF_PB_ORDER @"PREF_PB_ORDER"
#define PREF_CALLS_TYPE @"PREF_CALLS_TYPE"

typedef enum {
    CALLS_TYPE_NONE,
    CALLS_TYPE_BOBS,
    CALLS_TYPE_SINGLES,
    CALLS_TYPE_BOTH,
    CALLS_TYPE_SENTINEL
} CallsType;

@implementation BLOptionsViewController
@synthesize callsView;
@synthesize pbOrderSwitch;
@synthesize callsTypeSegment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [callsView release];
    [pbOrderSwitch release];
    [callsTypeSegment release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    pbOrderSwitch.on = [standardUserDefaults boolForKey:PREF_PB_ORDER];
    callsTypeSegment.selectedSegmentIndex = [standardUserDefaults integerForKey:PREF_CALLS_TYPE];
    
    NSLog(@" !! viewDidLoad, set toggle to %d", pbOrderSwitch.on);
    
    if (!pbOrderSwitch.on) {
        callsView.alpha = 0.0f;
    }

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCallsView:nil];
    [self setPbOrderSwitch:nil];
    [self setCallsTypeSegment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void)writePrefs {
//}

- (IBAction)placeBellOrderToggleChanged:(id)sender {
    UISwitch *pbOrderToggle = (UISwitch *)sender;
    float newAlpha = pbOrderToggle.on ? 1.0f : 0.0f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    callsView.alpha = newAlpha;
    [UIView commitAnimations];

    NSLog(@" !! place bell action, toggle set to %d", pbOrderToggle.on);

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:pbOrderToggle.on forKey:PREF_PB_ORDER];
}

- (IBAction)callsSegmentedValueChanged:(id)sender {
    NSLog(@" calls segment changed action");
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:callsTypeSegment.selectedSegmentIndex forKey:PREF_CALLS_TYPE];
}

- (IBAction)doneButtonTouched:(id)sender {
    NSLog(@" DONE!");
    [self dismissModalViewControllerAnimated:YES];
}
@end
