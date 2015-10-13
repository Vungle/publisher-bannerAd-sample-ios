//
//  InnerAdDemoTableViewController.m
//  BannerSampleApp
//
//  Created by JiaYining on 10/2/15.
//  Copyright © 2015 Vungle. All rights reserved.
//

#import "InnerAdDemoTableViewController.h"
#import "AdDemoDatas.h"
#import "InnerAdTableViewCell.h"
#import <VungleSDK/VungleSDK.h>
#import "FloatingWindowManager.h"

static NSInteger sAdSectionIndex = 0;

@interface InnerAdDemoTableViewController()<VungleSDKDelegate>

@property (strong, nonatomic) UIView* adViewContainer;
@property (assign, nonatomic) BOOL alreadyPlayed;

@end

@implementation InnerAdDemoTableViewController

- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary *)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet
{
    [self.tableView reloadData];
}


- (void)vungleSDKAdPlayableChanged:(BOOL)isAdPlayable
{
    if (isAdPlayable)
    {
        [self playAd];
    }
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.adViewContainer = [[UIView alloc] init];
    self.adViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [[VungleSDK sharedSDK] setScreenTopOffset:self.navigationController.navigationBar.bounds.size.height];
    [VungleSDK sharedSDK].bannerView = self.adViewContainer;
    [VungleSDK sharedSDK].floatingView = [FloatingWindowManager FloatingWindow:self.navigationController.view];
    [[VungleSDK sharedSDK] setDelegate:self];
    [VungleSDK sharedSDK].muted = NO;
    self.alreadyPlayed = NO;
    [self playAd];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[VungleSDK sharedSDK] scrollViewDidScroll:scrollView];
}

-(void) playAd
{
    if ([[VungleSDK sharedSDK] isAdPlayable] && !_alreadyPlayed)
    {
        _alreadyPlayed = YES;
        NSError* error;
        [[VungleSDK sharedSDK] playAd:self error:&error];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.isMovingFromParentViewController)
    {
        [VungleSDK sharedSDK].bannerView = nil;
        [[VungleSDK sharedSDK] setDelegate: nil];
        [[VungleSDK sharedSDK] exitPlayAd];
    }
    [super viewDidDisappear:animated];
}

-(void) vungleSDKwillShowAd
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [AdDemoDatas datas].count +1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == sAdSectionIndex)
    {
        UITableViewCell* tableViewCell= [[UITableViewCell alloc] init];
        self.adViewContainer.frame = tableViewCell.bounds;
        [tableViewCell addSubview:self.adViewContainer];
        return tableViewCell;
    }
    else
    {
        InnerAdTableViewCell* tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"adDemoTableViewCell" forIndexPath:indexPath];
        
        if (indexPath.section < sAdSectionIndex)
        {
            tableViewCell.cellInfo = [[AdDemoDatas datas] objectAtIndex:indexPath.section];
        }
        else
        {
            tableViewCell.cellInfo = [[AdDemoDatas datas] objectAtIndex:indexPath.section - 1];
        }
        
        return tableViewCell;
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == sAdSectionIndex)
    {
        if ([VungleSDK sharedSDK].isAdPlaying)
        {
            return 300;
        }
        else
        {
            return 0;
        }
    }
    return 150;
}
@end
