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
    self.dataSaver = [NSUserDefaults standardUserDefaults];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = self.title;
    self.lblNewGame.hidden=true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//- (IBAction)startNewGame:(id)sender {
 //   appDelegate.player1.name=self.txtName.text;
 //   [self.dataSaver setBool:true forKey:@"playerNew"];
  //  NSLog(@"saved new as true");
//}
- (IBAction)startNewGame:(id)sender {
    appDelegate.player1.portfolio= [NSMutableDictionary dictionary];
    NSLog([NSString stringWithFormat:@"%@",appDelegate.player1.new]);
    appDelegate.player1.name=self.txtName.text;
    NSLog([NSString stringWithFormat:@"%@",appDelegate.player1.name]);
    if([appDelegate.player1.name isEqualToString:@"AprJor"]){
        [appDelegate.player1 addToPortfolio:@"PBHC" withDetails:[NSArray arrayWithObjects:@"1000000",@"0.0", nil]];
    }else if([appDelegate.player1.name isEqualToString:@"SydH"]){
        [appDelegate.player1 addToPortfolio:@"TIGR" withDetails:[NSArray arrayWithObjects:@"1",@"0.0", nil]];
        [appDelegate.player1 addToPortfolio:@"BEAT" withDetails:[NSArray arrayWithObjects:@"1",@"0.0", nil]];
    }
    //[self.dataSaver setBool:true forKey:@"playerNew"];
    if(self.segMoneyStart.selectedSegmentIndex==0){
        appDelegate.player1.money=1000.0;
        appDelegate.player1.startingMoney=1000.0;
    }else if(self.segMoneyStart.selectedSegmentIndex==1){
        appDelegate.player1.money=10000.0;
        appDelegate.player1.startingMoney=10000.0;
    }else if(self.segMoneyStart.selectedSegmentIndex==2){
        appDelegate.player1.money=100000.0;
        appDelegate.player1.startingMoney=100000.0;
    }else if(self.segMoneyStart.selectedSegmentIndex==3){
        appDelegate.player1.money=1000000.0;
        appDelegate.player1.startingMoney=1000000.0;
    }
    [self saveData];
    self.lblNewGame.hidden=false;
    self.lblNewGame.text=[NSString stringWithFormat:@"New Game Started, Good Luck %@!",appDelegate.player1.name];
    [self.txtName resignFirstResponder];
    //appDelegate.player1.new=true;
}
-(void) saveData{
    NSString *storedName=appDelegate.player1.name;
    [self.dataSaver setObject:storedName forKey:@"playerName"];
    [self.dataSaver setDouble:appDelegate.player1.money forKey:@"playerMoney"];
    [self.dataSaver setObject:appDelegate.player1.portfolio forKey:@"playerPortfolio"];
    [self.dataSaver setBool:appDelegate.player1.new forKey:@"playerNew"];
    [self.dataSaver setDouble:appDelegate.player1.startingMoney forKey:@"playerStartingMoney"];
    [self.dataSaver synchronize];
    NSLog(@"Data saved");
}
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
