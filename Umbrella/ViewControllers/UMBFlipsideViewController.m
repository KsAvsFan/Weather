//
//  UMBFlipsideViewController.m
//  Umbrella
//
//  Created by Ben Dolmar on 9/12/12.
//  Copyright (c) 2012 Ben Dolmar. All rights reserved.
//

#import "UMBFlipsideViewController.h"

@interface UMBFlipsideViewController () <UITextFieldDelegate>

@end

@implementation UMBFlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // load user preferences if they exist
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userPreferences"]) {
        _userPreferences= [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userPreferences"]];
    }
    else {
        _userPreferences = [@{
                            @"zipCode"          : @"55431",
                            @"tempPreference"   : @"1"
                            } mutableCopy];
    }
    
    iboZipCodeTextField.text = [_userPreferences objectForKey:@"zipCode"];
    if ([[_userPreferences objectForKey:@"tempPreference"] isEqualToString:@"1"]) {
        [iboFarenheitButton setBackgroundImage:[UIImage imageNamed:@"checkmark_on"] forState:UIControlStateNormal];
        [iboCentigradeButton setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
    }
    else {
        [iboCentigradeButton setBackgroundImage:[UIImage imageNamed:@"checkmark_on"] forState:UIControlStateNormal];
        [iboFarenheitButton setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
    }
    
    // set background image for view controller
    [iboBackgroundImage setImage:[UIImage imageNamed:@"settings_background"]];
    
    // format ShowWeather button
    iboShowWeatherButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, (iboShowWeatherButton.titleLabel.frame.size.width + 10.0f), 5.0f, 0.0f);
    [iboShowWeatherButton setImage:[UIImage imageNamed:@"submit_icon"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [[UIImage imageNamed:@"button_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f) resizingMode:UIImageResizingModeStretch];
    [iboShowWeatherButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [iboShowWeatherButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, -20.0f, 6.0f, 0.0f)];
    
    // format dotted lines
    for (UIView* view in self.view.subviews)
    {
        [view viewWithTag:101].backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];
    }
    
    [self enableDoneButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [iboZipCodeTextField resignFirstResponder];
}

#pragma mark - Actions

-(void)enableDoneButton
{
    if (iboZipCodeTextField.text) {
        iboShowWeatherButton.enabled = YES;
    }
}
- (IBAction)done:(id)sender
{
    // save zip and temperature scale to NSUserDefaults
    [_userPreferences setObject:iboZipCodeTextField.text forKey:@"zipCode"];

    [[NSUserDefaults standardUserDefaults] setObject:_userPreferences forKey:@"userPreferences"];
    
    // call segue
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)updateTemperatureScale:(UIButton*)sender
{   
    // Update background image of button pressed by user
    [sender setBackgroundImage:[UIImage imageNamed:@"checkmark_on"] forState:UIControlStateNormal];
    
    // Change background of other button (not selected)
    if (sender.tag == 1) {
        [iboCentigradeButton setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
    }
    else {
        [iboFarenheitButton setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
    }
    
    // Update user preferences with teperature scale preference
    [_userPreferences setObject:[NSString stringWithFormat:@"%d", sender.tag] forKey:@"tempPreference"];
    
    [self enableDoneButton];

}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    // Allow return key to dismiss keyboard
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    // Make sure user enters valid US zip code
    NSString *regEx = @"^\\d{5}(-\\d{4})?$"; // Allow zip or zip+4
    NSRange r = [textField.text rangeOfString:regEx options:NSRegularExpressionSearch];
    
    if (r.location == NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zip Code Error"
                                                     message:@"US Zip Codes only ex: 99999-9999"
                                                    delegate:self
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }else{
        return YES;
    }
}
@end
