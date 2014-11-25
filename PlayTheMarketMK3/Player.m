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
    //NSString *numberfivedouble =[NSString stringWithFormat:@"5.00"];
    //[self addToPortfolio:@"pbhc" withDetails:[NSArray arrayWithObjects:numberone,numberfivedouble, nil]];
    return self;
}

-(void) addToPortfolio:(NSString *)symbol withDetails:(NSArray *)shareDetails {
    [self.portfolio setValue:shareDetails forKey: symbol];
}

@end
