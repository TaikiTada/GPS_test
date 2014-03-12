//
//  ViewController.m
//  GPS_test
//
//  Created by freakout on 2014/03/12.
//  Copyright (c) 2014年 Taiki. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _longitude = 0.0000;
	_latitude = 0.0000;
    
    UILabel *lon = [[UILabel alloc] initWithFrame:CGRectMake(30,100,100,30)];
    UILabel *lat = [[UILabel alloc] initWithFrame:CGRectMake(30,160,100,30)];
    lon.text = @"経度:";
    lat.text = @"緯度:";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    CGFloat w = CGRectGetWidth(self.view.frame);
    button.frame = CGRectMake((w - 200)/2,250,200,30);
    UIColor *color = [UIColor colorWithRed:0.145 green:0.587 blue:0.878 alpha:1.0];
    button.titleLabel.font = [UIFont fontWithName:@"メイリオ" size:(14.0)];
    [button setTitle:@"サーバに位置情報を送信" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    [button addTarget:self
               action:@selector(actionButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
	self.lonlabel.text = [NSString stringWithFormat:@"%f",_longitude];
	self.latlabel.text = [NSString stringWithFormat:@"%f",_latitude];
    
    [self.view addSubview:self.lonlabel];
    [self.view addSubview:self.latlabel];
    [self.view addSubview:lon];
    [self.view addSubview:lat];
    

    self.message = @"hogehoge";
    
	// ロケーションマネージャーを作成
	BOOL locationServicesEnabled;
	locationManager = [[CLLocationManager alloc] init];
	if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]) {
		// iOS4.0以降はクラスメソッドを使用
		locationServicesEnabled = [CLLocationManager locationServicesEnabled];
	} else {
		// iOS4.0以前はプロパティを使用
		locationServicesEnabled = locationManager.locationServicesEnabled;
	}
    
	if (locationServicesEnabled) {
		locationManager.delegate = self;
        
		// 位置情報取得開始
		[locationManager startUpdatingLocation];
	}
    
	
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	// 位置情報更新
	_longitude = newLocation.coordinate.longitude;
	_latitude = newLocation.coordinate.latitude;
    //NSLog(@"%f",_longitude);
    //NSLog(@"%f",_latitude);
	// 表示更新
	self.lonlabel.text = [NSString stringWithFormat:@"%f",_longitude];
	self.latlabel.text = [NSString stringWithFormat:@"%f",_latitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if (error) {
		NSString* message = nil;
		switch ([error code]) {
                // アプリでの位置情報サービスが許可されていない場合
			case kCLErrorDenied:
				// 位置情報取得停止
				[locationManager stopUpdatingLocation];
				message = [NSString stringWithFormat:@"このアプリは位置情報サービスが許可されていません。"];
				break;
			default:
				message = [NSString stringWithFormat:@"位置情報の取得に失敗しました。"];                
				break;
		}
		if (message) {
			// アラートを表示
			UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil
                                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}
}

- (IBAction)launchMapsApp {
	NSString* urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f", _latitude, _longitude];
	NSURL* url = [NSURL URLWithString:urlString];
	[[UIApplication sharedApplication] openURL:url];
}

- (IBAction)actionButtonTapped:(id)sender {
    // Do any additional setup after loading the view, typically from a nib.
    NSString *server = @"http://www.hahahatatata.net/?from=gps_test_iphone";
    //NSLog(@"tapped:%f", _latitude);
    NSString *urlAsString = [NSString stringWithFormat:@"%@&longitude=%f&latitude=%f",server, _longitude, _latitude];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
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
