//
//  PortfolioTableViewController.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 12/1/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Player.h"
#import "AppDelegate.h"

@interface PortfolioTableViewController : UITableViewController <ADBannerViewDelegate>
{
    
    AppDelegate *appDelegate;
    
}

@property NSMutableArray* tableData;
@property NSInteger* paddingFromTop;
@property Player *player;
@property (nonatomic) BOOL isAscending;
-(void) refreshTheTable;
-(NSMutableArray*) createCurrentPricesArray;
-(void) updateTableData:(NSMutableArray*) currentPrices;
@end
