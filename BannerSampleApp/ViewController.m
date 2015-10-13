//
//  ViewController.m
//  BannerSampleApp
//
//  Created by JiaYining on 9/18/15.
//  Copyright (c) 2015 Vungle. All rights reserved.
//

#import "ViewController.h"
#import "FloatingWindowManager.h"
#import <VungleSDK/VungleSDK.h>

static NSString* sOpenTableViewDemoSegueID = @"TableViewDemoSegue";
static NSString* sOpenCollectionViewDemoSegueID = @"CollectionViewDemoSegue";
static NSString* sOpenCollectionCellViewDemoSegueID = @"CollectionViewCellDemoSegue";
static NSString* sOpenScrollViewDemoSegueID = @"ScrollViewDemoSegue";


@interface ViewController ()

@property (weak) UIView* tableViewEntry;
@property (weak) UIView* collectionHeaderViewEntry;
@property (weak) UIView* collectionCellViewEntry;
@property (weak) UIView* scrollViewEntry;
@property (weak) UIView* fullScreenAdEntry;

-(void) initializeVungleSDK;

@end

@implementation ViewController

-(void) initializeVungleSDK
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubViews];
    [self createConstraints];
    [self initializeVungleSDK];
}

-(void)createConstraints
{
    [self subviewSizeConstraints];
    [self subviewPositionConstraints];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void) subviewSizeConstraints
{
    NSLayoutConstraint* tableViewHeight = [NSLayoutConstraint constraintWithItem:self.tableViewEntry attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.navigationController.view attribute:NSLayoutAttributeHeight multiplier:1/4 constant:0.f];
    tableViewHeight.priority = 999;
    
    NSLayoutConstraint *collectionHeaderViewHeight = [NSLayoutConstraint constraintWithItem:self.collectionHeaderViewEntry attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.tableViewEntry attribute:NSLayoutAttributeHeight multiplier:1 constant:0.f];
    

    NSLayoutConstraint *collectionCellViewHeight = [NSLayoutConstraint constraintWithItem:self.collectionCellViewEntry attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.tableViewEntry attribute:NSLayoutAttributeHeight multiplier:1 constant:0.f];
    
    NSLayoutConstraint *scrollViewHeight = [NSLayoutConstraint constraintWithItem:self.scrollViewEntry attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.tableViewEntry attribute:NSLayoutAttributeHeight multiplier:1 constant:0.f];
    
    NSLayoutConstraint *fullScreenHeight = [NSLayoutConstraint constraintWithItem:self.fullScreenAdEntry attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.tableViewEntry attribute:NSLayoutAttributeHeight multiplier:1 constant:0.f];
    
    NSLayoutConstraint* tableViewWidth = [NSLayoutConstraint constraintWithItem:self.tableViewEntry attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0.f];
    tableViewWidth.priority = 999;
    
    NSLayoutConstraint *collectionHeaderViewWidth = [NSLayoutConstraint constraintWithItem:self.collectionHeaderViewEntry attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.tableViewEntry attribute:NSLayoutAttributeWidth multiplier:1 constant:0.f];
    
    NSLayoutConstraint *collectionCellViewWidth = [NSLayoutConstraint constraintWithItem:self.collectionCellViewEntry attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.tableViewEntry attribute:NSLayoutAttributeWidth multiplier:1 constant:0.f];
    
    NSLayoutConstraint *scrollViewWidth = [NSLayoutConstraint constraintWithItem:self.scrollViewEntry attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.tableViewEntry attribute:NSLayoutAttributeWidth multiplier:1 constant:0.f];
    
    NSLayoutConstraint *fullScreenWidth = [NSLayoutConstraint constraintWithItem:self.fullScreenAdEntry attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.tableViewEntry attribute:NSLayoutAttributeWidth multiplier:1 constant:0.f];
    
    [NSLayoutConstraint activateConstraints:@[tableViewHeight, collectionHeaderViewHeight,collectionCellViewHeight, fullScreenHeight, scrollViewHeight,tableViewWidth, collectionHeaderViewWidth, collectionCellViewWidth, scrollViewWidth, fullScreenWidth]];
}

-(void) subviewPositionConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableViewEntry, _collectionHeaderViewEntry, _collectionCellViewEntry,_scrollViewEntry, _fullScreenAdEntry);
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_tableViewEntry]-3-[_collectionHeaderViewEntry]-3-[_collectionCellViewEntry]-3-[_scrollViewEntry]-3-[_fullScreenAdEntry]-8-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_tableViewEntry]-8-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_collectionCellViewEntry]-8-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_collectionHeaderViewEntry]-8-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_scrollViewEntry]-8-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_fullScreenAdEntry]-8-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void) clicked:(id)sender
{
    if(sender == self.tableViewEntry)
    {
        [self performSegueWithIdentifier:sOpenTableViewDemoSegueID sender:nil];
    }
    else if (sender  == self.collectionHeaderViewEntry)
    {
        [self performSegueWithIdentifier:sOpenCollectionViewDemoSegueID sender:nil];
    }
    else if (sender == self.collectionCellViewEntry)
    {
        [self performSegueWithIdentifier:sOpenCollectionCellViewDemoSegueID sender:nil];
    }
    else if (sender == self.scrollViewEntry)
    {
        [self performSegueWithIdentifier:sOpenScrollViewDemoSegueID sender:nil];
    }
    else if (sender == self.fullScreenAdEntry)
    {
        VungleSDK* sdk = [VungleSDK sharedSDK];
        sdk.bannerView = nil;
        sdk.floatingView = nil;
        NSError *error;
        [sdk playAd:self error:&error];
    }
}

-(void) createSubViews
{
    
    UIView *(^subviewCreate)(NSString *subviewName, UIColor* bgColor) = ^(NSString *subviewName, UIColor* bgColor){
        UIFont *font = [UIFont fontWithName:@"Arial" size:30.f];
        UIButton *subView = [[UIButton alloc] initWithFrame:CGRectZero];
        [subView setTitle:subviewName forState:UIControlStateNormal];
        subView.titleLabel.textAlignment = NSTextAlignmentCenter;
        subView.titleLabel.font = font;
        [subView setTranslatesAutoresizingMaskIntoConstraints: NO];
        subView.backgroundColor = bgColor;
        subView.titleLabel.textColor = [UIColor magentaColor];
        subView.layer.cornerRadius = 10;
        [subView addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: subView];
        
        return subView;
    };

    self.tableViewEntry = subviewCreate(@"Table View Demo", [UIColor darkGrayColor]);
    self.collectionHeaderViewEntry = subviewCreate(@"Collection Header Demo" ,[UIColor darkGrayColor]);
    self.collectionCellViewEntry = subviewCreate(@"Collection Cell Demo" ,[UIColor darkGrayColor]);
    self.scrollViewEntry = subviewCreate(@"Scroll View Demo", [UIColor darkGrayColor]);
    self.fullScreenAdEntry = subviewCreate(@"Full Screen Ad", [UIColor darkGrayColor]);
}

@end
