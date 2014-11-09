//
//  FirstViewController.m
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import "CtrlCenterViewController.h"

@interface CtrlCenterViewController ()

@end

@implementation CtrlCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = self.title;
}

@end
