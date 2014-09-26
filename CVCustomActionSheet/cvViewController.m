//
//  cvViewController.m
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 Coulton Vento. All rights reserved.
//

#import "cvViewController.h"

@interface cvViewController ()

@end

@implementation cvViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Your Basket"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showActionSheet
{
    NSArray *buttons = @[ @"Apples", @"Oranges", @"Bananas", @"Oranges", @"Bananas", @"Bananas" ];
    CVCustomActionSheet *actionSheet = [[CVCustomActionSheet alloc] initWithButtons:buttons
                                                               andCancelButtonTitle:@"Cancel"];
    [actionSheet show];
}

@end
