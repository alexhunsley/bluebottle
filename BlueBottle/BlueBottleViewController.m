//
//  BlueBottleViewController.m
//  BlueBottle
//
//  Created by alex hunsley on 23/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlueBottleViewController.h"

@interface BlueBottleViewController () 

@property (retain, nonatomic) NSMutableArray *methodNames;
@property (nonatomic) int currMethod;
@property (nonatomic) int currPlaceBell;

@end

@implementation BlueBottleViewController
@synthesize methodLabel;
@synthesize stageLabel;

@synthesize methodNames;
@synthesize currMethod;
@synthesize currPlaceBell;

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@" initWithCoder");
    if ((self = [super initWithCoder:aDecoder])) {
        self.methodNames = [NSMutableArray arrayWithObjects:@"Cambridge", @"Yorkshire", @"Superlative", @"Lincolnshire", @"Rutland", @"Bristolgr", nil];
    }
    return self;
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
    int newMethod = 0;
    int newPlaceBell = 0;
    
    do {
        newMethod = rand () % [methodNames count];
        newPlaceBell = 2 + rand () % 7;
        
    } while (newMethod == currMethod && newPlaceBell == currPlaceBell);
    currMethod = newMethod;
    currPlaceBell = newPlaceBell;
    methodLabel.text = [methodNames objectAtIndex:currMethod];
    stageLabel.text = [NSString stringWithFormat:@"%d", currPlaceBell];
}

- (void)viewDidLoad {
    [self changeDisplay];
}

- (void)viewDidUnload
{
    [self setMethodLabel:nil];
    [self setStageLabel:nil];
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
@end


