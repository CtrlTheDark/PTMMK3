//
//  MenuViewController.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "AppDelegate.h"

@interface MenuViewController : UIViewController
{
    AppDelegate *appDelegate;
}
@property (weak, nonatomic) IBOutlet UILabel *lblActivePlayer;






@property Player *player;

@end
