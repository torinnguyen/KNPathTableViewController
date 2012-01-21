//
//  TNFourthViewController.m
//  KNPathTableViewControllerDemo
//
//  Created by Torin Nguyen on 21/1/12.
//  Copyright (c) 2012 Torin Nguyen. All rights reserved.
//

#import "TNFourthViewController.h"

@interface TNFourthViewController ()
{
    NSMutableDictionary * dataStorage;
}

@end

@implementation TNFourthViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (dataStorage == nil)
        dataStorage = [[NSMutableDictionary alloc] init];
    [dataStorage removeAllObjects];

    // Dummy data
    NSArray * fruits = [[NSArray alloc] initWithObjects: @"Apple", @"Blackberry", @"Coconut", @"Durian", @"Grape", @"Kiwi", @"Lemon", @"Mango", @"Peach", @"Strawberry", @"Tomato", @"Watermelon", nil];
    NSTimeInterval nowTimeIntervalSince1970 = [[NSDate date] timeIntervalSince1970];
    
    // Add a series of dummy data
    for (int k=0;k<100;k++)
    {
        //primary info
        int randomIndex = arc4random() % [fruits count];
        NSString * title = [NSString stringWithString:[fruits objectAtIndex:randomIndex]];
        
        //secondary info
        int randomTime = arc4random() % 98765432;
        NSDate * randomDate = [NSDate dateWithTimeIntervalSince1970:(nowTimeIntervalSince1970 + randomTime)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yyy"];        
        NSString * subtitle = [NSString stringWithFormat:@"Expiry: %@", [dateFormatter stringFromDate:randomDate]];
        
        //data dictionary
        NSString * key = [NSString stringWithFormat:@"%d", k];
        NSDictionary * oneData = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", subtitle, @"subtitle", nil];
        [dataStorage setObject:oneData forKey:key];
    }
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [dataStorage removeAllObjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataStorage count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DemoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    // Configure the cell data...
    
    NSString * key = [NSString stringWithFormat:@"%d", indexPath.row];
    NSDictionary * dataObject = [dataStorage objectForKey:key];
    NSString * title = [dataObject objectForKey:@"title"];

    cell.textLabel.text = title;
    return cell;
}

#pragma mark - Basic use for the info panel

-(void)infoPanelDidScroll:(UIScrollView *)scrollView atPoint:(CGPoint)point
{
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    NSString * key = [NSString stringWithFormat:@"%d", indexPath.row];
    NSDictionary * dataObject = [dataStorage objectForKey:key];
    NSString * subtitle = [dataObject objectForKey:@"subtitle"];   
    
    infoLabel.text = subtitle;
}

@end
