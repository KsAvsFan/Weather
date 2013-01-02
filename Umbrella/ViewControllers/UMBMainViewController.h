//
//  UMBMainViewController.h
//  Umbrella
//
//  Created by Ben Dolmar on 9/12/12.
//  Copyright (c) 2012 Ben Dolmar. All rights reserved.
//

#import "UMBFlipsideViewController.h"
#import "Constants.h"
#import "CustomCell.h"
#import "WeatherAPIClient.h"



@interface UMBMainViewController : UIViewController <UMBFlipsideViewControllerDelegate>
{
    IBOutlet UIImageView*               iboBackgroundImage;
    IBOutlet UITableView*               iboTableView;
    
    IBOutlet UILabel*                   iboTemp;
    IBOutlet UILabel*                   iboConditions;
    IBOutlet UILabel*                   iboPrecipitation;
    IBOutlet UILabel*                   iboHumidity;
    IBOutlet UILabel*                   iboWindSpeed;
    IBOutlet UILabel*                   iboLocation;
    
    IBOutlet UIView*                    iboActivityObfuscationView;
    IBOutlet UIActivityIndicatorView*   iboActivityIndicator;
}

@property WeatherAPIClient* myWeatherClient;
@property (strong, nonatomic) NSMutableArray*           tableData;
@property (strong, nonatomic) NSMutableArray*           todayArray;
@property (strong, nonatomic) NSMutableArray*           tomorrowArray;
@property (strong, nonatomic) NSMutableArray*           dayAfterTomorrowArray;
@property (strong, nonatomic) NSMutableDictionary*      userPreferences;
//@property (strong, nonatomic) NSError*                  blockError;

@end
