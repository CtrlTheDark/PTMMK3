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
@synthesize aivPleaseWait;

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
    self.lblTransactionString.hidden=true;
    self.lblTotalCost.hidden=true;
    self.lblMoneyLeft.text=[NSString stringWithFormat:@"$%.2f",appDelegate.player1.money];
    self.aivPleaseWait.hidden=true;
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
-(BOOL) properInput{
    BOOL hasProperInput;
    

    return hasProperInput;
}
- (IBAction)btnBuy:(id)sender {
    [self startWaiting];
    double priceOfTransaction;
    bool isConnected;
    isConnected= [appDelegate.yql hasInternet];
    if (isConnected==true) {
        NSString *stockToBuy=self.txtSymbol.text;
        NSString *numberToBuyString =self.txtShares.text;
        stockToBuy=[stockToBuy uppercaseString];
        priceOfTransaction=[self buyStockTransaction:stockToBuy numberOfShares:numberToBuyString];
        [self.txtShares resignFirstResponder];
        [self.txtSymbol resignFirstResponder];
        if(priceOfTransaction==0.00){
            self.lblTransactionString.hidden=false;
            self.lblTransactionString.text=@"Not Enough Cash/Incorrect Symbol";
            self.lblTotalCost.hidden=true;
        }else if(priceOfTransaction==-1.0){
            self.lblTransactionString.hidden=false;
            self.lblTransactionString.text=@"Transaction Error";
            self.lblTotalCost.hidden=true;
        }else{
            self.lblTransactionString.hidden=false;
            self.lblTotalCost.hidden=false;
            self.lblTransactionString.text=@"The cost of the transaction was";
            self.lblTotalCost.text=[NSString stringWithFormat:@"$%.2f",priceOfTransaction];
            self.lblMoneyLeft.text= [NSString stringWithFormat:@"$%.2f",appDelegate.player1.money];
            [self saveData];
        }
    }else{
        self.lblNotification.text=@"Error: No Data Connection";
        self.lblNotification.textColor=[UIColor redColor];
        [self.txtShares resignFirstResponder];
        [self.txtSymbol resignFirstResponder];
        }
    [self endWaiting];
    }

-(void) startWaiting{
    NSLog(@"waiting started");
    [aivPleaseWait startAnimating];
    self.aivPleaseWait.hidden=false;
    self.buttonBuy.enabled=false;
    self.buttonCalcBuy.enabled=false;
    self.buttonSell.enabled=false;
    self.buttonCalcSell.enabled=false;
    self.txtShares.enabled=false;
    self.txtSymbol.enabled=false;
}
-(void) endWaiting{
    self.buttonBuy.enabled=true;
    self.buttonCalcBuy.enabled=true;
    self.buttonSell.enabled=true;
    self.buttonCalcSell.enabled=true;
    self.txtShares.enabled=true;
    self.txtSymbol.enabled=true;
    self.aivPleaseWait.hidden=true;
    [aivPleaseWait stopAnimating];
    NSLog(@"endwaiting done");
}
- (IBAction)btnSell:(id)sender {
    [self startWaiting];
    double priceOfTransaction;
    bool isConnected;
    isConnected= [appDelegate.yql hasInternet];
    if(isConnected==true){
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
            priceOfTransaction=[self sellStockTransaction:sellSymbol numberOfShares:numberOfSharesToSell forPlayer:p1];
            if (priceOfTransaction==-1.0){
                self.lblTotalCost.hidden=true;
                self.lblTransactionString.hidden=false;
                self.lblTransactionString.text=@"Transaction Error";
            }else{
                if(numberOfSharesOwnedInt==1){[self removeFromPortfolioOne:sellSymbol fromPlayer:p1];}
                else{
                    if(newNumberOfSharesOwned==0){[p1.portfolio removeObjectForKey:sellSymbol];
                    }else{
                        [p1.portfolio setValue:[NSArray arrayWithObjects:newNumberOfSharesOwnedString, averagePricePaidPerStock,nil] forKey:sellSymbol];
                        }
                }
            }
            self.lblTransactionString.hidden=false;
            self.lblTotalCost.hidden=false;
            self.lblTransactionString.text=@"The value of stocks sold was";
            self.lblTotalCost.text=[NSString stringWithFormat:@"$%.2f",priceOfTransaction];
            self.lblMoneyLeft.text=[NSString stringWithFormat:@"$%.2f",p1.money];
            appDelegate.player1=p1;
        }else{
            self.lblTotalCost.hidden=true;
            self.lblTransactionString.hidden=false;
            self.lblTransactionString.text=@"Symbol/# of Stocks Not In Portfolio";
        }
        
    }else{
        self.lblNotification.text=@"Error: No Data Connection";
        self.lblNotification.textColor=[UIColor redColor];
        [self.txtShares resignFirstResponder];
        [self.txtSymbol resignFirstResponder];
    }
    [self endWaiting];
}

