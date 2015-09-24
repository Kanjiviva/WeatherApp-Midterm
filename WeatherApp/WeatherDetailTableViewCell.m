//
//  WeatherDetailTableViewCell.m
//  WeatherApp
//
//  Created by Derrick Park on 2015-09-22.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "WeatherDetailTableViewCell.h"

@implementation WeatherDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [UIView animateWithDuration:1.0f
                     animations:^{
                         CGRect frame = self.weatherImage.frame;
                         NSLog(@"%f, %f", self.weatherImage.frame.size.height,self.weatherImage.frame.size.width);
                         frame.size.width -= 10.0f;
                         frame.size.height -= 10.0f;
                         self.weatherImage.frame = frame;
                         NSLog(@"%f, %f", self.weatherImage.frame.size.height,self.weatherImage.frame.size.width);
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
