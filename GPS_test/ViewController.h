//
//  ViewController.h
//  GPS_test
//
//  Created by freakout on 2014/03/12.
//  Copyright (c) 2014年 Taiki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate> {
	// ロケーションマネージャー
    
	// 現在位置記録用
	CLLocationDegrees _longitude;
	CLLocationDegrees _latitude;
    UILabel* lonlabel;
    UILabel* latlabel;
    
    
}

@end
