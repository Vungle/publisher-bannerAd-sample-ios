//
//  InnerAdTableViewCell.m
//  BannerSampleApp
//
//  Created by JiaYining on 10/2/15.
//  Copyright © 2015 Vungle. All rights reserved.
//

#import "InnerAdTableViewCell.h"

@interface InnerAdTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *adDescription;


@end

@implementation InnerAdTableViewCell

-(void) setCellInfo:(NSDictionary *)cellInfo
{
    _cellInfo = cellInfo;
    _icon.image = [UIImage imageNamed:[_cellInfo objectForKey:@"imagePath"]];
    _title.text = [_cellInfo objectForKey:@"title"];
    _adDescription.text = [_cellInfo objectForKey:@"description"];
    
}

@end
