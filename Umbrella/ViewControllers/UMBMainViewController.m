//
//  UMBMainViewController.m
//  Umbrella
//
//  Created by Ben Dolmar on 9/12/12.
//  Copyright (c) 2012 Ben Dolmar. All rights reserved.
//

#import "UMBMainViewController.h"
#import <QuartzCore/CALayer.h>
#import "WeatherAPIClient.h"

@interface UMBMainViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@end

@implementation UMBMainViewController

- (void)viewDidAppear:(BOOL)animated{
    
    // Load user preferences if they exist. Else show flipside so user can set their preferences
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userPreferences"]) {
        _userPreferences= [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userPreferences"]];
        [self getData:[_userPreferences valueForKey:@"zipCode"]];
    }
    else {
        [self performSegueWithIdentifier:@"showAlternate" sender:nil];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set background image
    [iboBackgroundImage setImage:[UIImage imageNamed:@"detail_header_background"]];
    
    // Create wearther api singleton and set api key
    _myWeatherClient = [WeatherAPIClient sharedClient];
    _myWeatherClient.APIKey = sWUApiKey;
}

-(void)getData:(NSString*)zipcode
{
    // Call weather api to get data
    self.tableData = [@[] mutableCopy];
    self.todayArray = [@[] mutableCopy];
    self.tomorrowArray = [@[] mutableCopy];
    self.dayAfterTomorrowArray = [@[] mutableCopy];
    
    [_myWeatherClient getForcastAndConditionsForZipCode:zipcode withCompletionBlock:^(BOOL success, NSDictionary *result, NSError *error) {
        
        // check for internet connection
        if (error) {
            //_blockError = error;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No internet available!", @"AlertView")
                                                                message:NSLocalizedString(@"You do not have an internet connection! Please connect to a 3G/4G/WIFI network.", @"AlertView")
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView") otherButtonTitles:NSLocalizedString(@"Open settings", @"AlertView"), nil];
            [alertView show];
            return;
        }
        
        // Enumerate over returned hourly results, separate into separate data structures to simply tableview population
        NSMutableArray *testArray = [result valueForKey:@"hourly_forecast"];
        NSLog(@"%@", testArray);
        for (NSDictionary* currentDictionary in testArray)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];  //Output :Friday
            NSDate *today = [NSDate date];
            NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:86400]; // 86400 seconds = 1 day, or tomorrow
            
            NSString *testString = [currentDictionary valueForKeyPath:@"FCTTIME.weekday_name"];
            if ([testString isEqualToString:[dateFormatter stringFromDate:today]]) {
                // Add dictionary to today array
                [_todayArray addObject:currentDictionary];
            }
            else if ([testString isEqualToString:[dateFormatter stringFromDate:tomorrow]]) {
                // add dictionary to tomorrow array
                [_tomorrowArray addObject:currentDictionary];
            }
            else {
                [_dayAfterTomorrowArray addObject:currentDictionary];
            }
        }
        
        // Get current_observations key from result json
        NSMutableDictionary *detailsDictionary = [result valueForKeyPath:@"current_observation"];
        [self populateDetails:detailsDictionary];
        
        // Stop the activity indicator and fade in UI
        [iboActivityIndicator stopAnimating];
        [UIView animateWithDuration:1.0 animations:^{
            iboActivityObfuscationView.alpha = 0.0;
            iboTableView.alpha = 1.0;
        }];
        
        // Refresh tableview with hourly data
        [self updateData];
        [iboTableView reloadData];
    }];
}

-(void)updateData
{
    [self.tableData addObject:self.todayArray];
    [self.tableData addObject:self.tomorrowArray];
    [self.tableData addObject:self.dayAfterTomorrowArray];
}


