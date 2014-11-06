//
//  TabViewController.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/5/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabViewController : UITabBarController
@property (weak, nonatomic) IBOutlet UINavigationItem *tabnavbar;


-(void) setTitle:(NSString *)title;
@end
