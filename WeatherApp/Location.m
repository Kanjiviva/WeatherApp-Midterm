//
//  Location.m
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithCity:(NSString *)cityName temperature:(NSNumber *)temperature country:(NSString *)country longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude condition:(NSString *)condition
{
    self = [super init];
    if (self) {
        _country = country;
        _cityName = cityName;
        _temperature = temperature;
        _longitude = longitude;
        _latitude = latitude;
        _condition = condition;
    }
    return self;
}

@end
