//
//  LocationManager.h
//  WeatherApp
//
//  Created by Steve on 2015-09-22.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@protocol LocationManagerDelegate <NSObject>

- (void)updateLocation:(CLLocation *)currentLocation;

@end

@interface LocationManager : NSObject 

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) id<LocationManagerDelegate> delegate;

+ (instancetype)sharedLocationManager;
- (void)startLocationManager:(UIViewController *)UIViewController;
- (void)setUpLocation;

@end
