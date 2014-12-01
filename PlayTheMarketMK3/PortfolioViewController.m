//
//  SecondViewController.m
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import "PortfolioViewController.h"
#import "Player.h"
#import "AppDelegate.h"
#import "PortfolioTableView.h"

@interface PortfolioViewController ()
@end

@implementation PortfolioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    PortfolioTableView *table =[[PortfolioTableView alloc]init];
    table.colors= [[NSArray alloc] initWithObjects: @"Red", @"Yellow", @"Green",@"Blue", @"Purpole", nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = self.title;
    appDelegate = [[UIApplication sharedApplication] delegate];
}

@end
