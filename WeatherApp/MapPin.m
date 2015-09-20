//
//  MapPin.m
//  WeatherApp
//
//  Created by Steve on 2015-09-19.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle
{
    self = [super init];
    if (self) {
        _coordinate = aCoordinate;
        _title = aTitle;
        _subtitle = aSubtitle;
    }
    return self;
}

//- (MKAnnotationView *)annotationView {
//    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MapPin"
//                                        ];
//    annotationView.enabled = YES;
//    annotationView.canShowCallout = YES;
////    annotationView.image = [UIImage imageNamed:@"Map Pin-26.png"];
////    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
////    
////    UIView *viewLeftAccessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, annotationView.frame.size.height, annotationView.frame.size.height)];
////    
////    UIImageView *temp=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, annotationView.frame.size.height- 10, annotationView.frame.size.height -10)];
////    temp.image = [UIImage imageNamed:@"Rain-26.png"];
////    temp.contentMode = UIViewContentModeScaleAspectFit;
////    
////    [viewLeftAccessory addSubview:temp];
////    
////    annotationView.leftCalloutAccessoryView=viewLeftAccessory;
//    
//    return annotationView;
//    
//}

@end