- (IBAction)btnCalcBuy:(id)sender {
    [self startWaiting];
    double priceOfCalculation;
    bool isConnected;
    isConnected= [appDelegate.yql hasInternet];
    if (isConnected==true) {
        NSString *stockToBuy=self.txtSymbol.text;
        NSString *numberToBuyString =self.txtShares.text;
        stockToBuy=[stockToBuy uppercaseString];
        priceOfCalculation=[self buyStockCalculation:stockToBuy numberOfShares:numberToBuyString];
        [self.txtShares resignFirstResponder];
        [self.txtSymbol resignFirstResponder];
        if (priceOfCalculation==0.00) {
            self.lblTransactionString.hidden=false;
            self.lblTransactionString.text=@"Symbol Does Not Exist";
            self.lblTotalCost.hidden=true;
        }else if(priceOfCalculation==-1.0){
            self.lblTransactionString.hidden=false;
            self.lblTransactionString.text=@"Transaction Error";
            self.lblTotalCost.hidden=true;
        }else{
            self.lblTransactionString.hidden=false;
            self.lblTotalCost.hidden=false;
            self.lblTransactionString.text=@"Calculation of the transaction was";
            self.lblTotalCost.text=[NSString stringWithFormat:@"$%.2f",priceOfCalculation];
        }
    }else{
        self.lblNotification.text=@"Error: No Data Connection";
        self.lblNotification.textColor=[UIColor redColor];
        [self.txtShares resignFirstResponder];
        [self.txtSymbol resignFirstResponder];
    }
    [self endWaiting];
}

- (IBAction)btnCalcSell:(id)sender {
    [self startWaiting];
    double priceOfCalculation;
    bool isConnected;
    isConnected= [appDelegate.yql hasInternet];
    if(isConnected==true){
        NSString * sellSymbol=[self.txtSymbol.text uppercaseString];
        NSString * numberOfSharesToSell=self.txtShares.text;
        int numberOfSharesToSellInt=[numberOfSharesToSell intValue];
        [self.txtShares resignFirstResponder];
        [self.txtSymbol resignFirstResponder];
        priceOfCalculation=[self sellStockCalculation:sellSymbol numberOfShares:numberOfSharesToSell];
        if(priceOfCalculation==-1.0){
            self.lblTransactionString.hidden=false;
            self.lblTransactionString.text=@"Transaction Error";
        }else{
            self.lblTransactionString.hidden=false;
            self.lblTotalCost.hidden=false;
            self.lblTransactionString.text=@"The value of stocks sold was";
            self.lblTotalCost.text=[NSString stringWithFormat:@"$%.2f",priceOfCalculation];
        }
    }
    else{
        self.lblNotification.text=@"Error: No Data Connection";
        self.lblNotification.textColor=[UIColor redColor];
        [self.txtShares resignFirstResponder];
        [self.txtSymbol resignFirstResponder];
    }
    [self endWaiting];
}
-(double) sellStockCalculation:(NSString *)symbol numberOfShares:(NSString *)shares{
    double bidprice = [self getBidPrice:symbol];
    if(bidprice==-1.0){
        return -1.0;
    }else{
        double totalPrice= bidprice * [shares doubleValue];
        return totalPrice;
    }
}



