//
//  ViewController.m
//  Radius
//
//  Created by Siddhant Dange on 10/6/13.
//  Copyright (c) 2013 Siddhant Dange. All rights reserved.
//

#import "LoginViewController.h"
#import "FBManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)loginClicked:(id)sender {
    [[FBManager sharedInstance] openSessionWithMeWithCompletionBlock:^(id result, NSError *error) {
        if(!error){
            NSLog(@"result: %@", result);
            [self dismissViewControllerAnimated:YES completion:nil];
        } else{
            NSLog(@"error: %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
