//
//  SecondViewController.h
//  WeatherApp
//
//  Created by Steve on 2015-09-19.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapPin.h"
#import "Weather.h"
#import "Constants.h"
#import "DataStack.h"
#import <CoreData/CoreData.h>

@interface MapViewController : UIViewController

@property (strong, nonatomic) DataStack *dataStack;

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)favoriteLocationsPin;

@end

