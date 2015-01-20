//
//  OptionsViewController.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/11/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Player.h"
#import "AppDelegate.h"

@interface OptionsViewController : UIViewController <ADBannerViewDelegate>
{
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property Player *player;
- (IBAction)startNewGame:(id)sender;
@property NSUserDefaults *dataSaver;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segMoneyStart;
-(void) saveData;
@end
