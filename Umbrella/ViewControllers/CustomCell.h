//
//  CustomCell.h
//  Umbrella
//
//  Created by Jamie Thomason on 12/27/12.
//  Copyright (c) 2012 Umbrella Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView* weatherIcon;
@property (nonatomic, strong) IBOutlet UILabel* weatherCondition;
@property (nonatomic, strong) IBOutlet UILabel* weatherTemp;
@property (nonatomic, strong) IBOutlet UILabel* weatherTime;

@end
