//
//  BrokerageViewController.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Player.h"
#import "AppDelegate.h"
#import "YQL.h"

@interface BrokerageViewController : UIViewController <ADBannerViewDelegate>
{
    AppDelegate *appDelegate;
    //YQL *yql;
}
@property NSUserDefaults *dataSaver;
@property Player *player;
@property (weak, nonatomic) IBOutlet UITextField *txtSymbol;
@property (weak, nonatomic) IBOutlet UITextField *txtShares;
@property (weak, nonatomic) IBOutlet UIButton *buttonBuy;
@property (weak, nonatomic) IBOutlet UIButton *buttonCalcBuy;
@property (weak, nonatomic) IBOutlet UIButton *buttonSell;
@property (weak, nonatomic) IBOutlet UIButton *buttonCalcSell;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aivPleaseWait;
- (IBAction)btnBuy:(id)sender;
- (IBAction)btnSell:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCost;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblNotification;
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionString;
- (IBAction)btnCalcBuy:(id)sender;
- (IBAction)btnCalcSell:(id)sender;



-(double) buyStockTransaction: (NSString *)symbol numberOfShares:(NSString *) shares;
-(double) buyStockCalculation: (NSString *)symbol numberOfShares:(NSString *) shares;
-(double) sellStockTransaction:(NSString *)symbol numberOfShares:(NSString *) shares forPlayer:(Player *)p1;
-(double) sellStockCalculation:(NSString *)symbol numberOfShares:(NSString *) shares;
-(double) getStockPrice:(NSString *) stockSymbol;
-(double) getBidPrice:(NSString *)stockSymbol;
-(void) addToPortfolioNew:(NSString *)symbol numberOfShares:(int)shares atPrice:(double)price;
-(void) determineHowToAdd:(NSString *)symbol numberOfShares:(int)shares atPrice:(double)price;
-(void) addToPortfolioCurrent:(NSString *)symbol numberOfShares:(int)shares atPrice:(double)price;
-(NSString*) averagePricePaidForStocks:(NSString *)symbol numberOFNewlyBought:(int) newStocks forPrice:(double) newPrice;
-(void) removeFromPortfolioOne:(NSString *)symbol fromPlayer:(Player *) player;
-(void) saveData;
-(BOOL) properInput;
-(void) startWaiting;
-(void) endWaiting;
@end
