//
//  LocationManager.m
//  WeatherApp
//
//  Created by Steve on 2015-09-22.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@end

@implementation LocationManager

+ (instancetype)sharedLocationManager {
    static LocationManager *sharedMyLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyLocationManager = [[self alloc] init];
    });
    
    
    return sharedMyLocationManager;
}

- (void)setUpLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [_locationManager requestAlwaysAuthorization];
//    [_locationManager requestWhenInUseAuthorization];

    [_locationManager startUpdatingLocation];
    
    
}

- (void)startLocationManager:(UIViewController *)UIViewController{
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [self setUpLocation];
            
        }else if (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)){
            [self setUpLocation];
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services are disabled. Please go into Settings > Privacy > Location to enable them"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:nil];
            [alert addAction:action];
            [UIViewController presentViewController:alert animated:YES completion:nil];
            
        }
    }
}

#pragma mark - Location Manager Delegate -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (!self.currentLocation) {
        self.currentLocation = [locations firstObject];
        [self.delegate updateLocation:[locations firstObject]];
    } else {
        self.currentLocation = [locations firstObject];
//        [self.delegate updateLocation:[locations firstObject]];
    }
}

@end
