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
    appDelegate.yql=[[YQL alloc] init];
    Player *player1 =[[Player alloc]init];
    self.player = player1;
    appDelegate.player1=self.player;
    if(appDelegate.player1.new==true){
        appDelegate.player1.name=@"Player";
        appDelegate.player1.money=1000.0;
        appDelegate.player1.portfolio= [NSMutableDictionary dictionary];
        appDelegate.player1.new=false;
    }
    //NSLog([NSString stringWithFormat:@"%@", appDelegate.player1.new]);
    [self loadData];
}
-(void) loadData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool new = [defaults boolForKey:@"playerNew"];
    if (new==false) {
        NSString *playerName = [defaults objectForKey:@"playerName"];
        double playerMoney =[defaults doubleForKey:@"playerMoney"];
        NSMutableDictionary *playerPortfolio = [[defaults objectForKey:@"playerPortfolio"] mutableCopy];
        double startingMoney= [defaults doubleForKey:@"playerStartingMoney"];
        appDelegate.player1.name=playerName;
        appDelegate.player1.money=playerMoney;
        appDelegate.player1.portfolio=playerPortfolio;
        appDelegate.player1.new=new;
        appDelegate.player1.startingMoney=startingMoney;
        
    }else{
        appDelegate.player1.name= @"Player";
        appDelegate.player1.money=100000.00;
        appDelegate.player1.portfolio =[NSMutableDictionary dictionary];
        appDelegate.player1.new =false;
        //NSLog([NSString stringWithFormat:@"%@", appDelegate.player1.new]);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
#pragma mark iAd Delagate Methods

-(void) bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}
-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}
@end
