//
//  WeatherDetailViewController.m
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "WeatherSearchViewController.h"
#import "Constants.h"

@interface WeatherSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSString *searchItem;
@property (strong, nonatomic) NSMutableArray *weathers;

@end

@implementation WeatherSearchViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weathers = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method -

- (void)searchCity {
    
    NSString *stringURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=%@", self.searchTextField.text, API_KEY];
    
    self.searchItem = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self jsonRequest:self.searchItem];
}

- (float)convertToCelsius:(float)kelvin {
    
    float celsius;
    
    celsius = kelvin - 273.15;
    
    return celsius;
}

#pragma mark - JSON request -

- (void)jsonRequest:(NSString *)searchString {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:searchString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSError *jsonError = nil;
            
            NSDictionary *weatherDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSString *name = [weatherDict objectForKey:@"name"];
            
            NSDictionary *main = [weatherDict objectForKey:@"main"];
            NSNumber *temperature = [main objectForKey:@"temp"];
            
//            NSString *cod = [weatherDict objectForKey:@"cod"];
//            
//            if ([cod isEqualToString:@"404"]) {
//                NSLog(@"Testing");
//                
//            }
            
            float temp = [self convertToCelsius:[temperature floatValue]];
            
            Location *location = [[Location alloc] initWithCity:name temperature:[NSNumber numberWithFloat:temp]];
            
//            [self.weathers addObject:location];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
                [self.delegate cityName:location];
            });
        }
        
        
    }];
    
    [dataTask resume];
}

#pragma mark - IBAction -

- (IBAction)addLocation:(UIButton *)sender {
    
    [self searchCity];
    
    
    
//    [self.navigationController popViewControllerAnimated:YES];
}

@end
