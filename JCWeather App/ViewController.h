//
//  ViewController.h
//  JCWeather App
//
//  Created by Student P_02 on 17/10/16.
//  Copyright © 2016 Jivan Chaudhari. All rights reserved.
//


#define kWeatherKey "3b9a58509d112b8af119679d49d26c9f"

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomTableViewCell.h"


@interface ViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>

{
    CLLocationManager *myLocationManager;
    NSString *latitude;
    NSString *longitude;
    NSArray *list;
    NSDictionary *city;
    NSMutableArray *forecast;
    
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *labelTemperature;
@property (strong, nonatomic) IBOutlet UILabel *labelCondition;
@property (strong, nonatomic) IBOutlet UILabel *labelCity;

- (IBAction)currentWheatherAction:(id)sender;

@end

