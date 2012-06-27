//
//  ITVViewController.m
//  AlphabetTable
//
//  Created by Bryce Redd on 6/27/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "ITVViewController.h"

@interface ITVViewController ()

@end

@implementation ITVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
