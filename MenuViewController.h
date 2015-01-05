//
//  MenuViewController.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Player.h"
#import "AppDelegate.h"

@interface MenuViewController : UIViewController <ADBannerViewDelegate>
{
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;






@property Player *player;
@property (weak, nonatomic) IBOutlet UIButton *btnOptions;

-(void) loadData;

@end
