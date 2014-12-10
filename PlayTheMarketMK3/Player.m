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
    self.name= @"Brandon";
    self.money=100000.00;
    self.portfolio =[NSMutableDictionary dictionary];
    //NSString *numberone =[NSString stringWithFormat:@"1"];
    //NSString *numberfivedouble =[NSString stringWithFormat:@"1.00"];
    //[self addToPortfolio:@"goog" withDetails:[NSArray arrayWithObjects:numberone,numberfivedouble, nil]];
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
-(NSMutableArray*) fromPortfolioToStringArray{
    int counter=0;
    NSString* spacing= @"  ";
    NSString* symbol;
    NSString* numberOfShares;
    NSString* shareThenDollarSign;
    NSString* averagePricePaid;
    NSString* textForCell;
    NSString* testSymbol;
    NSMutableArray *arrayOfStrings = [NSMutableArray arrayWithObjects:@"",@"",@"Symbol         #         $ Paid/Share",nil];
    NSMutableArray* symbolArray = [NSMutableArray arrayWithArray:[self symbolsOwned]];
    for (NSString* key in self.portfolio) {
        NSArray *value = [self.portfolio objectForKey:key];
        symbol = key;
        testSymbol= symbolArray[counter];
        counter++;
        numberOfShares = value[0];
        if([numberOfShares intValue]>1){shareThenDollarSign = @"shares    $";}
        else{shareThenDollarSign = @"share    $";}
        averagePricePaid = value[1];
        textForCell = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", symbol, spacing, numberOfShares,shareThenDollarSign, averagePricePaid, testSymbol];
        [arrayOfStrings addObject:textForCell];
    }
    return arrayOfStrings;
}
-(NSMutableArray*) symbolsOwned{
    NSString* left=@"(\"";
    NSString* right=@"\")";
    NSString* symbol;
    NSString* yqlString;
    NSMutableArray* symbols=[[NSMutableArray alloc]init];
    for(NSString* key in self.portfolio){
        yqlString=[NSString stringWithFormat:@"%@%@%@",left,key,right];
        [symbols addObject:yqlString];
    }
    return symbols;
}


@end
