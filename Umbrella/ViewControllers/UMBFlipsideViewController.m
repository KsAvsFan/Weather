//
//  UMBFlipsideViewController.m
//  Umbrella
//
//  Created by Ben Dolmar on 9/12/12.
//  Copyright (c) 2012 Ben Dolmar. All rights reserved.
//

#import "UMBFlipsideViewController.h"

@interface UMBFlipsideViewController ()

@end

@implementation UMBFlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set background image for view controller
    [iboBackgroundImage setImage:[UIImage imageNamed:@"settings_background"]];
    
    // format ShowWeather button
    iboShowWeatherButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, (iboShowWeatherButton.titleLabel.frame.size.width + 10.0f), 5.0f, 0.0f);
    [iboShowWeatherButton setImage:[UIImage imageNamed:@"submit_icon"] forState:UIControlStateNormal];

    UIImage *backgroundImage = [[UIImage imageNamed:@"button_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f) resizingMode:UIImageResizingModeStretch];
    [iboShowWeatherButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [iboShowWeatherButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, -20.0f, 6.0f, 0.0f)];
    
    // format dotted line
//    iboDottedLine1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];
//    iboDottedLine2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];
//    iboDottedLine1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];
//    iboDottedLine1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];
//    iboDottedLine1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];
    for (UIView* view in self.view.subviews)
    {
        [view viewWithTag:101].backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)updateTemperatureScale:(UIButton*)sender
{   
    
    [sender setBackgroundImage:[UIImage imageNamed:@"checkmark_on"] forState:UIControlStateNormal];
    
    if (sender.tag == 1) {
        [iboCentigradeButton setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
    }
    else {
        [iboFarenheitButton setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
