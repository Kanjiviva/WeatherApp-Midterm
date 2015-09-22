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
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSString *condition;

- (instancetype)initWithCity:(NSString *)cityName temperature:(NSNumber *)temperature country:(NSString *)country longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude condition:(NSString *)condition;

@end
