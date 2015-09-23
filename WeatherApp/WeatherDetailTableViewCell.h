//
//  WeatherDetailTableViewCell.h
//  WeatherApp
//
//  Created by Derrick Park on 2015-09-22.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@end
