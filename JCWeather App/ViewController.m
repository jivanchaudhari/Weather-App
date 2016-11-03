//
//  ViewController.m
//  JCWeather App
//
//  Created by Student P_02 on 17/10/16.
//  Copyright © 2016 Jivan Chaudhari. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   // [self startLocation];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startLocation {
    
    myLocationManager = [[CLLocationManager alloc]init];
    
    myLocationManager.delegate = self;
    
    [myLocationManager requestWhenInUseAuthorization];
    
    [myLocationManager startUpdatingLocation];
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentlocation = [locations lastObject];
    NSLog(@"Latitude :%f",currentlocation.coordinate.latitude);
    
   
    NSLog(@"Latitude :%f",currentlocation.coordinate.longitude);
    
    
    latitude = [NSString stringWithFormat:@"%f",currentlocation.coordinate.latitude];
    
    longitude = [NSString stringWithFormat:@"%f",currentlocation.coordinate.longitude];

    
    if (currentlocation != nil) {
        [myLocationManager stopUpdatingLocation];
    }
    
 
    
    [self getForeCastWeatherDataWithlatitude:latitude longitude:longitude APIKey:@kWeatherKey];
    
 
  }

-(void)getForeCastWeatherDataWithlatitude:(NSString *)latitude
                               longitude:(NSString *)longitude
                                  APIKey:(NSString *) key {
   
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=7&APPID=%@&units=metric",latitude,longitude,key];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
  
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@" Task ERROR %@",error.localizedDescription);
            //alert
            
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        
                        //jsonparsing
                        NSError *error;
                        
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        if (error) {
                            
                            //alert
                            NSLog(@"%@ jsonDic Not display",error.localizedDescription);
                        }
                        else {
                            [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonDictionary waitUntilDone:NO];
                            
                        }
                    }
                    else {
                        //alert
                        NSLog(@"Data Not Accept");
                    }
                }
                else {
                    NSLog(@"Staus code not set");
                    //alert
                }
            }
            else {
                NSLog(@"Responce");
                //alert
                
            }
        }
    }];
    [task resume];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"device_cell"];
    
    NSDictionary *dailyDictionary = [list objectAtIndex:indexPath.row];
    
    
    cell.labelTwo.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKeyPath:@"temp.day"]];
    
    
//    cell.label.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKey:@"humidity"]];
   
   NSArray * weather = [dailyDictionary valueForKey:@"weather"];
   
    NSDictionary *weatherDictionary = weather.firstObject;
    
    NSString *unix =[dailyDictionary valueForKey:@"dt"];
    
    
    
    
    NSTimeInterval  time = unix.doubleValue;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:time];
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    
    [dataFormatter setLocale:[NSLocale currentLocale]];
    
    [dataFormatter setDateFormat:@"EEEE"];
    
    NSString *dayString = [dataFormatter stringFromDate:date];
    
    cell.labelOne.text = [NSString stringWithFormat:@"%@",dayString];
    
    
    cell.labelThree.text = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
   

   // cell.labelFour.text = [NSString stringWithFormat:@"%@",date];
    
    cell.labelFive.text = [NSString stringWithFormat:@"%@",[city valueForKey:@"name"]];
    
  //  _labelTemperature.text =
    return cell;
    
    
}
-(void)updateUI:(NSDictionary *)resultDictionary {
   
//    
   NSLog(@"%@",resultDictionary);
    
    list = [resultDictionary valueForKey:@"list"];
    city = [resultDictionary valueForKey:@"city"];
    
        
    
  
    
    
    NSString *unix = [NSString stringWithFormat:@"%@",[list valueForKey:@"dt"]];
    
    double unixTimeStamp = unix.intValue;
    
    NSTimeInterval _interval  =   unixTimeStamp;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:_interval];
    
    NSDateFormatter *formatterDate= [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterHours= [[NSDateFormatter alloc] init];
    
    
    [formatterDate setLocale:[NSLocale currentLocale]];
    [formatterHours setLocale:[NSLocale currentLocale]];
    
    
    [formatterDate setDateFormat:@"dd-MMMM-yyyy"];
    
    //[formatterDate setDateFormat:@"dd-MMMM-yyyy"];
    
   [formatterHours setDateFormat:@"HH:mm a"];
    
    
    NSString *dateString = [formatterDate stringFromDate:date];
    NSString *hoursString = [formatterHours stringFromDate:date];
    
    
    
    [formatterHours setDateFormat:@"EEEE"];
    
    NSString *dayString = [formatterHours stringFromDate:date];
    
    
    
    NSDictionary *TempDictionary = list.firstObject;
    
    
    _labelTemperature.text = [NSString stringWithFormat:@"%@",[TempDictionary valueForKeyPath:@"temp.day"]];
    
    _labelCondition.text = [NSString stringWithFormat:@"%@",dayString];
    
    
    _labelCity.text = [NSString stringWithFormat:@"%@",dateString];
    

    [self.myTableView reloadData];
    
}

- (IBAction)currentWheatherAction:(id)sender {
    
    [self startLocation];
  
}
@end
