//
//  WeatherDetailViewController.m
//  WeatherApp
//
//  Created by Derrick Park on 2015-09-22.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "WeatherDetailViewController.h"
#import "WeatherApp-Swift.h"
#import "WeatherDetailTableViewCell.h"
#import "WeeklyDetailViewController.h"

@interface WeatherDetailViewController ()

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UIImageView *currentImage;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentDescriptionLabel;

@property (strong, nonatomic) NSString *searchItem;
@property (strong, nonatomic) NSMutableArray *forecastWeathers;

@end

@implementation WeatherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.forecastWeathers = [NSMutableArray new];
    
    [self searchForecast];
    [self configureView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureView {
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // Create the colors
    UIColor *topColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.mainView.bounds;
    //Add gradient to view
    
    [self.mainView.layer insertSublayer:theViewGradient atIndex:0];
    self.cityLabel.text = self.weatherLocation.locationName;
    self.currentTempLabel.text = [NSString stringWithFormat:@"%.1fºC",self.weatherLocation.currentTemperature];
    self.currentDescriptionLabel.text = self.weatherLocation.condition;
    self.currentImage.image = [self getImage:self.weatherLocation.condition];
    [UIView animateWithDuration:1.0f
                     animations:^{
                         CGRect frame = self.currentImage.frame;
                         frame.size.width += 100.0f;
                         frame.size.height += 100.0f;
                         self.currentImage.frame = frame;
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"WeeklyDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ForecastWeather *forcastWeather = self.forecastWeathers[indexPath.row];
        WeeklyDetailViewController *weeklyDetailVC = segue.destinationViewController;
        weeklyDetailVC.forcastWeather = forcastWeather;
    }
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.forecastWeathers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ForecastWeather *forecastWeather = self.forecastWeathers[indexPath.row];
    cell.tempLabel.text = [NSString stringWithFormat:@"%.1fºC", forecastWeather.currentTemp];
    cell.dayLabel.text = [self dayStringFromTime: forecastWeather.time];
    cell.weatherImage.image = [self getImage: forecastWeather.condition];
    
    return cell;
}

# pragma mark - TableView Delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
}

# pragma mark - Helper methods -

- (float)convertToCelsius:(float)kelvin {
    
    float celsius;
    
    celsius = kelvin - 273.15;
    
    return celsius;
}

- (UIImage *)getImage:(NSString *)condition {
    UIImage *image;
    if ([condition isEqualToString:@"Rain"]) {
        image = [UIImage imageNamed:@"rain.png"];
    } else if ([condition isEqualToString:@"Clouds"]) {
        image = [UIImage imageNamed:@"cloudy.png"];
    } else if ([condition isEqualToString:@"Clear"]) {
        image = [UIImage imageNamed:@"clear-day.png"];
    } else if ([condition isEqualToString:@"Snow"]) {
        image = [UIImage imageNamed:@"snow.png"];
    } else if([condition isEqualToString:@"Mist"]) {
        image = [UIImage imageNamed:@"fog.png"];
    } else {
        image = [UIImage imageNamed:@"default.png"];
    }
    return image;
}

- (NSString *) dayStringFromTime:(double)unixtime {
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:unixtime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    
    return [dateFormatter stringFromDate:date];
    
}

- (NSString *) dateStringFromTime:(double)unixtime {
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:unixtime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    
    return [dateFormatter stringFromDate:date];
}
#pragma mark - JSON Request -

- (void)searchForecast {
    
    NSString *stringURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&APPID=%@", self.weatherLocation.locationName, API_KEY];
    
    self.searchItem = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self jsonRequest:self.searchItem];
}

- (void)jsonRequest:(NSString *)searchString {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:searchString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSError *jsonError = nil;
            
            NSDictionary *weatherDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSDictionary *city = [weatherDict objectForKey:@"city"];
            NSString *cityName = [city objectForKey:@"name"];
            NSString *country = [city objectForKey:@"country"];
            
            NSArray *lists = [weatherDict objectForKey:@"list"];
            
            for (NSDictionary *list in lists) {
                NSDictionary *temp = [list objectForKey:@"temp"];
                NSNumber *currentTemp = [temp objectForKey:@"day"];
                NSNumber *highestTemp = [temp objectForKey:@"max"];
                NSNumber *lowestTemp = [temp objectForKey:@"min"];
                NSNumber *humidity = [list objectForKey:@"humidity"];
                
                float currentTemperature = [self convertToCelsius:[currentTemp floatValue]];
                float tempMax = [self convertToCelsius:[highestTemp floatValue]];
                float tempMin = [self convertToCelsius:[lowestTemp floatValue]];
                
                NSArray *weather = [list objectForKey:@"weather"];
                NSString *condition = [[weather objectAtIndex:0] objectForKey:@"main"];
                NSString *weatherDescription = [[weather objectAtIndex:0] objectForKey:@"description"];

                
                NSNumber *time = [list objectForKey:@"dt"];
                
                ForecastWeather *forecast = [[ForecastWeather alloc] initWithCityName:cityName country:country currentTemp:currentTemperature highestTemp:tempMax lowestTemp:tempMin humidity:[humidity floatValue] condition:condition weatherDesciption:weatherDescription time:[time doubleValue]];
                
                [self.forecastWeathers addObject:forecast];
        
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
            
        }
    }];
    
    [dataTask resume];
    
}




@end
