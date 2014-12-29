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
    self.lblNetWorth.text = [NSString stringWithFormat:@"$"@"%.2f",[self getPortfolioWorth]];
    self.lblTester.text = appDelegate.player1.name;
    
}
-(NSMutableArray*) getCurrentPrices{
    NSArray* symbolArray=[NSArray arrayWithArray:[appDelegate.player1 symbolsOwned]];
    NSMutableArray *currentPrices=[[NSMutableArray alloc]init];
    if (symbolArray.count<0) {
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

-(float) getPortfolioWorth{
    float portfolioNetWorth=0.0;
    NSString* currentPriceString;
    NSMutableArray* currentPrices = [self getCurrentPrices];
    for(NSString* cps in currentPrices){
        portfolioNetWorth = portfolioNetWorth+[cps floatValue];
    }
    return portfolioNetWorth;
}

@end
