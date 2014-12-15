//
//  PortfolioTableViewController.m
//  PlayTheMarketMK3
//
//  Created by Brandon Fink on 12/1/14.
//  Copyright (c) 2014 Brandon Fink. All rights reserved.
//

#import "PortfolioTableViewController.h"

@interface PortfolioTableViewController ()

@end

@implementation PortfolioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAscending = YES;
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.tableData = [[NSMutableArray alloc]init];
    self.tableData = [appDelegate.player1 fromPortfolioToStringArray];
    //[self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableData=[appDelegate.player1 fromPortfolioToStringArray];
    [self.tableView reloadData];
    self.tabBarController.title = self.title;
    NSArray* symbolArray=[NSArray arrayWithArray:[appDelegate.player1 symbolsOwned]];
    NSString* marketPricesQuery= [appDelegate.player1 arrayToSymbolString:symbolArray];
    NSDictionary*marketPrices= [appDelegate.yql query:marketPricesQuery];
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
    cell.textLabel.text=[self.tableData objectAtIndex:indexPath.row];
    return cell;
    
}


-(void) refreshTheTable{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}
@end