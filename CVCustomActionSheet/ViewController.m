//
//  cvViewController.m
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 Coulton Vento. All rights reserved.
//

#import "ViewController.h"
#import "CVCustomActionSheet.h"
#import "CVCustomAction.h"
#import "CVCustomActionSheetButtonConfiguration.h"

@interface ViewController ()

@property (nonatomic) CVCustomActionSheet *actionSheet;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showActionSheet
{
    self.actionSheet = [[CVCustomActionSheet alloc] init];
    
    // Style (opt)
    CVCustomActionSheetButtonConfiguration *config = [CVCustomActionSheetButtonConfiguration configurationWithTextColor:[UIColor whiteColor]
                                                                                                        backgroundColor:[UIColor blueColor]
                                                                                                                   font:[UIFont systemFontOfSize:12]];
    [self.actionSheet setButtonConfiguration:config forType:CVCustomActionTypeCancel selected:NO];
    
    // Add actions
    NSArray *fruits = @[@"Apples", @"Oranges", @"Bananas", @"Peaches", @"Grapes", @"Blueberries"];
    for (NSString *fruit in fruits) {
        [self.actionSheet addAction:[CVCustomAction actionWithTitle:fruit
                                                               type:CVCustomActionTypeDefault
                                                            handler:^(CVCustomAction *action) {
                                                                NSLog(@"%@", fruit);
                                                            }]];
    }
    
    [self.actionSheet addAction:[CVCustomAction actionWithTitle:@"Cancel"
                                                           type:CVCustomActionTypeCancel
                                                        handler:^(CVCustomAction *action) {
                                                            NSLog(@"Cancel");
                                                        }]];
    
    // Display
    [self.actionSheet show];
}

@end
