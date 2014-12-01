//
//  PortfolioTableView.h
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 11/30/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortfolioTableView : UITableView

@property (nonatomic,strong) NSArray *colors;

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

-(UITableViewCell *)tableView:(UITableView *)tableView cellforRowAtIndexPath:(NSIndexPath *)indexPath;




@end
