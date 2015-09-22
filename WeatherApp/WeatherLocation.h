//
//  WeatherLocation.h
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherLocation : NSManagedObject <MKAnnotation>

// Insert code here to declare functionality of your managed object subclass
-(CLLocationCoordinate2D)coordinate;
-(NSString *)title;
-(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END

#import "WeatherLocation+CoreDataProperties.h"
