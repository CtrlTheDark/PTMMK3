//
//  Player.m
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/8/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Player.h"
#import <UIKit/UIKit.h>//NSMutableAttributedString



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
    [self.portfolio setObject:shareDetails forKey:symbol];
    ///[self.portfolio setValue:shareDetails forKey: symbol];
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
    NSMutableAttributedString* emptyCell =[[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString* firstRow =[[NSMutableAttributedString alloc] initWithString:@"Sym  |  Shares  |  $/Share  |  Curr $"];
    NSString* spacing= @"  ";
    NSString* doublespacing= @"    ";
    NSString* dollarSign=@"  $";
    NSString* symbol;
    NSString* numberOfShares;
    float averagePricePaidFloat;
    NSString* averagePricePaidString;
    NSString* textForCell;
    NSString* currentPrice;
    float currentPriceFloat;
    int lengthOfColor;
    int stringLength;
    NSMutableAttributedString *colorTextForCell;
    NSMutableArray *arrayOfStrings = [NSMutableArray arrayWithObjects:emptyCell,emptyCell,firstRow,nil];
    NSMutableArray* symbolArray = [NSMutableArray arrayWithArray:[self symbolsOwned]];
    for (NSString* key in self.portfolio) {
        NSArray *value = [self.portfolio objectForKey:key];
        symbol = key;
        currentPrice= currentPrices[counter];
        currentPriceFloat=[currentPrice floatValue];
        lengthOfColor=[self lengthOfColorMoney:currentPriceFloat];
        counter++;
        numberOfShares = value[0];
        averagePricePaidFloat = [value[1] floatValue];
        averagePricePaidString = [NSString stringWithFormat:@"%.2f",averagePricePaidFloat];
        textForCell = [NSString stringWithFormat:@"%@ %@ %@ %@ %@%@ %@ %@%@", symbol, doublespacing, numberOfShares, spacing,dollarSign, averagePricePaidString, spacing, dollarSign, currentPrice];
        colorTextForCell = [[NSMutableAttributedString alloc] initWithString:textForCell];
        stringLength=([colorTextForCell length]);
        if(averagePricePaidFloat>currentPriceFloat){
            //NSLog([colorTextForCell attributedSubstringFromRange:NSMakeRange(14, 14)]);
            [colorTextForCell beginEditing];
            [colorTextForCell addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange((stringLength-lengthOfColor),lengthOfColor)];
            [colorTextForCell endEditing];
        }else if (averagePricePaidFloat<currentPriceFloat){
            [colorTextForCell beginEditing];
            [colorTextForCell addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange((stringLength-lengthOfColor),lengthOfColor)];
            [colorTextForCell endEditing];
        }else{
            [colorTextForCell beginEditing];
            [colorTextForCell addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange((stringLength-lengthOfColor),lengthOfColor)];
            [colorTextForCell endEditing];
        }
        //textForCell = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ ", symbol, spacing, numberOfShares,shareThenDollarSign, averagePricePaid];
        //[colorTextForCell addAttributes:firstAttributes range:NSMakeRange(2, 7)];
        [arrayOfStrings addObject:colorTextForCell];
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
-(int) lengthOfColorMoney:(float)currentPriceFloat{
    int length=0;
    if (currentPriceFloat<10) {
        length=5;
    }else if(currentPriceFloat<100){
        length=6;
    }else if (currentPriceFloat<1000){
        length=7;
    }else if (currentPriceFloat<10000){
        length=8;
    }
    return length;
}


@end
