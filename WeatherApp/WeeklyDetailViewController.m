//
//  WeeklyDetailViewController.m
//  WeatherApp
//
//  Created by Derrick Park on 2015-09-22.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "WeeklyDetailViewController.h"

@interface WeeklyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescription;
@property (weak, nonatomic) IBOutlet UILabel *lowestTemp;
@property (weak, nonatomic) IBOutlet UILabel *highestTemp;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *condition;

@end

@implementation WeeklyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    // Create the colors
    UIColor *topColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithRed:56.0/255.0 green:56.0/255.0 blue:56.0/255.0 alpha:1.0];
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    //Add gradient to view
    
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    self.cityLabel.text = self.forcastWeather.cityName;
    self.dateLabel.text = [self dayStringFromTime:self.forcastWeather.time];
    self.weatherImage.image = [self getImage:self.forcastWeather.condition];
    self.weatherDescription.text = self.forcastWeather.weatherDesciption;
    self.lowestTemp.text = [NSString stringWithFormat:@"%.1fºC", self.forcastWeather.lowestTemp];
    self.highestTemp.text = [NSString stringWithFormat:@"%.1fºC", self.forcastWeather.highestTemp];
    self.humidity.text = [NSString stringWithFormat:@"%.1f%%", self.forcastWeather.humidity];
    self.condition.text = self.forcastWeather.condition;

}

- (UIImage *)getImage:(NSString *)condition {
    UIImage *image;
    if ([condition isEqualToString:@"Rain"] || [condition isEqualToString:@"Mist"] ) {
        image = [UIImage imageNamed:@"rain.png"];
    } else if ([condition isEqualToString:@"Clouds"]) {
        image = [UIImage imageNamed:@"cloudy.png"];
    } else if ([condition isEqualToString:@"Clear"]) {
        image = [UIImage imageNamed:@"clear-day.png"];
    } else if ([condition isEqualToString:@"Snow"]) {
        image = [UIImage imageNamed:@"snow.png"];
    } else {
        image = [UIImage imageNamed:@"default.png"];
    }
    return image;
}
-(NSString *) dayStringFromTime:(double)unixtime {
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:unixtime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *longFormatWithoutYear = [NSDateFormatter dateFormatFromTemplate:@"EEEE, dd MMM" options:0 locale:[NSLocale currentLocale]];
    dateFormatter.dateFormat = longFormatWithoutYear;
    return [dateFormatter stringFromDate:date];
    
}
@end
