//
//  BlueBottleViewController.m
//  BlueBottle
//
//  Created by alex hunsley on 23/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlueBottleViewController.h"
#import "MethodsDAO.h"
#import "CombinationProducer.h"
#import "BLOptionsViewController.h"
#import "UserSettingsController.h"
#import "Method.h"

@interface BlueBottleViewController () 

@property (retain, nonatomic) NSMutableArray *methodNames;
@property (nonatomic) int currMethod;
@property (nonatomic) int currPlaceBell;
@property (retain, nonatomic) CombinationProducer *comboProducer;

- (void)setupComboProducer;

@end

@implementation BlueBottleViewController
@synthesize blueLineView;
@synthesize methodNameView;
@synthesize methodLabel;
@synthesize stageLabel;
@synthesize lineOrNameToggleButton;

@synthesize methodNames;
@synthesize currMethod;
@synthesize currPlaceBell;
@synthesize methods;
@synthesize comboProducer;

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@" initWithCoder");
    if ((self = [super initWithCoder:aDecoder])) {
//        self.methodNames = [NSMutableArray arrayWithObjects:@"Cambridge", @"Yorkshire", @"Superlative", @"Lincolnshire", @"Rutland", @"Bristol", nil];
        showingBlueLine = false;
        if (!self.methods) {
            NSLog(@" LOADING METHODS");
            MethodsDAO *dao = [[MethodsDAO alloc] initWithFilename:@"bluebottleMethods.sqlite"];
            self.methods = [dao getAllMethods];
            //[dao release];
            
            [self setupComboProducer];
        }
        lockType = LOCK_TYPE_NONE;
    }
    return self;
}

- (void)setupComboProducer {
    if ([UserSettingsController realisticPBOrder]) {
        // We want a combo producer that provides methods.
        // The place bell is dictated by the last method's placebell.
        self.comboProducer = [[CombinationProducer alloc] initWithComboSpec:[NSArray arrayWithObjects:[NSNumber numberWithInt:[methods count]], nil] mode:COMBO_MODE_RANDOM_EXHAUSTIVE];        
    }
    else {
        // we want a combo producer that provides a place bells and methods per combo
        self.comboProducer = [[CombinationProducer alloc] initWithComboSpec:[NSArray arrayWithObjects:[NSNumber numberWithInt:[methods count]], [NSNumber numberWithInt:7], nil] mode:COMBO_MODE_RANDOM_EXHAUSTIVE];
    }
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    NSLog(@" initWithNibName");
//    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
//        
//    }
//    return self;
//}

- (void)dealloc
{
    [methodLabel release];
    [stageLabel release];
    [lineOrNameToggleButton release];
    [methods release];
    [blueLineView release];
    [methodNameView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
- (void)changeDisplay {
//    int newMethod = 0;
//    int newPlaceBell = 0;    
//    do {
////        newMethod = rand () % [methodNames count];
//        newMethod = rand () % [methods count];
//        newPlaceBell = 2 + rand () % 7;
//        
//    } while (newMethod == currMethod && newPlaceBell == currPlaceBell);
    //    currMethod = newMethod;
    //    currPlaceBell = newPlaceBell;
    
    NSArray *array = [comboProducer nextCombo];
   
    
    if ([UserSettingsController realisticPBOrder]) {
        Method *method = [methods objectAtIndex:currMethod];
        currPlaceBell = [method nextPlaceBellFromPlaceBell:currPlaceBell];
    }
    else {
        currPlaceBell = [[array objectAtIndex:1] intValue] + 2;
    }

     currMethod = [[array objectAtIndex:0] intValue];
                         

    NSLog(@" method, pb = %d, %d", currMethod, currPlaceBell);
    methodLabel.text = [[methods objectAtIndex:currMethod] title];
    stageLabel.text = [NSString stringWithFormat:@"%d", currPlaceBell];
    if (showingBlueLine) {
        [blueLineView setMethod:[methods objectAtIndex:currMethod] placeBell:currPlaceBell];
    }
}

- (void)viewDidLoad {
    [self changeDisplay];
}

- (void)viewDidUnload
{
    [self setMethodLabel:nil];
    [self setStageLabel:nil];
    [self setLineOrNameToggleButton:nil];
    [self setBlueLineView:nil];
    [self setMethodNameView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buttonPressed:(id)sender {
    NSLog(@" button pressed");
    [self changeDisplay];
}

- (IBAction)lineOrNameToggleButtonTouched:(id)sender {
    NSLog(@" Bang!");
    
    NSLog(@" all methods from DB = %@", methods);
    
    showingBlueLine = !showingBlueLine;
    
    if (showingBlueLine) {
        NSLog(@" show blue line!");
        
        [lineOrNameToggleButton setTitle:@"Name" forState:UIControlStateNormal];
        [lineOrNameToggleButton setTitle:@"Name" forState:UIControlStateHighlighted];
//        
//         
//         UIControlStateNormal               = 0,
//         UIControlStateHighlighted          = 1 << 0,
//         UIControlStateDisabled             = 1 << 1,
//         UIControlStateSelected     
         
        [blueLineView setMethod:[methods objectAtIndex:currMethod] placeBell:currPlaceBell];
        methodNameView.hidden = true;
        blueLineView.hidden = false;
    }
    else {
        NSLog(@" show method name!");
        [lineOrNameToggleButton setTitle:@"Line" forState:UIControlStateNormal];
        [lineOrNameToggleButton setTitle:@"Line" forState:UIControlStateHighlighted];
        
        blueLineView.hidden = true;
        methodNameView.hidden = false;
    }

}

- (IBAction)noLockButtonTouched:(id)sender {
    lockType = LOCK_TYPE_NONE;
    [comboProducer removeIndexLock];
}

- (IBAction)lockPlaceBellButtonTouched:(id)sender {
    lockType = LOCK_TYPE_PLACE_BELL;
    NSLog(@" lock place bell, currPlaceBell = %d", currPlaceBell);
    [comboProducer lockIndex:1 toValue:currPlaceBell - 2]; // because we have a 2 offset elsewhere
}

- (IBAction)lockMethodButtonTouched:(id)sender {
    lockType = LOCK_TYPE_METHOD;
    [comboProducer lockIndex:0 toValue:currMethod];
}

- (IBAction)optionsButtonTouched:(id)sender {
    BLOptionsViewController *optionsVC = [[BLOptionsViewController alloc] init];
    [self presentModalViewController:optionsVC animated:YES];
    [optionsVC release];
}

@end


