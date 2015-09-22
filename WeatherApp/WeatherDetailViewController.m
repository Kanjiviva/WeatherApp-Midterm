//
//  FirstViewController.m
//  WeatherApp
//
//  Created by Steve on 2015-09-19.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "WeatherDetailViewController.h"
#import "WeatherApp-Swift.h"

@interface WeatherDetailViewController ()

@property (strong, nonatomic) NSString *searchItem;
@property (strong, nonatomic) NSMutableArray *forecastWeathers;

@end

@implementation WeatherDetailViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.forecastWeathers = [NSMutableArray new];
    
    [self searchForecast];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper methods -

- (float)convertToCelsius:(float)kelvin {
    
    float celsius;
    
    celsius = kelvin - 273.15;
    
    return celsius;
}

#pragma mark - JSON Request -

- (void)searchForecast {
    
    NSString *stringURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?q=%@&APPID=%@", self.weatherLocation.locationName, API_KEY];
    
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
                NSDictionary *main = [list objectForKey:@"main"];
                NSNumber *currentTemp = [main objectForKey:@"temp"];
                NSNumber *highestTemp = [main objectForKey:@"temp_max"];
                NSNumber *lowestTemp = [main objectForKey:@"temp_min"];
                NSNumber *humidity = [list objectForKey:@"humidity"];
                
                float currentTemperature = [self convertToCelsius:[currentTemp floatValue]];
                float tempMax = [self convertToCelsius:[highestTemp floatValue]];
                float tempMin = [self convertToCelsius:[lowestTemp floatValue]];
                
                NSArray *weather = [list objectForKey:@"weather"];
                NSString *condition = [[weather objectAtIndex:0] objectForKey:@"main"];
                NSString *weatherDescription = [[weather objectAtIndex:0] objectForKey:@"description"];
                
                NSNumber *time = [list objectForKey:@"dt"];
                
                ForecastWeather *forecast = [[ForecastWeather alloc] initWithCityName:cityName country:country currentTemp:currentTemperature highestTemp:tempMax lowestTemp:tempMin humidity:[humidity floatValue] condition:condition weatherDesciption:weatherDescription time:[time floatValue]];
                
                [self.forecastWeathers addObject:forecast];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Do all UI Stuff in here
                
                
            });
            
        }
    }];

    [dataTask resume];
    
    
}

@end
