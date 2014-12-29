//
//  Player.m
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/8/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id) init {
    if (!(self = [super init])) return nil;
    
    //self.name= @"";
    //self.money=100000.00;
    //self.portfolio =[NSMutableDictionary dictionary];
    self.new=true;
    NSString *numberone =[NSString stringWithFormat:@"1"];
    NSString *numberfivedouble =[NSString stringWithFormat:@"1.00"];
    //[self addToPortfolio:@"GOOG" withDetails:[NSArray arrayWithObjects:numberone,numberfivedouble, nil]];
    //[self addToPortfolio:@"AAPL" withDetails:[NSArray arrayWithObjects:numberone,numberfivedouble, nil]];
    //[self addToPortfolio:@"PBHC" withDetails:[NSArray arrayWithObjects:numberone,numberfivedouble, nil]];
    //[self addToPortfolio:@"YHOO" withDetails:[NSArray arrayWithObjects:numberone,numberfivedouble, nil]];
    return self;
}

-(void) addToPortfolio:(NSString *)symbol withDetails:(NSArray *)shareDetails {
    [self.portfolio setValue:shareDetails forKey: symbol];
}
-(double) getPortfolioBoughtPrice{
    double totalPrice=0.0;
    for (NSString* key in self.portfolio) {
        NSArray* value = [self.portfolio valueForKey:key];
        totalPrice = totalPrice + ([value[1] doubleValue]*[value[0] intValue]);
    }
    return totalPrice;
}
-(NSMutableArray*) fromPortfolioToStringArrayWithCurrentPrices:(NSMutableArray*) currentPrices{
    int counter=0;
    NSString* spacing= @"  ";
    NSString* dollarSign=@"  $";
    NSString* symbol;
    NSString* numberOfShares;
    NSString* shareThenDollarSign;
    float averagePricePaidFloat;
    NSString* averagePricePaidString;
    NSString* textForCell;
    NSString* currentPrice;
    NSMutableArray *arrayOfStrings = [NSMutableArray arrayWithObjects:@"",@"",@"Sym          #         $/Share    Curr $",nil];
    NSMutableArray* symbolArray = [NSMutableArray arrayWithArray:[self symbolsOwned]];
    for (NSString* key in self.portfolio) {
        NSArray *value = [self.portfolio objectForKey:key];
        symbol = key;
        currentPrice= currentPrices[counter];
        counter++;
        numberOfShares = value[0];
        if([numberOfShares intValue]>1){shareThenDollarSign = @"shares   $";}
        else{shareThenDollarSign = @"share   $";}
        averagePricePaidFloat = [value[1] floatValue];
        averagePricePaidString = [NSString stringWithFormat:@"%.2f",averagePricePaidFloat];
        textForCell = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@%@", symbol, spacing, numberOfShares,shareThenDollarSign, averagePricePaidString,dollarSign, currentPrice];
        //textForCell = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ ", symbol, spacing, numberOfShares,shareThenDollarSign, averagePricePaid];
        [arrayOfStrings addObject:textForCell];
        //textForCell = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", symbol, spacing, numberOfShares,shareThenDollarSign, averagePricePaid, testSymbol];
    }
    return arrayOfStrings;
}
-(NSMutableArray*) symbolsOwned{
    NSString* left=@"\"";
    NSString* right=@"\"";
    NSString* symbol;
    NSString* yqlString;
    NSMutableArray* symbols=[[NSMutableArray alloc]init];
    for(NSString* key in self.portfolio){
        yqlString=[NSString stringWithFormat:@"%@%@%@",left,key,right];
        [symbols addObject:yqlString];
    }
    
    return symbols;
}

-(NSString*) arrayToSymbolString:(NSMutableArray *)symbolArray{
    NSString* symbolString;
    NSString* left= @"select BidRealtime,LastTradePriceOnly from yahoo.finance.quotes where symbol in (";
    NSString* middle=@"";
    NSString* comma=@",";
    NSString* right=@")";
    
    for (NSString* symbol in symbolArray) {
        middle=[middle stringByAppendingString:symbol];
        middle=[middle stringByAppendingString:comma];
    }
    //removes last comma
    middle=[middle substringWithRange:NSMakeRange(0, (middle.length-1))];
    symbolString=[NSString stringWithFormat:@"%@%@%@",left,middle,right];
    //symbolString=[symbolString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return symbolString;

}



@end
