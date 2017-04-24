//
//  SEGViewController.m
//  Segment-Facebook
//
//  Created by Prateek Srivastava on 11/10/2015.
//  Copyright (c) 2015 Prateek Srivastava. All rights reserved.
//

#import "SEGViewController.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
@interface SEGViewController ()

@end

@implementation SEGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FBSDKAppEvents logPurchase:4.89 currency:@"USD"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
