//
//  MainViewController.m
//  Radius
//
//  Created by Siddhant Dange on 10/6/13.
//  Copyright (c) 2013 Siddhant Dange. All rights reserved.
//

#import "MainViewController.h"
#import "FBManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if(![[FBManager sharedInstance] checkFacebookLoggedIn]){
        [self performSegueWithIdentifier:@"LoginModal" sender:self];
    } else{
        [[FBManager sharedInstance] openSessionFromCacheWithCompletionBlock:^(id result, NSError *error) {
            
            NSLog(@"fb info2: %@", result);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
