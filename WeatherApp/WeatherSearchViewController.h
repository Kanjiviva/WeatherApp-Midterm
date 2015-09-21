//
//  WeatherDetailViewController.h
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@protocol WeatherSearchViewControllerDelegate <NSObject>

- (void)cityName:(Location *)location;

@end



@interface WeatherSearchViewController : UIViewController

@property (strong, nonatomic) id<WeatherSearchViewControllerDelegate> delegate;

@end
