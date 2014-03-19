//
//  ViewController.m
//  GPS_test
//
//  Created by freakout on 2014/03/12.
//  Copyright (c) 2014年 Taiki. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property NSString* message;
@property CLLocationManager *locationManager;
@property (nonatomic) BOOL deferredLocationUpdates;
@property (strong, nonatomic) NSMutableArray *locationItems;

@end


@implementation ViewController

-(void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _locationItems = [NSMutableArray array];
    _deferredLocationUpdates = NO;
    
    _longitude = 0.0000;
	_latitude = 0.0000;
    
    UILabel *lon = [[UILabel alloc] initWithFrame:CGRectMake(30,100,100,30)];
    UILabel *lat = [[UILabel alloc] initWithFrame:CGRectMake(30,160,100,30)];
    lon.text = @"経度:";
    lat.text = @"緯度:";
    
    lonlabel = [[UILabel alloc] initWithFrame:CGRectMake(130,100,100,30)];
    latlabel = [[UILabel alloc] initWithFrame:CGRectMake(130,160,100,30)];
    
    NSString *str_longitude = [NSString stringWithFormat:@"%f", _longitude];
    NSString *str_latitude = [NSString stringWithFormat:@"%f", _latitude];
    lonlabel.text =  str_longitude;
    latlabel.text = str_latitude;
    
    [self.view addSubview:lonlabel];
    [self.view addSubview:latlabel];
    [self.view addSubview:lon];
    [self.view addSubview:lat];
    
	// ロケーションマネージャーを作成
	_locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.activityType = CLActivityTypeFitness;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
    // 位置情報取得開始
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	// 位置情報更新
    [_locationItems addObjectsFromArray:locations];
	// 表示更新
	//lonlabel.text = [NSString stringWithFormat:@"%f",_longitude];
	//latlabel.text = [NSString stringWithFormat:@"%f",_latitude];
    if(!_deferredLocationUpdates){
        CLLocationDistance distance = 50.0;
        NSTimeInterval time = 10.0;
        [_locationManager allowDeferredLocationUpdatesUntilTraveled:distance timeout:time];
        _deferredLocationUpdates = YES;
    }
}


- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    _deferredLocationUpdates = NO;
    CLLocationCoordinate2D nowLoc = manager.location.coordinate;
    [self sendLocationRequest:nowLoc];
}

- (void)sendLocationRequest:(CLLocationCoordinate2D)location {
    NSString *server = @"http://www.hahahatatata.net/?from=gps_test_iphone";
    NSString *urlAsString = [NSString stringWithFormat:@"%@&longitude=%f&latitude=%f",server, location.longitude, location.latitude];
    lonlabel.text = [NSString stringWithFormat:@"%f", location.latitude];
	latlabel.text = [NSString stringWithFormat:@"%f", location.longitude];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //[urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:
     ^(NSURLResponse *res, NSData *data, NSError *error) {
         if(data){
             
         }
     }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
