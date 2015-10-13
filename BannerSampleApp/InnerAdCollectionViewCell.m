//
//  InnerAdCollectionViewCell.m
//  BannerSampleApp
//
//  Created by JiaYining on 10/3/15.
//  Copyright © 2015 Vungle. All rights reserved.
//

#import "InnerAdCollectionViewCell.h"

@interface InnerAdCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation InnerAdCollectionViewCell

-(void) setCellInfo:(NSDictionary *)cellInfo
{
    _cellInfo = cellInfo;
    _imageView.image = [UIImage imageNamed:[_cellInfo objectForKey:@"imagePath"]];
    _title.text = [_cellInfo objectForKey:@"title"];
    
}

@end
