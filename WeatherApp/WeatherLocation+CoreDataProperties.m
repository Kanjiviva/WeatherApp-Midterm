//
//  WeatherLocation+CoreDataProperties.m
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeatherLocation+CoreDataProperties.h"

@implementation WeatherLocation (CoreDataProperties)

@dynamic location;
@dynamic currentTemperature;
@dynamic lowestTemperature;
@dynamic highestTemperature;
@dynamic currentWeather;

@end
