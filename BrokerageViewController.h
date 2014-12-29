//
//  BrokerageViewController.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "AppDelegate.h"
#import "YQL.h"

@interface BrokerageViewController : UIViewController
{
    AppDelegate *appDelegate;
    //YQL *yql;
}
@property NSUserDefaults *dataSaver;
@property Player *player;
@property (weak, nonatomic) IBOutlet UITextField *txtSymbol;
@property (weak, nonatomic) IBOutlet UITextField *txtShares;
- (IBAction)btnBuy:(id)sender;
- (IBAction)btnSell:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCost;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyLeft;

-(void) buyStockTransaction: (NSString *)symbol numberOfShares:(NSString *) shares;
-(void) sellStockTransaction:(NSString *)symbol numberOfShares:(NSString *) shares forPlayer:(Player *)p1;
-(double) getStockPrice:(NSString *) stockSymbol;
-(double) getBidPrice:(NSString *)stockSymbol;
-(void) addToPortfolioNew:(NSString *)symbol numberOfShares:(int)shares atPrice:(double)price;
-(void) determineHowToAdd:(NSString *)symbol numberOfShares:(int)shares atPrice:(double)price;
-(void) addToPortfolioCurrent:(NSString *)symbol numberOfShares:(int)shares atPrice:(double)price;
-(NSString*) averagePricePaidForStocks:(NSString *)symbol numberOFNewlyBought:(int) newStocks forPrice:(double) newPrice;
-(void) removeFromPortfolioOne:(NSString *)symbol fromPlayer:(Player *) player;
-(void) saveData;
@end