-(double) buyStockCalculation:(NSString *)symbol numberOfShares:(NSString *)shares{
    int numberToBuy=[shares intValue];
    double numberToBuyDouble= [[NSNumber numberWithInt:numberToBuy] doubleValue];
    double stockPriceDouble=[self getStockPrice:symbol];
    if(stockPriceDouble==0.00){
        return 0.00;
    }else if(stockPriceDouble==-1.0){
        return -1.0;
    }else{
        double totalPrice = stockPriceDouble * numberToBuyDouble;
        return totalPrice;
    }
}
-(double) buyStockTransaction:(NSString*)symbol numberOfShares:(NSString*)shares{
    Player *p1= appDelegate.player1;
    int numberToBuy=[shares intValue];
    double numberToBuyDouble= [[NSNumber numberWithInt:numberToBuy] doubleValue];
    double stockPriceDouble=[self getStockPrice:symbol];
    if (stockPriceDouble==0.00) {
        return 0.00;
    }else if(stockPriceDouble==-1.0){
        return -1.0;
    }else{
        double totalPrice = stockPriceDouble * numberToBuyDouble;
        if(totalPrice>appDelegate.player1.money){
            return 0.00;
        }else{
            p1.money=p1.money-totalPrice;
            [self determineHowToAdd:symbol numberOfShares:[shares intValue] atPrice:stockPriceDouble];
            appDelegate.player1=p1;
            return totalPrice;
        }
    }
}
-(double) getStockPrice:(NSString *)stockSymbol{
    NSString *firstPart =@"select AskRealtime,LastTradePriceOnly,BidRealtime,StockExchange from yahoo.finance.quotes where symbol in (\"";
    NSString *symbol = stockSymbol;
    NSString *secondpart = @"\")";
    NSString *fullQuery = [NSString stringWithFormat:@"%@ %@ %@", firstPart, symbol, secondpart];
    NSDictionary *results = [appDelegate.yql query:fullQuery];
    NSDictionary *onlyData=[results valueForKey:@"query"];
    NSString *countValue=[onlyData valueForKey:@"count"];
    int countValueInt = [countValue intValue];
    if (countValueInt==0) {
        NSLog(@"Broken but no crash");
        return -1.0;
    }
    if (countValueInt==1) {
        NSLog(@"count = 1");
    }
    NSString *resultString =[[results valueForKeyPath:@"query.results"] description];
    NSArray *components = [resultString componentsSeparatedByString: @"\""];
    //NSLog([NSString stringWithFormat:@"%@",components]);
    NSString *stockAskPrice = (NSString*) [components objectAtIndex:1];
    NSString *stockBidPrice = (NSString*) [components objectAtIndex:3];
    NSString *lastTradePriceString = (NSString*) [components objectAtIndex:5];
    //NSString *marketString = (NSString*) [components objectAtIndex:7];
    double doubleAskValue = [stockAskPrice doubleValue];
    double doubleBidValue = [stockBidPrice doubleValue];
    double doublelastTradePrice = [lastTradePriceString doubleValue];
    if (([stockAskPrice isEqualToString:@"<null>"])&&([stockBidPrice isEqualToString:@"<null>"])&&([lastTradePriceString isEqualToString:@"0.00"])) {
        return 0.00;
    }else{
    if (doubleAskValue==0.00) {
        if(doublelastTradePrice<doubleBidValue){
            return doubleBidValue;
        }else{
            return doublelastTradePrice;
        }
    }else{
        return doubleAskValue;}
    }
}

-(double) getBidPrice:(NSString *)stockSymbol{
    NSString *firstPart =@"select BidRealtime,LastTradePriceOnly from yahoo.finance.quotes where symbol in (\"";
    NSString *symbol = stockSymbol;
    NSString *secondpart = @"\")";
    NSString *fullQuery = [NSString stringWithFormat:@"%@ %@ %@", firstPart, symbol, secondpart];
    NSDictionary *results = [appDelegate.yql query:fullQuery];
    NSDictionary *onlyData=[results valueForKey:@"query"];
    NSString *countValue=[onlyData valueForKey:@"count"];
    int countValueInt = [countValue intValue];
    if (countValueInt==0) {
        NSLog(@"Broken but no crash");
        return -1.0;
    }
    if (countValueInt==1) {
        NSLog(@"count = 1");
    }

    NSString *resultString =[[results valueForKeyPath:@"query.results"] description];
    NSArray *components = [resultString componentsSeparatedByString: @"\""];
    NSString *stockBidPrice = (NSString*) [components objectAtIndex:1];
    double doubleBidValue = [stockBidPrice doubleValue];
    if (doubleBidValue==0.00) {
        NSString *lastTradePriceString =(NSString*) [components objectAtIndex:3];
        return [lastTradePriceString doubleValue];
        }else{
            return doubleBidValue;
        }
}

-(double) sellStockTransaction:(NSString *)symbol numberOfShares:(NSString *)shares forPlayer:(Player *)p1{
    double bidprice = [self getBidPrice:symbol];
    double totalPrice= bidprice * [shares doubleValue];
    p1.money=p1.money+totalPrice;
    return totalPrice;
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
    symbol=[symbol uppercaseString];
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
    double storedAveragePricePaidForStocksDouble = [stocksDetails[1] doubleValue];
    double totalMoneyPaidForStocks = (numberOfStocks * storedAveragePricePaidForStocksDouble)+(newStocks * newPrice);
    double averagePricePaidForStocksDouble = totalMoneyPaidForStocks/(numberOfStocks+newStocks);
    return [NSString stringWithFormat:@"%f",averagePricePaidForStocksDouble];
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
