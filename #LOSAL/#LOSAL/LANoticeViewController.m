//
//  LANoticeViewController.m
//  #LOSAL
//
//  Created by Joaquin Brown on 8/23/13.
//  Copyright (c) 2013 Localism. All rights reserved.
//

#import "LANoticeViewController.h"
#import "ECSlidingViewController.h"
#import "LANoticeItemCell.h"
#import "LANoticeItem.h"
#import "LANoticesStore.h"
#import "LAImageLoader.h"
#import "UIImage+Resize.h"

@implementation LANoticeViewController

- (void)viewDidLoad
{ 
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedUpdateNotification:)
                                                 name:@"updateNotices"
                                               object:nil];
    
    // prevent empty rows from filling rest of table
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.slidingViewController setAnchorLeftPeekAmount:50.0f];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    
    [[self tableView]setBackgroundColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [titleLabel setText:@"Notices"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:25]];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)receivedUpdateNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"updateNotices"])
        [[LANoticesStore defaultStore] updateEntries];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[[LANoticesStore defaultStore]allItems]count] > 0)
        return 1;

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[LANoticesStore defaultStore]allItems]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LANoticeItem *p = [[[LANoticesStore defaultStore]allItems]objectAtIndex:[indexPath row]];
    
    LANoticeItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
    if (cell == nil)
        cell = [[LANoticeItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NoticeCell"];
    
    [[LAImageLoader sharedManager]processImageDataWithURLString:[p noticeImageUrl]
                                                          forId:[[p postObject]objectId]
                                                       andBlock:^(UIImage *image) {
                                                           if (p.isAnAd)
                                                               [[cell adImage] setImage:[image resizedImage:cell.adImage.frame.size interpolationQuality:kCGInterpolationDefault]];
                                                           else
                                                               [[cell thumbnailImage] setImage:image];
                                                       }];
    
    if ([p isAnAd]) {
        [[cell titleLabel]setHidden:YES];
        [[cell thumbnailImage]setHidden:YES];
        [[cell adImage]setHidden:NO];
    }
    else {
        [[cell adImage]setHidden:YES];
        [[cell titleLabel]setText:[p noticeTitle]];
        [[cell titleLabel]setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LANoticeItem *p = [[[LANoticesStore defaultStore]allItems]objectAtIndex:[indexPath row]];
    
    if ([p isAnAd]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[p buttonLink]]];
    }
    else {
        UIViewController *anotherTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailNotices"];
    
        LADetailNoticeViewController *dtv = (LADetailNoticeViewController *)anotherTopViewController;
    
        [dtv setItem:[[[LANoticesStore defaultStore]allItems]objectAtIndex:[indexPath row]]];
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // show the detail notice VC modally
        [self presentViewController:dtv animated:YES completion:nil];
    }
}

- (void)dealloc
{
    self.delegate = nil;
}

@end
