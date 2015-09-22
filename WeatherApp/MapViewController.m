//
//  SecondViewController.m
//  WeatherApp
//
//  Created by Steve on 2015-09-19.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "MapViewController.h"
#import "WeatherLocation.h"
#import "LocationManager.h"
#import "MapPin.h"
#import "Weather.h"
#import "Constants.h"

@interface MapViewController () <MKMapViewDelegate, LocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSMutableArray *weathers;
@property (strong, nonatomic) NSMutableArray *allLists;
@property (strong, nonatomic) NSMutableArray *allPins;

@end

@implementation MapViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    
    self.dataStack = [DataStack new];
    
    self.weathers = [NSMutableArray new];
    
    self.allLists = [NSMutableArray new];
    self.allPins = [NSMutableArray new];
    
    [LocationManager sharedLocationManager].delegate = self;
    
    [[LocationManager sharedLocationManager] startLocationManager:self];
    
    [self favoriteLocationsPin];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self favoriteLocationsPin];
}

#pragma mark - Location Manager -

- (void)updateLocation:(CLLocation *)currentLocation {
    
    NSLog(@"Zoom - IN");
    MKCoordinateRegion region;
    
    //Set Zoom level using Span
    MKCoordinateSpan span;
    
    
    region.center.latitude = currentLocation.coordinate.latitude;
    region.center.longitude = currentLocation.coordinate.longitude;
    
    self.currentLocation = currentLocation;
    
    span.latitudeDelta=_mapView.region.span.latitudeDelta / 15000;
    span.longitudeDelta=_mapView.region.span.longitudeDelta / 15000;
    region.span=span;
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - Helper Methods -

- (float)convertToCelsius:(float)kelvin {
    
    float celsius;
    
    celsius = kelvin - 273.15;
    
    return celsius;
}

- (void)favoriteLocationsPin {
    
    [self reloadLocation];
    
    if ([self.allLists count] != 0) {
        
        
        [self.mapView removeAnnotations:[self.mapView annotations]];
        
        for (WeatherLocation *weatherLocation in self.allLists) {
            //MapPin *pin = [[MapPin alloc] initWithCoordinate:CLLocationCoordinate2DMake(weatherLocation.latitude, weatherLocation.longitude) andTitle:[NSString stringWithFormat:@"City: %@. Weather: %@", weatherLocation.locationName, weatherLocation.condition] andSubtitle:[NSString stringWithFormat:@"%.1f", weatherLocation.currentTemperature]];
            
            //pin.condition = weatherLocation.condition;
            
            NSLog(@"lat %f lon %f", weatherLocation.latitude, weatherLocation.longitude);
            
            
            [self.mapView addAnnotation:weatherLocation];
            
        }
    } else {
        [self.mapView removeAnnotations:[self.mapView annotations]];
    }
    
}

#pragma mark - Fetch Request -

- (void)reloadLocation {
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"WeatherLocation"];
    
    //    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"todoTitle" ascending:YES]];
    
    NSError *fetchError = nil;
    NSArray *allWeathers = [self.dataStack.context executeFetchRequest:fetch error:&fetchError];
    
    NSLog(@"all weathers lists are: %@", allWeathers);
    
    self.allLists = [allWeathers mutableCopy];
    
    //    [self.tableView reloadData];
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
    
    if ([annotation isKindOfClass:[WeatherLocation class]] || [annotation isKindOfClass:[MapPin class]] ) {
        
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapPin"];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"Map Pin-26.png"];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        // View for left accessory
        
        UIView *viewLeftAccessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, annotationView.frame.size.height, annotationView.frame.size.height)];
        
        UIImageView *temp=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, annotationView.frame.size.height-5, annotationView.frame.size.height-5)];
        
        
        //if ([annotation isKindOfClass:[WeatherLocation class]] ) {
        MapPin *weatherLocation = annotation;
        
        if ([weatherLocation.condition isEqualToString:@"Rain"]) {
            temp.image = [UIImage imageNamed:@"Rain-26.png"];
        } else if ([weatherLocation.condition isEqualToString:@"Clouds"]) {
            temp.image = [UIImage imageNamed:@"Clouds-26.png"];
        } else if ([weatherLocation.condition isEqualToString:@"Clear"]) {
            temp.image = [UIImage imageNamed:@"Sun-24.png"];
        } else if ([weatherLocation.condition isEqualToString:@"Snow"]) {
            temp.image = [UIImage imageNamed:@"Snow-24.png"];
        } else if ([weatherLocation.condition isEqualToString:@"Mist"]) {
            temp.image = [UIImage imageNamed:@"Fog Day-24.png"];
        }
        
        temp.contentMode = UIViewContentModeScaleAspectFit;
        
        [viewLeftAccessory addSubview:temp];
        
        annotationView.leftCalloutAccessoryView=viewLeftAccessory;
        
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
            
            NSString *cityName = [weatherDict objectForKey:@"name"];
            
            NSDictionary *main = [weatherDict objectForKey:@"main"];
            
            NSNumber *temp = [main objectForKey:@"temp"];
            
            float temperatureInCelsius = [self convertToCelsius:[temp floatValue]];
            
            NSArray *weathers = [weatherDict objectForKey:@"weather"];
            
            NSString *condition = [[weathers objectAtIndex:0] objectForKey:@"main"];
            
            Weather *weather = [[Weather alloc] initWithLng:[NSNumber numberWithFloat:lng]  lat:[NSNumber numberWithFloat:lat] cityName:cityName condition:condition temp:[NSNumber numberWithFloat:temperatureInCelsius]];
            
            MapPin *pin = [[MapPin alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng) andTitle:[NSString stringWithFormat:@"City: %@. Weather: %@",cityName, condition] andSubtitle:[NSString stringWithFormat:@"%.1f C", temperatureInCelsius]];
            
            pin.condition = condition;
            
            NSLog(@"Location lat %f, lon %f ", lat, lng);
            
            [self.weathers addObject:weather];
            
            [self.allPins addObject:pin];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (![self.allPins containsObject:pin]) {
                    [self.mapView addAnnotation:pin];
                } else {
                    [self.mapView removeAnnotations:self.allPins];
                    [self.mapView addAnnotation:pin];
                }
                
            });
        }
    }];
    
    [dataTask resume];
}
- (IBAction)findCurrentLocation:(UIBarButtonItem *)sender {
    [self updateLocation:self.currentLocation];
}

// search view did add entry

// zoom in on new entry

@end
