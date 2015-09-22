//
//  FirstViewController.h
//  WeatherApp
//
//  Created by Steve on 2015-09-19.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "WeatherLocation.h"

@interface WeatherDetailViewController : UIViewController

//@property (strong, nonatomic) DataStack *dataStack;
@property (strong, nonatomic) WeatherLocation *weatherLocation;

@end