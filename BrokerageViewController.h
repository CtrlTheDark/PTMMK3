//
//  BrokerageViewController.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "AppDelegate.h"
#import "YQL.h"

@interface BrokerageViewController : UIViewController
{
    AppDelegate *appDelegate;
    YQL *yql;
}
@property Player *player;
@property (weak, nonatomic) IBOutlet UITextField *txtSymbol;
@property (weak, nonatomic) IBOutlet UITextField *txtShares;
- (IBAction)btnBuy:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCost;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyLeft;

-(void) buyStockTransaction: (NSString *)symbol numberOfShares:(NSString *) shares forPlayer:(Player *) client;

-(double) getStockPrice:(NSString *) stockSymbol;
@end
