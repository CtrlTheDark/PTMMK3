//
//  YQL.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/11/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQL : NSObject

- (NSDictionary *)query:(NSString *)statement;


@end
