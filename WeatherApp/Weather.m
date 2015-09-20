//
//  Weather.m
//  WeatherApp
//
//  Created by Steve on 2015-09-19.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "Weather.h"

@implementation Weather

- (instancetype)initWithLng:(NSNumber *)lng lat:(NSNumber *)lat cityName:(NSString *)cityName condition:(NSString *)condition temp:(NSNumber *)temp
{
    self = [super init];
    if (self) {
        _lng = lng;
        _lat = lat;
        _cityName = cityName;
        _condition = condition;
        _temp = temp;
    }
    return self;
}


@end
