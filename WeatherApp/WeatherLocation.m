//
//  WeatherLocation.m
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "WeatherLocation.h"

@implementation WeatherLocation

// Insert code here to add functionality to your managed object subclass

-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

-(NSString *)title {
    return [NSString stringWithFormat:@"City: %@", self.locationName];
}


-(NSString *)subtitle {
    return [NSString stringWithFormat:@"%0.1f",self.currentTemperature];
}

@end
