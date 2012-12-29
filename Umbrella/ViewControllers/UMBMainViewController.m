//
//  UMBMainViewController.m
//  Umbrella
//
//  Created by Ben Dolmar on 9/12/12.
//  Copyright (c) 2012 Ben Dolmar. All rights reserved.
//

#import "UMBMainViewController.h"
#import <QuartzCore/CALayer.h>

@interface UMBMainViewController () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation UMBMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [iboBackgroundImage setImage:[UIImage imageNamed:@"detail_header_background"]];
    
    // Draw cell border between cells.  Needs to move to CellForTableAtIndexPath and turn on/off based on cell position
    iboTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    iboTableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];

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
    // return [self.tableViewData count];
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return [[self.tableViewData objectAtIndex:section] count];
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell* cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"WeatherCell" forIndexPath:indexPath];
    cell.weatherTemp.text = @"100\u00B0";
    cell.weatherTime.text = @"10:00 AM";
    cell.weatherCondition.text = @"SHALLOW FOG";
    
    NSURL * imageURL = [NSURL URLWithString:@"http://icons.wxug.com/i/c/i/partlycloudy.gif"];
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
    
    cell.backgroundColor = [UIColor lightGrayColor];
    
    // create dashed line
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, 300, 400);
//    CGContextStrokePath(context);
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = @"Just a title";
    switch (section) {
        case 0:
            sectionTitle = @"MONDAY";
            break;

        case 1:
            sectionTitle = @"TUESDAY";
            break;

        case 2:
            sectionTitle = @"WEDNESDAY";
            break;

        case 3:
            sectionTitle = @"THURSDAY";
            break;

        case 4:
            sectionTitle = @"FRIDAY";
            break;

        case 5:
            sectionTitle = @"SATURDAY";
            break;

        case 6:
            sectionTitle = @"SUNDAY";
            break;
        default:
            break;
    }
        
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
    
    
    
    
    //[view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"section_header_background"]]];
    //view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"section_header_background"]];
    [view addSubview:label];
    
    // hide border
    view.layer.borderColor = [[UIColor clearColor]CGColor];
    return view;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
