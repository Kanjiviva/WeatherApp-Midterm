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
#import "WeatherSearchViewController.h"
#import "Location.h"
#import <AVFoundation/AVFoundation.h>

@interface MapViewController () <MKMapViewDelegate, LocationManagerDelegate, WeatherSearchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) AVAudioPlayer *mySoundPlayer;

@property (strong, nonatomic) NSMutableArray *weathers;
@property (strong, nonatomic) NSMutableArray *allLists;
@property (strong, nonatomic) NSMutableArray *allPins;

@property (strong, nonatomic) Location *location;

@property (nonatomic) BOOL shouldPlay;
//@property (strong, nonatomic) WeatherLocation *weatherLocation;

@property (nonatomic) int currentIndex;

@end

@implementation MapViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldPlay = YES;
    self.currentIndex = 0;
    
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
    [super viewWillAppear:animated];
    [self favoriteLocationsPin];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mySoundPlayer stop];
}

- (void)differentSound:(NSURL *)soundURL {
    
    NSError *error = nil;
    self.mySoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    self.mySoundPlayer .volume=0.8f; //between 0 and 1
    [self.mySoundPlayer prepareToPlay];
    [self.mySoundPlayer play];
    self.shouldPlay = NO;
}

#pragma mark - Location Manager -

- (void)updateLocation:(CLLocation *)currentLocation {
    
    NSLog(@"Zoom - IN");
    MKCoordinateRegion region;
    
    //Set Zoom level using Span
    MKCoordinateSpan span;
    
    
    region.center.latitude = currentLocation.coordinate.latitude;
    region.center.longitude = currentLocation.coordinate.longitude;
    
    span.latitudeDelta = _mapView.region.span.latitudeDelta / 10000;
    span.longitudeDelta = _mapView.region.span.longitudeDelta / 10000;
    region.span=span;
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - Helper Methods -

- (void)newEntry:(Location *)location {
    
    self.location = location;
    
    if ([self.location.condition isEqualToString:@"Rain"]) {
        NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"rain" ofType:@"mp3"]];
        [self differentSound:soundURL];
    } else if ([self.location.condition isEqualToString:@"Clear"]) {
        NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"clear" ofType:@"mp3"]];
        [self differentSound:soundURL];
    } else if ([self.location.condition isEqualToString:@"Thunderstorm"]) {
        NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"thunderstorm" ofType:@"mp3"]];
        [self differentSound:soundURL];
    } else if ([self.location.condition isEqualToString:@"Clouds"]) {
        NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"clouds" ofType:@"mp3"]];
        [self differentSound:soundURL];
    }
    
    MKCoordinateRegion region;
    
    //Set Zoom level using Span
    MKCoordinateSpan span;
    
    
    region.center.latitude = [self.location.latitude floatValue];
    region.center.longitude = [self.location.longitude floatValue];
    
    span.latitudeDelta = _mapView.region.span.latitudeDelta / 15000;
    span.longitudeDelta = _mapView.region.span.longitudeDelta / 15000;
    region.span=span;
    [self.mapView setRegion:region animated:YES];
    
}

- (void)allWeatherLocations:(WeatherLocation *)weatherLocation {
    
    Location *location = [[Location alloc] initWithCity:weatherLocation.locationName temperature:[NSNumber numberWithFloat:weatherLocation.currentTemperature] country:weatherLocation.country longitude:[NSNumber numberWithFloat:weatherLocation.longitude] latitude:[NSNumber numberWithFloat:weatherLocation.latitude] condition:weatherLocation.condition];
    
    [self newEntry:location];
    
}

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
    NSError *fetchError = nil;
    NSArray *allWeathers = [self.dataStack.context executeFetchRequest:fetch error:&fetchError];
    
    NSLog(@"all weathers lists are: %@", allWeathers);
    
    self.allLists = [allWeathers mutableCopy];
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

