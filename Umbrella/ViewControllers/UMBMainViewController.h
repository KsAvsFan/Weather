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

@interface UMBMainViewController : UIViewController <UMBFlipsideViewControllerDelegate>
{
    IBOutlet UIImageView*       iboBackgroundImage;
    IBOutlet UITableView*       iboTableView;
}

@end
