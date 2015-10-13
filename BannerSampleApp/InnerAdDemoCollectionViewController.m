
//
//  InnerAdDemoCollectionViewController.m
//  BannerSampleApp
//
//  Created by JiaYining on 10/3/15.
//  Copyright © 2015 Vungle. All rights reserved.
//

#import "InnerAdDemoCollectionViewController.h"
#import "InnerAdCollectionViewCell.h"
#import "AdDemoDatas.h"
#import "FloatingWindowManager.h"
#import  <VungleSDK/VungleSDK.h>

static NSString* kheaderIdentifier = @"reuseHeader";

@interface InnerAdDemoCollectionViewController()<VungleSDKDelegate>

@property (strong) UIView* adContainerView;
@property (assign, nonatomic) BOOL alreadyPlayed;

@end

@implementation InnerAdDemoCollectionViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.adContainerView = [[UIView alloc] init];
    self.adContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    [self setupVungleAd];
    [self playAd];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void) setupVungleAd
{
    [VungleSDK sharedSDK].bannerView = self.adContainerView;
    [VungleSDK sharedSDK].floatingView = [FloatingWindowManager FloatingWindow:self.view];
    [VungleSDK sharedSDK].muted = NO;
    [[VungleSDK sharedSDK] setDelegate:self];
    [[VungleSDK sharedSDK] setScreenTopOffset:self.navigationController.navigationBar.bounds.size.height];
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
    if ([VungleSDK sharedSDK].isAdPlayable && !_alreadyPlayed)
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
    return [AdDemoDatas datas].count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InnerAdCollectionViewCell * cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"adDemoCollectionViewCell" forIndexPath:indexPath];
    cell.cellInfo = [[AdDemoDatas datas] objectAtIndex:indexPath.row];
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier forIndexPath:indexPath];
        self.adContainerView.frame = reusableview.bounds;
        [reusableview addSubview:self.adContainerView];
    }
    
    return reusableview;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([[VungleSDK sharedSDK] isAdPlaying])
    {
        return CGSizeMake(200,200);
    }
    else
        return CGSizeZero;
}


@end
