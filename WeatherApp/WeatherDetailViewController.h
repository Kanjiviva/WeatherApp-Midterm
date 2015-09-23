//
//  WeatherDetailViewController.h
//  WeatherApp
//
//  Created by Derrick Park on 2015-09-22.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "WeatherLocation.h"
#import "DataStack.h"
#import "Constants.h"

@interface WeatherDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DataStack *dataStack;
@property (strong, nonatomic) WeatherLocation *weatherLocation;

@end
