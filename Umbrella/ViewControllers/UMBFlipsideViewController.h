//
//  UMBFlipsideViewController.h
//  Umbrella
//
//  Created by Ben Dolmar on 9/12/12.
//  Copyright (c) 2012 Ben Dolmar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class UMBFlipsideViewController;

@protocol UMBFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(UMBFlipsideViewController *)controller;
@end

@interface UMBFlipsideViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField*   iboZipCodeTextField;
    IBOutlet UIButton*      iboFarenheitButton;
    IBOutlet UIButton*      iboCentigradeButton;
    IBOutlet UIImageView*   iboBackgroundImage;
    IBOutlet UIButton*      iboShowWeatherButton;
//    IBOutlet UIView*        iboDottedLine1;
//    IBOutlet UIView*        iboDottedLine2;
//    IBOutlet UIView*        iboDottedLine3;
//    IBOutlet UIView*        iboDottedLine4;
//    IBOutlet UIView*        iboDottedLine5;
    
}

@property (weak, nonatomic) id <UMBFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)updateTemperatureScale:(UIButton*)sender;

@end