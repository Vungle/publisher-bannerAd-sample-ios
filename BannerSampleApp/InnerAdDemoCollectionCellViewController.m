
//
//  InnerAdDemoCollectionViewController.m
//  BannerSampleApp
//
//  Created by JiaYining on 10/3/15.
//  Copyright © 2015 Vungle. All rights reserved.
//

#import "InnerAdDemoCollectionCellViewController.h"
#import "InnerAdCollectionViewCell.h"
#import "AdDemoDatas.h"
#import  <VungleSDK/VungleSDK.h>
#import "FloatingWindowManager.h"

static NSInteger sAdRowIndex = 0;

@interface InnerAdDemoCollectionCellViewController()<VungleSDKDelegate>

@property (strong) UIView* adContainerView;
@property (assign) NSInteger adRowIndex;
@property (assign, nonatomic) BOOL alreadyPlayed;

@end

@implementation InnerAdDemoCollectionCellViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.adRowIndex = sAdRowIndex;
    self.adContainerView = [[UIView alloc] init];
    self.adContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self setupVungleAd];
}


-(void) setupVungleAd
{
    [VungleSDK sharedSDK].bannerView = self.adContainerView;
    [VungleSDK sharedSDK].floatingView = [FloatingWindowManager FloatingWindow:self.view];
    [VungleSDK sharedSDK].muted = NO;
    [[VungleSDK sharedSDK] setDelegate:self];
    [[VungleSDK sharedSDK] setScreenTopOffset:self.navigationController.navigationBar.bounds.size.height];
    [self playAd];
    
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

-(void) playAd
{
    if ([[VungleSDK sharedSDK] isAdPlayable] && !_alreadyPlayed)
    {
        _alreadyPlayed = YES;
        NSError* error;
        [[VungleSDK sharedSDK] playAd:self error:&error];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[VungleSDK sharedSDK] scrollViewDidScroll:scrollView];
}

#pragma mark VungleSDK delegates

- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary *)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet
{
    [self.collectionView reloadData];
}

-(void) vungleSDKwillShowAd
{
    [self.collectionView reloadData];
}

- (void)vungleSDKAdPlayableChanged:(BOOL)isAdPlayable
{
    [self playAd];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return   1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[VungleSDK sharedSDK] isAdPlaying] ? [AdDemoDatas datas].count + 1 : [AdDemoDatas datas].count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[VungleSDK sharedSDK] isAdPlaying] == NO)
    {
        InnerAdCollectionViewCell * cell;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"adDemoCollectionViewCell" forIndexPath:indexPath];
        cell.cellInfo = [[AdDemoDatas datas] objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        if (indexPath.row == _adRowIndex)
        {
            if (_adContainerView)
            {
                [_adContainerView removeFromSuperview];
            }
            
            UICollectionViewCell * cell;
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdCollectionViewCell" forIndexPath:indexPath];
            self.adContainerView.frame = cell.bounds;
            [cell addSubview: self.adContainerView];
            return cell;
        }
        else if (indexPath.row < _adRowIndex)
        {
            InnerAdCollectionViewCell * cell;
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"adDemoCollectionViewCell" forIndexPath:indexPath];
            cell.cellInfo = [[AdDemoDatas datas] objectAtIndex:indexPath.row];
            return cell;
        }
        else
        {
            InnerAdCollectionViewCell * cell;
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"adDemoCollectionViewCell" forIndexPath:indexPath];
            cell.cellInfo = [[AdDemoDatas datas] objectAtIndex:indexPath.row -1];
            return cell;
        }
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _adRowIndex = indexPath.row;
    [collectionView reloadData];
}


@end
