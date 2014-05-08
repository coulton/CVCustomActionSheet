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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Your Basket"];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:(2.0/255.0) green:(109.0/255.0) blue:(184.0/255.0) alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showActionSheet {
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    CVCustomActionSheet *actionSheet = [[CVCustomActionSheet alloc] initWithDelegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Apples",@"Oranges",@"Bananas"]];
    [actionSheet show];
}

- (void)actionSheetButtonClicked:(CVCustomActionSheet *)actionSheet withButtonIndex:(NSNumber *)buttonIndex withButtonTitle:(NSString *)buttonTite {
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    NSLog(@"Pressed button (%@, %@)", buttonIndex, buttonTite);
}

- (void)actionSheetCancelled:(CVCustomActionSheet *)actionSheet {
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    NSLog(@"Cancelled CVCustomActionSheet");
}

@end
