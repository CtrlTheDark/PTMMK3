//
//  BrokerageViewController.m
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import "BrokerageViewController.h"
#import "Player.h"
#import "AppDelegate.h"
#import "YQL.h"

@interface BrokerageViewController ()

@end

@implementation BrokerageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    yql = [[YQL alloc] init];
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.lblMoneyLeft.text=[NSString stringWithFormat:@"%f",appDelegate.player1.money];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = self.title;
}

- (IBAction)btnBuy:(id)sender {
    
    //self.player=appDelegate.player1;
    NSString *stockToBuy=self.txtSymbol.text;
    NSString *numberToBuyString =self.txtShares.text;
    [self buyStockTransaction:stockToBuy numberOfShares:numberToBuyString];
    [self.txtShares resignFirstResponder];
    [self.txtSymbol resignFirstResponder];
    
    //NSLog(@"Dictionary value for symbol");
    //NSLog([player1.portfolio valueForKey:stockToBuy]);
    self.lblMoneyLeft.text= [NSString stringWithFormat:@"%f",appDelegate.player1.money];
    //self.lblCash.text=[NSString stringWithFormat:@"%f",player1.money];
    
}

- (IBAction)btnSell:(id)sender {
    Player *p1= appDelegate.player1;
    NSString * sellSymbol=self.txtSymbol.text;
    NSString * numberofSharesOwned=[p1.portfolio valueForKey:sellSymbol];
    NSString * numberOfSharesToSell=self.txtShares.text;
    int numberOfSharesOwnedInt=[numberofSharesOwned intValue];
    int numberOfSharesToSellInt=[numberOfSharesToSell intValue];
    [self.txtShares resignFirstResponder];
    [self.txtSymbol resignFirstResponder];
    if((numberofSharesOwned != NULL) && (numberOfSharesOwnedInt >= numberOfSharesToSellInt)){
        numberOfSharesOwnedInt=numberOfSharesOwnedInt-numberOfSharesToSellInt;
        [self sellStockTransaction:sellSymbol numberOfShares:numberOfSharesToSell forPlayer:p1];
        [p1.portfolio setValue:[NSString stringWithFormat:@"%d",numberOfSharesOwnedInt]forKey:sellSymbol];
    }
    //else{self.tvError.text=@"Not Enough Shares or Not in portfolio";}
    //self.tfPortfolio.text= [NSString stringWithFormat:@"%@",player1.portfolio];
    self.lblMoneyLeft.text=[NSString stringWithFormat:@"%f",p1.money];
    appDelegate.player1=p1;
}

-(void) buyStockTransaction:(NSString*)symbol numberOfShares:(NSString*)shares{
    Player *p1= appDelegate.player1;
    int numberToBuy=[shares intValue];
    double numberToBuyDouble= [[NSNumber numberWithInt:numberToBuy] doubleValue];
    double totalPrice = [self getStockPrice:symbol] * numberToBuyDouble;
    p1.money=p1.money-totalPrice;
    [p1.portfolio setObject:shares forKey:symbol];
    NSLog([NSString stringWithFormat:@"%f",totalPrice]);
    appDelegate.player1=p1;
    //NSLog(@"Cash left for client");
    //NSLog([NSString stringWithFormat:@"%f",client.money]);
}
-(double) getStockPrice:(NSString *)stockSymbol{
    NSString *firstPart =@"select AskRealtime,LastTradePriceOnly from yahoo.finance.quotes where symbol in (\"";
    NSString *symbol = stockSymbol;
    NSString *secondpart = @"\")";
    NSString *fullQuery = [NSString stringWithFormat:@"%@ %@ %@", firstPart, symbol, secondpart];
    NSDictionary *results = [yql query:fullQuery];
    NSString *resultString =[[results valueForKeyPath:@"query.results"] description];
    NSLog(resultString);
    NSArray *components = [resultString componentsSeparatedByString: @"\""];
    NSLog([NSString stringWithFormat:@"%@",components]);
    NSString *stockAskPrice = (NSString*) [components objectAtIndex:1];
    double doubleAskValue = [stockAskPrice doubleValue];
    if (doubleAskValue==0.00) {
        NSString *lastTradePriceString =(NSString*) [components objectAtIndex:3];
        return [lastTradePriceString doubleValue];
    }else{return doubleAskValue;}
}

-(double) getBidPrice:(NSString *)stockSymbol{
    NSString *firstPart =@"select BidRealtime from yahoo.finance.quotes where symbol in (\"";
    NSString *symbol = stockSymbol;
    NSString *secondpart = @"\")";
    NSString *fullQuery = [NSString stringWithFormat:@"%@ %@ %@", firstPart, symbol, secondpart];
    NSDictionary *results = [yql query:fullQuery];
    NSString *resultString =[[results valueForKeyPath:@"query.results"] description];
    NSArray *components = [resultString componentsSeparatedByString: @"\""];
    NSString *stockPrice = (NSString*) [components objectAtIndex:1];
    double doubleValue = [stockPrice doubleValue];
    return doubleValue;
}

-(void) sellStockTransaction:(NSString *)symbol numberOfShares:(NSString *)shares forPlayer:(Player *)p1{

    double bidprice = [self getBidPrice:symbol];
    double totalPrice= bidprice * [shares doubleValue];
    p1.money=p1.money+totalPrice;
    NSLog(@"Cash left for client");
    NSLog([NSString stringWithFormat:@"%f",p1.money]);
}

@end
