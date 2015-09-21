//
//  WeatherListTableViewController.h
//  WeatherApp
//
//  Created by Steve on 2015-09-20.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataStack.h"
#import "Constants.h"
#import "CustomTableViewCell.h"
#import "WeatherSearchViewController.h"
#import "Location.h"

@interface WeatherListTableViewController : UITableViewController <WeatherSearchViewControllerDelegate>

@end
