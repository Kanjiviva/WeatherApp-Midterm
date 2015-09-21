//
//  Location.m
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithCity:(NSString *)cityName temperature:(NSNumber *)temperature
{
    self = [super init];
    if (self) {
        
        _cityName = cityName;
        _temperature = temperature;
        
    }
    return self;
}

@end
