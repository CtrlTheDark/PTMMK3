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
#import "YQL.h"
#import <UIKit/UIKit.h>//NSMutableAttributedString
#import <Foundation/Foundation.h>

@interface CtrlCenterViewController ()

@end

@implementation CtrlCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float netWorth;
    appDelegate = [[UIApplication sharedApplication] delegate];
    if([appDelegate.yql hasInternet]) {
        netWorth=[self getPortfolioWorth];
        self.lblNetWorth.text=[NSString stringWithFormat:@"$%.2f",netWorth];
        self.lblProfitLoss.attributedText=[self calcPofitLoss:netWorth];
    }else{
        self.lblNetWorth.text=@"Offline";
        self.lblProfitLoss.text=@"Offline";
    }
    self.lblBoughtPrice.text= [NSString stringWithFormat:@"$" "%.2f",[appDelegate.player1 getPortfolioBoughtPrice]];
    self.lblstartingMoney.text=[NSString stringWithFormat:@"$%.2f",appDelegate.player1.startingMoney];
    self.lblTester.text = appDelegate.player1.name;
    self.lblCash.text=[NSString stringWithFormat:@"$" "%.2f",appDelegate.player1.money];
}
//-(void) viewDidAppear:(BOOL)animated{
    
    //self.lblCash.text=[NSString stringWithFormat:@"$" "%.2f",appDelegate.player1.money];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    float netWorth=0.0;
    [super viewWillAppear:animated];
    if([appDelegate.yql hasInternet]) {
        netWorth=[self getPortfolioWorth];
        //if networth = 0.0.....
        self.lblNetWorth.text=[NSString stringWithFormat:@"$%.2f",netWorth];
        self.lblProfitLoss.attributedText=[self calcPofitLoss:netWorth];
    }else{
        self.lblNetWorth.text=@"Offline";
        self.lblProfitLoss.text=@"Offline";
    }
    self.lblstartingMoney.text=[NSString stringWithFormat:@"$%.2f",appDelegate.player1.startingMoney];
    self.tabBarController.title = self.title;
    self.lblBoughtPrice.text= [NSString stringWithFormat:@"$" "%.2f",[appDelegate.player1 getPortfolioBoughtPrice]];
    self.lblCash.text=[NSString stringWithFormat:@"$" "%.2f",appDelegate.player1.money];
}

-(NSMutableArray*) getCurrentPrices{
    NSArray* symbolArray=[NSArray arrayWithArray:[appDelegate.player1 symbolsOwned]];
    NSMutableArray *currentPrices=[[NSMutableArray alloc]init];
    if (symbolArray.count>0) {
        NSString* marketPricesQuery= [appDelegate.player1 arrayToSymbolString:symbolArray];
        NSDictionary* results = [appDelegate.yql query:marketPricesQuery];
        NSString *resultString =[[results valueForKeyPath:@"query.results"] description];
        NSArray *components = [resultString componentsSeparatedByString: @"\""];
        int counter=1;
        while (counter < components.count) {
            if ([components[counter] isEqualToString:@"0.00"] != true) {
                [currentPrices addObject:components[counter]];
            }else{
                [currentPrices addObject:components[counter+2]];
            }
            counter=counter+4;
        }
        return currentPrices;
    }
    else{
        //empty array
        return currentPrices;
        }
    }

-(NSMutableAttributedString*) calcPofitLoss:(float)netWorth{
    float profitLossFloat=0.0;
    float startingMoney=appDelegate.player1.startingMoney;
    float cash= appDelegate.player1.money;
    NSString* profitLossString;
    profitLossFloat=(netWorth+cash)-startingMoney;
    profitLossString =[NSString stringWithFormat:@"$%.2f",profitLossFloat];
    NSMutableAttributedString* moneyInColor= [ [NSMutableAttributedString alloc] initWithString:profitLossString ];
    if(profitLossFloat>0.0){
        [moneyInColor beginEditing];
        [moneyInColor addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, moneyInColor.length)];
        [moneyInColor endEditing];
    }else if(profitLossFloat<0.0){
        [moneyInColor beginEditing];
        [moneyInColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, moneyInColor.length)];
        [moneyInColor endEditing];
    }else{
        [moneyInColor beginEditing];
        [moneyInColor addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, moneyInColor.length)];
        [moneyInColor endEditing];
    }
    return moneyInColor;
}

-(float) getPortfolioWorth{
    float portfolioNetWorth=0.0;
    int numberOfShares=0;
    int i=0;
    if([appDelegate.yql hasInternet]) {
        NSMutableArray* currentPrices = [self getCurrentPrices];
        for(NSString* symbol in appDelegate.player1.portfolio){
            numberOfShares= [appDelegate.player1 getnumberOfSharesOwned:symbol];
            portfolioNetWorth = portfolioNetWorth+([currentPrices[i] floatValue]*numberOfShares);
            i++;
        }
        return portfolioNetWorth;
    }
    else{
        return 0.0;
    }
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
