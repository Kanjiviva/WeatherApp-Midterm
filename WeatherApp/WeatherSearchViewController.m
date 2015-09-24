//
//  WeatherDetailViewController.m
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "WeatherSearchViewController.h"
#import "Constants.h"

#import "SearchTableViewCell.h"

@interface WeatherSearchViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSString *searchItem;
@property (strong, nonatomic) NSMutableArray *weathers;

//@property (strong, nonatomic) Location *location;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSURLSessionTask *dataTask;

@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation WeatherSearchViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weathers = [NSMutableArray new];
    self.dataStack = [DataStack new];
    
    self.searchTextField.delegate = self;
    
    [self.searchTextField addTarget:self
                             action:@selector(searchingTextField)
                   forControlEvents:UIControlEventEditingChanged];
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center=self.view.center;
    
    self.activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view addSubview:self.activityView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method -

- (void)searchingTextField {
    if ([self.searchTextField.text isEqualToString:@""]) {
        self.activityView.hidden = YES;
    } else {
        self.activityView.hidden = NO;
        [self searchCity];
        
    }
}
- (void)searchCity {
    //    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    
    NSString *stringURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/find?q=%@&type=like&APPID=%@", self.searchTextField.text, API_KEY];
    
    self.searchItem = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    [self jsonRequest:self.searchItem];
    
    
}

- (float)convertToCelsius:(float)kelvin {
    
    float celsius;
    
    celsius = kelvin - 273.15;
    
    return celsius;
}

- (void)createEntity:(Location *)location{
    
    WeatherLocation *weatherLocation = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherLocation" inManagedObjectContext:self.dataStack.context];
    
    weatherLocation.locationName = location.cityName;
    weatherLocation.currentTemperature = [location.temperature floatValue];
    weatherLocation.country = location.country;
    weatherLocation.longitude = [location.longitude floatValue];
    weatherLocation.latitude = [location.latitude floatValue];
    weatherLocation.condition = location.condition;
    
    NSLog(@"lat %f lon %f", weatherLocation.latitude, weatherLocation.longitude);
    
    NSError *saveError = nil;
    
    if (![self.dataStack.context save:&saveError]) {
        NSLog(@"Save failed! %@", saveError);
    }
    
    
}

#pragma mark - JSON request -

- (void)jsonRequest:(NSString *)searchString{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [self.dataTask suspend];
    [self.dataTask cancel];
    
    
    
    self.dataTask = [session dataTaskWithURL:[NSURL URLWithString:searchString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //
        
        if (!error) {
            //            [self.activityView stopAnimating];
            
            NSMutableArray *newWeathers = [NSMutableArray array];
            NSError *jsonError = nil;
            
            NSDictionary *weatherDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSArray *lists = [weatherDict objectForKey:@"list"];
            
            for (NSDictionary *list in lists) {
                
                NSString *name = [list objectForKey:@"name"];
                
                NSDictionary *coord = [list objectForKey:@"coord"];
                NSNumber *lon = [coord objectForKey:@"lon"];
                NSNumber *lat = [coord objectForKey:@"lat"];
                
                NSDictionary *main = [list objectForKey:@"main"];
                NSNumber *temperature = [main objectForKey:@"temp"];
                
                NSDictionary *sys = [list objectForKey:@"sys"];
                NSString *country = [sys objectForKey:@"country"];
                
                NSArray *weather = [list objectForKey:@"weather"];
                NSString *condition = [[weather objectAtIndex:0] objectForKey:@"main"];
                
                float temp = [self convertToCelsius:[temperature floatValue]];
                
                Location *location = [[Location alloc] initWithCity:name temperature:[NSNumber numberWithFloat:temp] country:country longitude:lon latitude:lat condition:condition];
                
                [newWeathers addObject:location];
                
            }
            //            [activityView stopAnimating];
            //            activityView.hidden = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.weathers = newWeathers;
                
                [self.tableView reloadData];
                
            });
        }
        
        
    }];
    
    [self.dataTask resume];
}

#pragma mark - Table view datasource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.weathers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Location *location = self.weathers[indexPath.row];
    self.activityView.hidden = YES;
    cell.cityLabel.text = location.cityName;
    cell.countryLabel.text = location.country;
    
    return cell;
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // tell map view about new entry
    
    Location *location = self.weathers[indexPath.row];
    
    [self createEntity:location];
    [self.delegate newEntry:location];
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Textfield delegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField resignFirstResponder];
    return YES;
}

@end
