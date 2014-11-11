//
//  OptionsViewController.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/11/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "AppDelegate.h"

@interface OptionsViewController : UIViewController
{
    AppDelegate *appDelegate;
}
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property Player *player;
@end