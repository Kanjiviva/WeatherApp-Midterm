//
//  WeatherDetailViewController.h
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "DataStack.h"
#import "WeatherLocation.h"

@protocol WeatherSearchViewControllerDelegate <NSObject>

- (void)newEntry:(Location *)location;

@end

@interface WeatherSearchViewController : UIViewController

@property (strong, nonatomic) DataStack *dataStack;

@property (strong, nonatomic) id<WeatherSearchViewControllerDelegate> delegate;

@end
