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
    return self;
}

@end
