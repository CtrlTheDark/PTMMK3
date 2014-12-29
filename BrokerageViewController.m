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
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.dataSaver = [NSUserDefaults standardUserDefaults];
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
    self.lblMoneyLeft.text=[NSString stringWithFormat:@"%.2f",appDelegate.player1.money];
}

-(void) saveData{
    NSString *storedName=appDelegate.player1.name;
    [self.dataSaver setObject:storedName forKey:@"playerName"];
    [self.dataSaver setDouble:appDelegate.player1.money forKey:@"playerMoney"];
    [self.dataSaver setObject:appDelegate.player1.portfolio forKey:@"playerPortfolio"];
    [self.dataSaver setBool:appDelegate.player1.new forKey:@"playerNew"];
    [self.dataSaver synchronize];
    NSLog(@"Data saved");
}
- (IBAction)btnBuy:(id)sender {
    
    //self.player=appDelegate.player1;
    NSString *stockToBuy=self.txtSymbol.text;
    NSString *numberToBuyString =self.txtShares.text;
    stockToBuy=[stockToBuy uppercaseString];
    //int numberToBuy=[numberToBuyString intValue];
    [self buyStockTransaction:stockToBuy numberOfShares:numberToBuyString];
    [self.txtShares resignFirstResponder];
    [self.txtSymbol resignFirstResponder];
    //NSLog(@"Dictionary value for symbol");
    //NSLog([player1.portfolio valueForKey:stockToBuy]);
    self.lblMoneyLeft.text= [NSString stringWithFormat:@"%.2f",appDelegate.player1.money];
    [self saveData];
}

- (IBAction)btnSell:(id)sender {
    Player *p1= appDelegate.player1;
    NSString * sellSymbol=[self.txtSymbol.text uppercaseString];
    NSString * numberofSharesOwned=[p1.portfolio valueForKey:sellSymbol][0];
    NSString * averagePricePaidPerStock = [p1.portfolio valueForKey:sellSymbol][1];
    NSString * numberOfSharesToSell=self.txtShares.text;
    int numberOfSharesOwnedInt=[numberofSharesOwned intValue];
    int numberOfSharesToSellInt=[numberOfSharesToSell intValue];
    int newNumberOfSharesOwned = numberOfSharesOwnedInt- numberOfSharesToSellInt;
    NSString * newNumberOfSharesOwnedString = [NSString stringWithFormat:@"%d",newNumberOfSharesOwned];
    [self.txtShares resignFirstResponder];
    [self.txtSymbol resignFirstResponder];
    if((numberofSharesOwned != NULL) && (numberOfSharesOwnedInt >= numberOfSharesToSellInt)){
        //numberOfSharesOwnedInt=numberOfSharesOwnedInt-numberOfSharesToSellInt;
        [self sellStockTransaction:sellSymbol numberOfShares:numberOfSharesToSell forPlayer:p1];
        if(numberOfSharesOwnedInt==1){[self removeFromPortfolioOne:sellSymbol fromPlayer:p1];}
        else{
            //q NSString * newAveragePriceBoughtString;
            [p1.portfolio setValue:[NSArray arrayWithObjects:newNumberOfSharesOwnedString, averagePricePaidPerStock,nil] forKey:sellSymbol];
        }
        
        
    }
    //else{self.tvError.text=@"Not Enough Shares or Not in portfolio";}
    //self.tfPortfolio.text= [NSString stringWithFormat:@"%@",player1.portfolio];
    self.lblMoneyLeft.text=[NSString stringWithFormat:@"%.2f",p1.money];
    appDelegate.player1=p1;
}

-(void) buyStockTransaction:(NSString*)symbol numberOfShares:(NSString*)shares{
    Player *p1= appDelegate.player1;
    int numberToBuy=[shares intValue];
    double numberToBuyDouble= [[NSNumber numberWithInt:numberToBuy] doubleValue];
    double stockPriceDouble=[self getStockPrice:symbol];
    double totalPrice = stockPriceDouble * numberToBuyDouble;
    p1.money=p1.money-totalPrice;
    //[p1.portfolio setObject:shares forKey:symbol];
    //NSLog([NSString stringWithFormat:@"%.2f",totalPrice]);
    [self determineHowToAdd:symbol numberOfShares:[shares intValue] atPrice:stockPriceDouble];
    appDelegate.player1=p1;
    //NSLog(@"Cash left for client");
    //NSLog([NSString stringWithFormat:@"%f",client.money]);
}
-(double) getStockPrice:(NSString *)stockSymbol{
    NSString *firstPart =@"select AskRealtime,LastTradePriceOnly from yahoo.finance.quotes where symbol in (\"";
    NSString *symbol = stockSymbol;
    NSString *secondpart = @"\")";
    NSString *fullQuery = [NSString stringWithFormat:@"%@ %@ %@", firstPart, symbol, secondpart];
    NSDictionary *results = [appDelegate.yql query:fullQuery];
    NSString *resultString =[[results valueForKeyPath:@"query.results"] description];
    //NSLog(resultString);
    NSArray *components = [resultString componentsSeparatedByString: @"\""];
    //NSLog([NSString stringWithFormat:@"%@",components]);
    NSString *stockAskPrice = (NSString*) [components objectAtIndex:1];
    double doubleAskValue = [stockAskPrice doubleValue];
    if (doubleAskValue==0.00) {
        NSString *lastTradePriceString =(NSString*) [components objectAtIndex:3];
        return [lastTradePriceString doubleValue];
    }else{
        return doubleAskValue;}
}

