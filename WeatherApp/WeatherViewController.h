//
//  FirstViewController.h
//  WeatherApp
//
//  Created by Steve on 2015-09-19.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataStack.h"
#import "Constants.h"
#import "CustomTableViewCell.h"

@interface WeatherViewController : UIViewController

@property (strong, nonatomic) DataStack *dataStack;

@end

