//
//  WeatherLocation+CoreDataProperties.h
//  WeatherApp
//
//  Created by Steve on 2015-09-21.
//  Copyright © 2015 Steve. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeatherLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherLocation (CoreDataProperties)

@property (nonatomic) float currentTemperature;
@property (nullable, nonatomic, retain) NSString *currentWeather;
@property (nonatomic) float highestTemperature;
@property (nullable, nonatomic, retain) NSString *locationName;
@property (nonatomic) float lowestTemperature;
@property (nullable, nonatomic, retain) NSString *weatherDescription;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *country;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (nullable, nonatomic , retain) NSString *condition;

@end

NS_ASSUME_NONNULL_END
