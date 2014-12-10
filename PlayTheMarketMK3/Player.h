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
@property NSMutableDictionary *portfolio;

-(id)init;

-(void) addToPortfolio:(NSString *)symbol  withDetails:(NSArray *) shareDetails;
-(double) getPortfolioBoughtPrice;
-(NSMutableArray*) fromPortfolioToStringArray;
-(NSMutableArray*) symbolsOwned;
@end
