//
//  FirstViewController.m
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import "CtrlCenterViewController.h"
#import "AppDelegate.h"
#import "Player.h"

@interface CtrlCenterViewController ()

@end

@implementation CtrlCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.lblTester.text = appDelegate.player1.name;
    self.lblBoughtPrice.text= [NSString stringWithFormat:@"$" "%.2f",[appDelegate.player1 getPortfolioBoughtPrice]];
    
}
-(void) viewDidAppear:(BOOL)animated{
    
    self.lblCash.text=[NSString stringWithFormat:@"$" "%.2f",appDelegate.player1.money];



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = self.title;
    self.lblBoughtPrice.text= [NSString stringWithFormat:@"$" "%.2f",[appDelegate.player1 getPortfolioBoughtPrice]];

}

@end