- (IBAction)movingRight:(UIButton *)sender {
    
    if ([self.allLists count] != 0) {
        self.currentIndex++;
        if (self.currentIndex < [self.allLists count]) {
            [self allWeatherLocations:self.allLists[self.currentIndex]];
        } else {
            self.currentIndex = 0;
            [self allWeatherLocations:self.allLists[self.currentIndex]];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OOPS!"
                                                                       message:@"There's nothing in you list yet! Add them NOW!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (IBAction)movingLeft:(UIButton *)sender {
    if ([self.allLists count] != 0) {
        self.currentIndex--;
        if (self.currentIndex >=0) {
            [self allWeatherLocations:self.allLists[self.currentIndex]];
        } else {
            self.currentIndex = (int)[self.allLists count] - 1;
            [self allWeatherLocations:self.allLists[self.currentIndex]];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OOPS!"
                                                                       message:@"There's nothing in you list yet! Add them NOW!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (IBAction)findCurrentLocation:(UIBarButtonItem *)sender {
    [self updateLocation:[LocationManager sharedLocationManager].currentLocation];
}


#pragma mark - Annotation Delegate -

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    
    [self.mapView selectAnnotation:mp animated:YES];
}

#pragma mark - Annotation View -


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([view.annotation isKindOfClass:[MapPin class]]){
        WeatherLocation *weatherLocation = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherLocation" inManagedObjectContext:self.dataStack.context];
        MapPin *pin = (MapPin*)view.annotation;
        
        weatherLocation.latitude = pin.coordinate.latitude;
        weatherLocation.longitude = pin.coordinate.longitude;
        
        
        weatherLocation.locationName = pin.cityName;
        
        weatherLocation.currentTemperature = [pin.currentTemp floatValue];
        weatherLocation.condition = pin.condition;
        weatherLocation.country = pin.country;
        
        NSError *saveError = nil;
        
        if (![self.dataStack.context save:&saveError]) {
            NSLog(@"Save failed! %@", saveError);
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Saved!"
                                                                       message:@"You have saved a location"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        self.tabBarController.selectedIndex = 1;
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops! Unable to save!"
                                                                       message:@"You already have a existing lcoation!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[WeatherLocation class]] || [annotation isKindOfClass:[MapPin class]] ) {
        
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapPin"];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        [annotationView setSelected:YES animated:YES];
        
        if ([annotation isKindOfClass:[WeatherLocation class]]) {
            annotationView.image = [UIImage imageNamed:@"Flag Filled -24.png"];
        } else {
            annotationView.image = [UIImage imageNamed:@"Map Pin-26.png"];
        }
        
        
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        // View for left accessory
        
        UIView *viewLeftAccessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, annotationView.frame.size.height, annotationView.frame.size.height)];
        
        UIImageView *temp=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, annotationView.frame.size.height-5, annotationView.frame.size.height-5)];
        
        MapPin *weatherLocation = annotation;
        
        if ([weatherLocation.condition isEqualToString:@"Rain"]) {
            temp.image = [UIImage imageNamed:@"Rain-26.png"];
            if ([annotation isKindOfClass:[MapPin class]]) {
                NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"rain" ofType:@"mp3"]];
                [self differentSound:soundURL];
            }
            
        } else if ([weatherLocation.condition isEqualToString:@"Clouds"]) {
            temp.image = [UIImage imageNamed:@"Clouds-26.png"];
            if ([annotation isKindOfClass:[MapPin class]]) {
                NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"clouds" ofType:@"mp3"]];
                [self differentSound:soundURL];
            }
            
        } else if ([weatherLocation.condition isEqualToString:@"Clear"]) {
            temp.image = [UIImage imageNamed:@"Sun-24.png"];
            if ([annotation isKindOfClass:[MapPin class]]) {
                NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"clear" ofType:@"mp3"]];
                [self differentSound:soundURL];
            }
        } else if ([weatherLocation.condition isEqualToString:@"Snow"]) {
            temp.image = [UIImage imageNamed:@"Snow-24.png"];
            
        } else if ([weatherLocation.condition isEqualToString:@"Mist"]) {
            temp.image = [UIImage imageNamed:@"Fog Day-24.png"];
            
        } else if ([weatherLocation.condition isEqualToString:@"Thunderstorm"]) {
            temp.image = [UIImage imageNamed:@"Storm-25.png"];
            if ([annotation isKindOfClass:[MapPin class]]) {
                NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"thunderstorm" ofType:@"mp3"]];
                [self differentSound:soundURL];
            }
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
            
            NSDictionary *sys = [weatherDict objectForKey:@"sys"];
            
            NSString *country = [sys objectForKey:@"country"];
            
            Weather *weather = [[Weather alloc] initWithLng:[NSNumber numberWithFloat:lng]  lat:[NSNumber numberWithFloat:lat] cityName:cityName condition:condition temp:[NSNumber numberWithFloat:temperatureInCelsius]];
            
            MapPin *pin = [[MapPin alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng) andTitle:[NSString stringWithFormat:@"City: %@", cityName] andSubtitle:[NSString stringWithFormat:@"%.1f C", temperatureInCelsius]];
            
            pin.condition = condition;
            pin.cityName = cityName;
            pin.currentTemp = [NSNumber numberWithFloat:temperatureInCelsius];
            pin.country = country;
            
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

#pragma mark - prepare for segue -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSearch"]) {
        WeatherSearchViewController *weatherSearchVC = segue.destinationViewController;
        weatherSearchVC.delegate = self;
    }
}

@end
