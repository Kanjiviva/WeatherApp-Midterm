//
//  WeatherListTableViewController.m
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "WeatherListTableViewController.h"

@interface WeatherListTableViewController ()

//@property (strong, nonatomic) NSString *searchItem;

@property (strong, nonatomic) NSMutableArray *weathers;

@end

@implementation WeatherListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.weathers = [NSMutableArray new];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - Helper Method -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showSearch"]) {
        WeatherSearchViewController *weatherSearchVC = segue.destinationViewController;
        
        weatherSearchVC.delegate = self;
        
    }
    
}

- (void)cityName:(Location *)location {
    
    [self.weathers addObject:location];
    
}

//- (void)cityName:(NSString *)cityName {
//    
//    
//    NSString *stringURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=%@", cityName, API_KEY];
//    
//    self.searchItem = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    
//    [self jsonRequest:self.searchItem];
//}
//
//- (float)convertToCelsius:(float)kelvin {
//    
//    float celsius;
//    
//    celsius = kelvin - 273.15;
//    
//    return celsius;
//}
//
//#pragma mark - JSON request -
//
//- (void)jsonRequest:(NSString *)searchString {
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURLSessionTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:searchString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        if (!error) {
//            
//            NSError *jsonError = nil;
//            
//            NSDictionary *weatherDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//            
//            NSString *name = [weatherDict objectForKey:@"name"];
//            
//            NSDictionary *main = [weatherDict objectForKey:@"main"];
//            NSNumber *temperature = [main objectForKey:@"temp"];
//            
//            NSString *cod = [weatherDict objectForKey:@"cod"];
//            
//            if ([cod isEqualToString:@"404"]) {
//                NSLog(@"Testing");
//                
//            }
//            
//            float temp = [self convertToCelsius:[temperature floatValue]];
//            
//            Location *location = [[Location alloc] initWithCity:name temperature:[NSNumber numberWithFloat:temp]];
//            
//            [self.weathers addObject:location];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        }
//        
//        
//    }];
//    
//    [dataTask resume];
//}

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
    Location *location = self.weathers[indexPath.row];
    
    cell.locationLabel.text = location.cityName;
    cell.temperatureLabel.text = [NSString stringWithFormat:@"%.1f C", [location.temperature floatValue]];
    
    return cell;
}

#pragma mark - Table View delegate -

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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
