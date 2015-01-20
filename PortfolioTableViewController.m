//
//  PortfolioTableViewController.m
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 12/1/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import "PortfolioTableViewController.h"
#import <UIKit/UIKit.h>//NSMutableAttributedString


@interface PortfolioTableViewController ()

@end

@implementation PortfolioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAscending = YES;
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.tableData = [[NSMutableArray alloc]init];
    if([appDelegate.yql hasInternet]) {
        [self updateTableData:[self createCurrentPricesArray]];
    }else{
        [self updateTableData:[self createNAPriceArray]];
    }
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([appDelegate.yql hasInternet]) {
        [self updateTableData:[self createCurrentPricesArray]];
    }else{
        [self updateTableData:[self createNAPriceArray]];
    }
    [self.tableView reloadData];
    self.tabBarController.title = self.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.tableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.attributedText=[self.tableData objectAtIndex:indexPath.row];
    return cell;
}


-(void) refreshTheTable{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}
-(NSMutableArray*) createCurrentPricesArray{
    NSArray* symbolArray=[NSArray arrayWithArray:[appDelegate.player1 symbolsOwned]];
    NSMutableArray *currentPrices=[[NSMutableArray alloc]init];
    if(symbolArray.count>0){
        NSString* marketPricesQuery= [appDelegate.player1 arrayToSymbolString:symbolArray];
        NSDictionary* results = [appDelegate.yql query:marketPricesQuery];
        NSString *resultString =[[results valueForKeyPath:@"query.results"] description];
        NSArray *components = [resultString componentsSeparatedByString: @"\""];
        int counter=1;
        while (counter < components.count) {
        if ([components[counter] isEqualToString:@"0.00"] != true) {
            [currentPrices addObject:components[counter]];
        }else{
            [currentPrices addObject:components[counter+2]];
        }
        counter=counter+4;
        }
    return currentPrices;
    }else{
        return currentPrices;
    }
}
-(NSMutableArray*) createNAPriceArray{
    NSArray* symbolArray=[NSArray arrayWithArray:[appDelegate.player1 symbolsOwned]];
    NSMutableArray *NAStrings=[[NSMutableArray alloc]init];
    if(symbolArray.count>0){
        for (NSString* symbol in symbolArray) {
            [NAStrings addObject:@"Offline"];
        }
    }
    return NAStrings;
}
-(void) updateTableData:(NSMutableArray *)currentPrices{
    self.tableData = [appDelegate.player1 fromPortfolioToStringArrayWithCurrentPrices:currentPrices];
}
#pragma mark iAd Delagate Methods

-(void) bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}
-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}
@end