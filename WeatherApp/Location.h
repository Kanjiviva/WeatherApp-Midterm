//
//  Location.h
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSNumber *temperature;

- (instancetype)initWithCity:(NSString *)cityName temperature:(NSNumber *)temperature;

@end
