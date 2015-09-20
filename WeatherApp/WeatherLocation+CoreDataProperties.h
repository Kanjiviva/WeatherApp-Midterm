//
//  WeatherLocation+CoreDataProperties.h
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeatherLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherLocation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *location;
@property (nonatomic) int16_t currentTemperature;
@property (nonatomic) int16_t lowestTemperature;
@property (nullable, nonatomic, retain) NSString *highestTemperature;
@property (nullable, nonatomic, retain) NSString *currentWeather;

@end

NS_ASSUME_NONNULL_END