-(double) getBidPrice:(NSString *)stockSymbol{
    NSString *firstPart =@"select BidRealtime,LastTradePriceOnly from yahoo.finance.quotes where symbol in (\"";
    NSString *symbol = stockSymbol;
    NSString *secondpart = @"\")";
    NSString *fullQuery = [NSString stringWithFormat:@"%@ %@ %@", firstPart, symbol, secondpart];
    NSDictionary *results = [appDelegate.yql query:fullQuery];
    NSString *resultString =[[results valueForKeyPath:@"query.results"] description];
    NSArray *components = [resultString componentsSeparatedByString: @"\""];
    NSString *stockBidPrice = (NSString*) [components objectAtIndex:1];
    double doubleBidValue = [stockBidPrice doubleValue];
    if (doubleBidValue==0.00) {
        NSString *lastTradePriceString =(NSString*) [components objectAtIndex:3];
        return [lastTradePriceString doubleValue];
    }else{
        return doubleBidValue;}
}

-(void) sellStockTransaction:(NSString *)symbol numberOfShares:(NSString *)shares forPlayer:(Player *)p1{

    double bidprice = [self getBidPrice:symbol];
    double totalPrice= bidprice * [shares doubleValue];
    p1.money=p1.money+totalPrice;
    NSLog(@"Cash left for client");
    NSLog([NSString stringWithFormat:@"%f",p1.money]);
}

-(void) addToPortfolioNew:(NSString *)symbol numberOfShares:(int)shares atPrice:(double)price{
    NSString *stringNumberOfShares=[NSString stringWithFormat:@"%d",shares];
    NSString *stringAtPrice=[NSString stringWithFormat:@"%.2f",price];
    NSArray *details = [NSArray arrayWithObjects:stringNumberOfShares,stringAtPrice, nil];
    [appDelegate.player1 addToPortfolio:symbol withDetails:details];
    NSLog(@"array");
    NSLog([NSString stringWithFormat:@"%@",details]);
    NSLog(@"Portfolio");
    NSLog([NSString stringWithFormat:@"%@",appDelegate.player1.portfolio]);
}
-(void) removeFromPortfolioOne:(NSString *)symbol fromPlayer:(Player *)player{
    [player.portfolio removeObjectForKey:symbol];
}

-(void) addToPortfolioCurrent:(NSString *)symbol numberOfShares:(int)shares atPrice:(double)price{
    NSArray *stockDetails = [[NSArray alloc] initWithArray:[appDelegate.player1.portfolio valueForKey:symbol]];
    NSString *sharesOwned = stockDetails[0];
    int sharesOwnedInt =[sharesOwned intValue];
    int totalOwnedSharesInt = shares + sharesOwnedInt;
    NSString *totalSharesOwnedString=[NSString stringWithFormat:@"%d",totalOwnedSharesInt];
    NSString *averagePriceBought = stockDetails[1];
    NSString *priceString=[NSString stringWithFormat:@"%.2f",price];
    if([priceString isEqualToString:averagePriceBought]==true){
        [appDelegate.player1.portfolio setValue:[NSArray arrayWithObjects:totalSharesOwnedString,priceString, nil] forKey:symbol];
    }else{
        [appDelegate.player1.portfolio  setValue:[NSArray arrayWithObjects:totalSharesOwnedString,[self averagePricePaidForStocks:symbol numberOFNewlyBought:shares forPrice:price], nil] forKey:symbol];
        NSLog([NSString stringWithFormat:@"%@",[appDelegate.player1.portfolio valueForKey:symbol]]);
    }
    
}
-(void) determineHowToAdd:(NSString *)symbol numberOfShares:(int)shares atPrice:(double)price{
    NSArray *stockDetails = [[NSArray alloc] initWithArray:[appDelegate.player1.portfolio valueForKey:symbol]];
    //if stock previously bought then there would be no previous details so count would be 0 else it will exe else
    if (stockDetails.count==0) {
        NSLog(@"inserted new stock into portfolio");
        [self addToPortfolioNew:symbol numberOfShares:shares atPrice:price];
    }else{
        NSLog(@"updating stock already in portfolio");
        [self addToPortfolioCurrent:symbol numberOfShares:shares atPrice:price];
    }
}

-(NSString*) averagePricePaidForStocks:(NSString *)symbol numberOFNewlyBought:(int)newStocks forPrice:(double)newPrice{
    NSString *averagePricePaidForStocks= @"0.00";
    NSArray * stocksDetails = [appDelegate.player1.portfolio valueForKey:symbol];
    double numberOfStocks= [stocksDetails[0] doubleValue];
    NSLog([NSString stringWithFormat:@"%f",numberOfStocks]);
    double storedAveragePricePaidForStocksDouble = [stocksDetails[1] doubleValue];
    NSLog([NSString stringWithFormat:@"%.2f",storedAveragePricePaidForStocksDouble]);
    double totalMoneyPaidForStocks = (numberOfStocks * storedAveragePricePaidForStocksDouble)+(newStocks * newPrice);
    NSLog([NSString stringWithFormat:@"%.2f",totalMoneyPaidForStocks]);
    double averagePricePaidForStocksDouble = totalMoneyPaidForStocks/(numberOfStocks+newStocks);
    NSLog([NSString stringWithFormat:@"%.2f",averagePricePaidForStocksDouble]);
    return [NSString stringWithFormat:@"%f",averagePricePaidForStocksDouble];
}
@end
