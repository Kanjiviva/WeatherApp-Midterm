//
//  SecondViewController.m
//  WeatherApp
//
//  Created by Steve on 2015-09-19.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) UIImage *iconImage;

@property (strong, nonatomic) NSMutableArray *weathers;

@end

@implementation MapViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    self.weathers = [NSMutableArray new];
    
    [self setUpLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods -

- (void)setUpLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; // 100 m
    
    self.mapView.showsUserLocation = YES;
    [_locationManager requestWhenInUseAuthorization];
    
    [_locationManager startUpdatingLocation];
    
    [self zoomInLocation];
}

- (void)startLocationManager{
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [self setUpLocation];
            
        }else if (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)){
            [self setUpLocation];
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services are disabled. Please go into Settings > Privacy > Location to enable them for Play "
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
}

- (float)convertToCelsius:(float)kelvin {
    
    float celsius;
    
    celsius = kelvin - 273.15;
    
    return celsius;
}

#pragma mark - Location Manager Delegate -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.currentLocation = [locations objectAtIndex:0];
    
}

- (void)zoomInLocation {
    
    NSLog(@"Zoom - IN");
    MKCoordinateRegion region;
    
    //Set Zoom level using Span
    MKCoordinateSpan span;
    
    region.center.latitude = _locationManager.location.coordinate.latitude;
    region.center.longitude = _locationManager.location.coordinate.longitude;
    
    span.latitudeDelta=_mapView.region.span.latitudeDelta / 15000;
    span.longitudeDelta=_mapView.region.span.longitudeDelta / 15000;
    region.span=span;
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - IBActions -

- (IBAction)tapRecognizer:(UITapGestureRecognizer *)sender {
    
    NSLog(@"TAPPED!");
    
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    NSLog(@"Location lat %f, log %f ", location.latitude, location.longitude);
    
    NSString *stringURL = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@", location.latitude, location.longitude, API_KEY];
    
    
    [self jsonRequest:stringURL lat:location.latitude lng:location.longitude];
    
}

#pragma mark - Annotation Delegate -

// this can be optional, will talk to Derrick about it
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    
    [self.mapView selectAnnotation:mp animated:YES];
    
}

#pragma mark - Annotation View -

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MapPin class]]) {
        
        //        MapPin *myLocation = (MapPin *)annotation;
        
        //        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MapPin"];
        
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapPin"];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"Map Pin-26.png"];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        
        // View for left accessory
        
        UIView *viewLeftAccessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, annotationView.frame.size.height, annotationView.frame.size.height)];
        
        UIImageView *temp=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, annotationView.frame.size.height-5, annotationView.frame.size.height-5)];
        temp.image = self.iconImage;
        temp.contentMode = UIViewContentModeScaleAspectFit;
        
        [viewLeftAccessory addSubview:temp];
        
        annotationView.leftCalloutAccessoryView=viewLeftAccessory;
        
        // View for detail accessory
        
//        UIView *viewDetailAccessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, annotationView.frame.size.width, annotationView.frame.size.height)];
//        
//        
//        annotationView.detailCalloutAccessoryView = viewDetailAccessory;
        
        if (annotationView == nil) {
            //            annotationView = [myLocation annotationView];
//            annotationView = annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    } else {
        return nil;
    }
}

#pragma mark - JSON Request -

- (void)jsonRequest:(NSString *)searchString lat:(float)lat lng:(float)lng{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:searchString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSError *jsonError = nil;
            
            NSDictionary *weatherDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            //            NSDictionary *coord = [weatherDict objectForKey:@"coord"];
            
            NSString *cityName = [weatherDict objectForKey:@"name"];
            
            //            NSNumber *lat = [coord objectForKey:@"lat"];
            //
            //            NSNumber *lon = [coord objectForKey:@"lon"];
            
            NSDictionary *main = [weatherDict objectForKey:@"main"];
            
            NSNumber *temp = [main objectForKey:@"temp"];
            
            float temperatureInCelsius = [self convertToCelsius:[temp floatValue]];
            
            NSArray *weathers = [weatherDict objectForKey:@"weather"];
            
            NSString *condition = [[weathers objectAtIndex:0] objectForKey:@"main"];
            
            Weather *weather = [[Weather alloc] initWithLng:[NSNumber numberWithFloat:lng]  lat:[NSNumber numberWithFloat:lat] cityName:cityName condition:condition temp:[NSNumber numberWithFloat:temperatureInCelsius]];
            
            //            Weather *weather = [[Weather alloc] initWithLng:lon lat:lat cityName:cityName condition:main];
            
            MapPin *pin = [[MapPin alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng) andTitle:[NSString stringWithFormat:@"Current Weather: %@", condition] andSubtitle:[NSString stringWithFormat:@"%.1f C", temperatureInCelsius]];
            
            if ([condition isEqualToString:@"Rain"]) {
                self.iconImage = [UIImage imageNamed:@"Rain-26.png"];
            } else if ([condition isEqualToString:@"Clouds"]) {
                self.iconImage = [UIImage imageNamed:@"Clouds-26.png"];
            } else if ([condition isEqualToString:@"Clear"]) {
                self.iconImage = [UIImage imageNamed:@"Sun-24.png"];
            } else if ([condition isEqualToString:@"Snow"]) {
                self.iconImage = [UIImage imageNamed:@"Snow-24.png"];
            }
            
            NSLog(@"Location lat %f, lon %f ", lat, lng);
            
            [self.weathers addObject:weather];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotation:pin];
            });
            
        }
        
        
        
    }];
    
    [dataTask resume];
}

@end
