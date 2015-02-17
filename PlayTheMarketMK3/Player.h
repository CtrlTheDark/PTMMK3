//
//  Player.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/8/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Player : NSObject
@property NSString *name;
@property double money;
@property double startingMoney;
@property NSMutableDictionary *portfolio;
//first index in value is number of shares then Average Bought Price
@property bool new;

-(id)init;

-(void) addToPortfolio:(NSString *)symbol  withDetails:(NSArray *) shareDetails;
-(double) getPortfolioBoughtPrice;
-(NSMutableArray*) fromPortfolioToStringArrayWithCurrentPrices:(NSMutableArray*) currentPrices;
-(NSMutableArray*) symbolsOwned;
-(NSMutableArray*) symbolsOwnedNoGuff;
-(NSString*) arrayToSymbolString:(NSMutableArray*)symbolArray;
-(NSMutableArray*) createCurrentPricesArray;
-(int) lengthOfColorMoney:(float)currentPriceFloat;
-(int) getnumberOfSharesOwned:(NSString*) symbol;
@end
