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
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;

@property(nonatomic, copy) void (^completionHandler)(NCUpdateResult);
@property(nonatomic) BOOL hasSignaled;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LocationManager sharedLocationManager] startLocationManager:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
//    [[LocationManager sharedLocationManager] startLocationManager:self];
    [self jsonRequest:activityView];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

//    [self jsonRequest];
    completionHandler(NCUpdateResultNewData);
}
- (IBAction)tapRecognizer:(UITapGestureRecognizer *)sender {
    NSURL *pjURL = [NSURL URLWithString:@"AppUrlType://home"];
    [self.extensionContext openURL:pjURL completionHandler:nil];
}

#pragma mark - JSON Request -

- (void)jsonRequest:(UIActivityIndicatorView *)activityView {
    
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
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityView stopAnimating];
                self.locationLabel.text = [NSString stringWithFormat:@"%@  %@ºC", name, currentTempString];
                self.conditionLabel.text = condition;
                
                if ([condition isEqualToString:@"Rain"]) {
                    self.iconImageView.image = [UIImage imageNamed:@"rain.png"];
                } else if ([condition isEqualToString:@"Clouds"]) {
                    self.iconImageView.image = [UIImage imageNamed:@"cloudy.png"];
                } else if ([condition isEqualToString:@"Clear"]) {
                    self.iconImageView.image = [UIImage imageNamed:@"clear-day.png"];
                } else if ([condition isEqualToString:@"Snow"]) {
                    self.iconImageView.image = [UIImage imageNamed:@"snow.png"];
                } else if ([condition isEqualToString:@"Mist"]) {
                    self.iconImageView.image = [UIImage imageNamed:@"fog.png"];
                } else {
                    self.iconImageView.image = [UIImage imageNamed:@"defaut.png"];
                }
            });
        }
    }];
    [dataTask resume];
}

@end
