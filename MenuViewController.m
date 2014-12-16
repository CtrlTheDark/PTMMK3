//
//  MenuViewController.m
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import "MenuViewController.h"
#import "Player.h"
#import "CtrlCenterViewController.h"
#import "AppDelegate.h"

@interface MenuViewController ()



@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    Player *player1 = [[Player alloc] init];
    appDelegate.yql=[[YQL alloc] init];
    self.player = player1;
    self.lblActivePlayer.text = [NSString stringWithFormat:@"Active Player is %@",player1.name];
    NSLog(@"Menu Player Before Set");
    NSLog(@"%@",appDelegate.player1.name);
    appDelegate.player1=self.player;
    NSLog(@"Menu Player After Set");
    NSLog(@"%@",appDelegate.player1.name);

}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.lblActivePlayer.text=appDelegate.player1.name;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

   // CtrlCenterViewController *transferViewController = segue.destinationViewController;
    
    NSLog(@"segueMenuToGame: %@", segue.identifier);
   // if([segue.identifier isEqualToString:@"segueMenuToGame"])
   // {
   //     transferViewController.player = self.player;
   // }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
