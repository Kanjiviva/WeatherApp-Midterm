//
//  TodayViewController.m
//  WeatherWidget
//
//  Created by Steve on 2015-09-23.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "LocationManager.h"
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property(nonatomic, copy) void (^completionHandler)(NCUpdateResult);
@property(nonatomic) BOOL hasSignaled;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.locationLabel.text = @"testing";
    [[LocationManager sharedLocationManager] startLocationManager:self];
    [self jsonRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [[LocationManager sharedLocationManager] startLocationManager:self];
    [self jsonRequest];
}

//- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
//    self.completionHandler = completionHandler;
//    // Do work.
//    [self jsonRequest];
////    self.completionHandler(NCUpdateResultNewData);
//}
//
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    if (!self.hasSignaled) [self signalComplete:NCUpdateResultFailed];
//}
//
//- (void)signalComplete:(NCUpdateResult)updateResult {
//    NSLog(@"Signaling complete: %lu", updateResult);
//    self.hasSignaled = YES;
//    if (self.completionHandler) self.completionHandler(updateResult);
//}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    [self jsonRequest];
    completionHandler(NCUpdateResultNewData);
}

#pragma mark - JSON Request -

- (void)jsonRequest {
    
    NSString *stringURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@", [LocationManager sharedLocationManager].currentLocation.coordinate.latitude, [LocationManager sharedLocationManager].currentLocation.coordinate.longitude, API_KEY];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:stringURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@", stringURL);
        NSLog(@"Error: %@", error);
        
        if (!error) {
            
            NSError *jsonError = nil;
            
            NSDictionary *weatherDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSString *name = [weatherDict objectForKey:@"name"];
            
            NSDictionary *main = [weatherDict objectForKey:@"main"];
            NSNumber *temp = [main objectForKey:@"temp"];
            
            float currentTemp = [temp floatValue] - 273.15;
            
            NSString *currentTempString = [NSString stringWithFormat:@"%.1f", currentTemp];
            
            NSArray *weathers = [weatherDict objectForKey:@"weather"];
            
            NSString *condition = [[weathers objectAtIndex:0] objectForKey:@"main"];
            
            if ([condition isEqualToString:@"Rain"] && [weathers objectAtIndex:1] != nil) {
                condition = [[weathers objectAtIndex:1] objectForKey:@"main"];
            } else {
                condition = [[weathers objectAtIndex:0] objectForKey:@"main"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.locationLabel.text = [NSString stringWithFormat:@"%@  %@", name, currentTempString];
                
//                if ([condition isEqualToString:@"Rain"]) {
//                    self.iconImageView.image = [UIImage imageNamed:@"Rain-26.png"];
//                } else if ([condition isEqualToString:@"Clouds"]) {
//                    self.iconImageView.image = [UIImage imageNamed:@"Clouds-26.png"];
//                } else if ([condition isEqualToString:@"Clear"]) {
//                    self.iconImageView.image = [UIImage imageNamed:@"Sun-24.png"];
//                } else if ([condition isEqualToString:@"Snow"]) {
//                    self.iconImageView.image = [UIImage imageNamed:@"Snow-24.png"];
//                } else if ([condition isEqualToString:@"Mist"]) {
//                    self.iconImageView.image = [UIImage imageNamed:@"Fog Day-24.png"];
//                }
            });
        }
    }];
    [dataTask resume];
}

@end
