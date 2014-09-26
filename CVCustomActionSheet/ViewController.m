//
//  cvViewController.m
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 Coulton Vento. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showActionSheet
{
    NSArray *buttons = @[ @"Apples", @"1", @"2", @"3", @"4" ];
    CVCustomActionSheet *actionSheet = [[CVCustomActionSheet alloc] initWithOptions:buttons
                                                               andCancelButtonTitle:@"Cancel"];
    
    [actionSheet show:nil
        optionPressed:^(NSInteger buttonIndex, NSString *buttonTitle) {
           
            NSLog(@"Pressed button: %@ (%ld)", buttonTitle, (long)buttonIndex);
        }];
}

@end
