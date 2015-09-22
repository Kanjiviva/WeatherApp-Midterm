//
//  WeatherListTableViewController.m
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "WeatherListTableViewController.h"
#import "WeatherLocation.h"

@interface WeatherListTableViewController ()

//@property (strong, nonatomic) NSString *searchItem;

@property (strong, nonatomic) NSMutableArray *weathers;
@property (strong, nonatomic) WeatherLocation *weatherLocation;

@end

@implementation WeatherListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.weathers = [NSMutableArray new];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.dataStack = [DataStack new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadLocation];
}

#pragma mark - Helper Method -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showSearch"]) {
//        WeatherSearchViewController *weatherSearchVC = segue.destinationViewController;
        
        
    } else if ([segue.identifier isEqualToString:@"showWeatherDetail"]) {
        
        WeatherDetailViewController *weatherVC = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        self.weatherLocation = self.weathers[indexPath.row];
        
        weatherVC.weatherLocation = self.weatherLocation;
        weatherVC.dataStack = self.dataStack;
    }
    
}

- (void)reloadLocation {
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"WeatherLocation"];
    
    //    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"todoTitle" ascending:YES]];
    
    NSError *fetchError = nil;
    NSArray *allWeathers = [self.dataStack.context executeFetchRequest:fetch error:&fetchError];
    
    NSLog(@"all weathers lists are: %@", allWeathers);
    
    self.weathers = [allWeathers mutableCopy];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return [self.weathers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    WeatherLocation *weahterLocation = self.weathers[indexPath.row];
    
    cell.locationLabel.text = weahterLocation.locationName;
    cell.temperatureLabel.text = [NSString stringWithFormat:@"%.1f C", weahterLocation.currentTemperature];
    cell.countryLabel.text = weahterLocation.country;
    
    return cell;
}

#pragma mark - Table View delegate -

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        WeatherLocation *weatherLocation = self.weathers[indexPath.row];
        
        [self.dataStack.context deleteObject:weatherLocation];
        
        NSError *saveError = nil;
        
        if (![self.dataStack.context save:&saveError]) {
            NSLog(@"Save failed! %@", saveError);
        }
        
        
        [self.weathers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        NSInteger sourceRow = sourceIndexPath.row;
        NSInteger destRow = destinationIndexPath.row;
        id object = [self.weathers objectAtIndex:sourceRow];
        
        [self.weathers removeObjectAtIndex:sourceRow];
        [self.weathers insertObject:object atIndex:destRow];
        
        
    } else {
        [self.tableView reloadData];
    }
}
@end
