//
//  Weather.h
//  WeatherApp
//
//  Created by Steve on 2015-09-19.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (strong, nonatomic) NSNumber *lng;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSString *condition;
@property (strong, nonatomic) NSNumber *temp;

- (instancetype)initWithLng:(NSNumber *)lng lat:(NSNumber *)lat cityName:(NSString *)cityName condition:(NSString *)condition temp:(NSNumber *)temp;

@end
