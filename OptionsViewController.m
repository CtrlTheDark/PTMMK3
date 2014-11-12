//
//  OptionsViewController.m
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/11/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import "OptionsViewController.h"
#import "Player.h"
#import "AppDelegate.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.lblOldName.text=appDelegate.player1.name;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = self.title;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSave:(id)sender {
    appDelegate.player1.name=self.txtName.text;
    self.lblNewName.text=appDelegate.player1.name;
}
@end
