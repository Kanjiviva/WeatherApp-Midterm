//
//  SearchTableViewCell.h
//  WeatherApp
//
//  Created by Steve on 2015-09-21.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end
