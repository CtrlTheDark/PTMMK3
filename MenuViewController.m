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

@interface MenuViewController ()



@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Player *player1 = [[Player alloc] init];
    self.player = player1;
    self.lblActivePlayer.text = [NSString stringWithFormat:@"Active Player is %@",player1.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