-(void)populateDetails:(NSDictionary*)detailsDictionary
{

    // selectedOption used throughout this method to denote US vs Metric units based on user perference settings
    NSString *selectedOption;
    
    // Get location and update UI
    iboLocation.text = [NSString stringWithFormat:@"%@, %@", [detailsDictionary valueForKeyPath:@"display_location.city"],[detailsDictionary valueForKeyPath:@"display_location.state_name"]];
    
    // Get precip, format to round to tenths, and update UI
    NSString *precipUnit;
    selectedOption = ([[_userPreferences objectForKey:@"tempPreference"] isEqualToString:@"1"] ? @"precip_today_in" : @"precip_today_cm");
    precipUnit = ([[_userPreferences objectForKey:@"tempPreference"] isEqualToString:@"1"] ? @" in" : @" cm");
    double precipDouble = [[detailsDictionary valueForKeyPath:selectedOption] doubleValue];
    NSString *formattedNumber = [NSString stringWithFormat:@"%.*f", fmod(round(precipDouble * 100), 100) ? 1 : 0, precipDouble];
    if (([formattedNumber isEqualToString:@"0"]) || ([formattedNumber floatValue] < 0.0f))
    {
        formattedNumber = @"0.0";
    }
    iboPrecipitation.text = [NSString stringWithFormat:@"%@%@", formattedNumber, precipUnit];
    
    // Get humity and update UI
    iboHumidity.text = [detailsDictionary valueForKeyPath:@"relative_humidity"];
    
    // Get wind speed and update UI
    NSString *windUnit;
    windUnit = ([[_userPreferences objectForKey:@"tempPreference"] isEqualToString:@"1"] ? @"MPH" : @"KPH");
    selectedOption = ([[_userPreferences objectForKey:@"tempPreference"] isEqualToString:@"1"] ? @"wind_mph" : @"wind_kph");
    iboWindSpeed.text = [NSString stringWithFormat:@"%@ %@",[detailsDictionary valueForKeyPath:selectedOption], windUnit];
    
    // Get temperature and update UI
    selectedOption = ([[_userPreferences objectForKey:@"tempPreference"] isEqualToString:@"1"] ? @"temp_f" : @"temp_c");    
    int stringInt = [[detailsDictionary valueForKeyPath:selectedOption] intValue]; // Convert string temp to Integer
    iboTemp.text = [NSString stringWithFormat:@"%d%@", stringInt, @"\u00B0"];
    
    // Get current conditions and update UI
    
    // TODO: Jamie - Need to test this between 11pm and midnight
    
    if ([self.todayArray objectAtIndex:0]) {
        iboConditions.text = [[[self.todayArray objectAtIndex:0] valueForKeyPath:@"condition"] uppercaseString];
    }
    else {
        iboConditions.text = [[[self.tomorrowArray objectAtIndex:0] valueForKeyPath:@"condition"] uppercaseString];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(UMBFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Obfuscate view controller and start activity indicator animation while data is pulled from API and repopulated
    [iboActivityIndicator startAnimating];
    [UIView animateWithDuration:1.0 animations:^{
        iboActivityObfuscationView.alpha = 0.4;
        iboTableView.alpha = 0.0;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark TableViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Number of sections = number of data structures in tableData array. 
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Number of rows in section = number of elements in section specific data structure
    return [[self.tableData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create the cell in tableview
    CustomCell* cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"WeatherCell" forIndexPath:indexPath];
    
    if (self.tableData) {
        
        NSString* selectedOption;
        
        // update cell temp
        selectedOption = ([[_userPreferences objectForKey:@"tempPreference"] isEqualToString:@"1"] ? @"temp.english" : @"temp.metric");
        cell.weatherTemp.text = [NSString stringWithFormat:@"%@%@", [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:selectedOption], @"\u00B0"];
        
        // update cell time
        cell.weatherTime.text = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"FCTTIME.civil"];
        
        // update cell weather condition
        // cell.weatherCondition.text = [[self.hourlyWeather objectAtIndex:indexPath.row] valueForKeyPath:@"condition"];
        cell.weatherCondition.text = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"condition"];
        
        // update cell icon
        NSString *urlString = [NSString stringWithString:[[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"icon_url"]];
        // Make sure to use the correct icon set per Code Challenge instructions (icon set 9)
        NSString *updatedURLString = [urlString stringByReplacingOccurrencesOfString:@"/k/" withString:@"/i/"];
        NSURL * imageURL = [NSURL URLWithString:updatedURLString];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        
        // resize icon to fit inside uiimageview in custom cell
        CGSize newSize = CGSizeMake(20, 20);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.weatherIcon.image = newImage;
        
        // draw border around weatherIcon
        cell.weatherIcon.layer.masksToBounds = YES;
        cell.weatherIcon.layer.borderColor = [UIColor blackColor].CGColor;
        cell.weatherIcon.layer.borderWidth = 1;
        
        // Draw cell border between cells.
        iboTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        iboTableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];
        
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // Set label text for header section
    NSString *sectionTitle = [[[[self.tableData objectAtIndex:section] objectAtIndex:0] valueForKeyPath:@"FCTTIME.weekday_name"] uppercaseString];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 0, 305, 22);
    label.textColor = [UIColor whiteColor];
    label.text = sectionTitle;
    label.backgroundColor = [UIColor clearColor];
    label.layer.borderColor = [[UIColor clearColor]CGColor];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:view.frame];
    [imageview setContentMode:UIViewContentModeScaleAspectFill];
    [imageview setImage:[UIImage imageNamed:@"section_header_background"]];
    [view addSubview:imageview];
    [view sendSubviewToBack:imageview];
    [view addSubview:label];
    
    // hide border
    view.layer.borderColor = [[UIColor clearColor]CGColor];
    
    return view;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    // Sets height for section header
    return 25;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // No editing. Data populated by API
    return NO;
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // Go to preferences page and get zip code ... again
            [self performSegueWithIdentifier:@"showAlternate" sender:nil];
            break;
            
        default:
            break;
    }
}

@end
