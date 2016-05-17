//
//  ConsumeRankCell.m
//  99SVR
//
//  Created by xia zhonglin  on 4/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ConsumeRankCell.h"

@implementation ConsumeRankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _imgHead = [[UIImageView alloc] initWithFrame:Rect(55, 8, 40, 40)];
    _imgHead.layer.masksToBounds = YES;
    _imgHead.layer.cornerRadius = 20;
    
    _lblName = [[UILabel alloc] initWithFrame:Rect(_imgHead.x+_imgHead.width+8,15,kScreenWidth-80,30)];
    [_lblName setTextColor:UIColorFromRGB(0x343434)];
    [_lblName setFont:XCFONT(14)];
    
    _lblGoid = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-80,_lblName.y,70, 30)];
    [_lblGoid setTextColor:UIColorFromRGB(0x919191)];
    [_lblGoid setFont:XCFONT(14)];
    [_lblGoid setTextAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:_imgHead];
    [self.contentView addSubview:_lblName];
    [self.contentView addSubview:_lblGoid];
     
    _lblBad = [[UILabel alloc] initWithFrame:Rect(8, 10, 40, 30)];
    [_lblBad setTextColor:UIColorFromRGB(0x00)];
    [_lblBad setTextAlignment:NSTextAlignmentCenter];
   
    _imgRank = [[UIImageView alloc] initWithFrame:Rect(8, 8, 40, 40)];
    _imgRank.layer.masksToBounds = YES;
    _imgRank.layer.cornerRadius = 20;
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setRankInfo:(NSInteger)nIndex
{
    [_lblBad removeFromSuperview];
    [_imgRank removeFromSuperview];
    if(nIndex<3)
    {
        [self.contentView addSubview:_imgRank];
        [_lblGoid setTextColor:UIColorFromRGB(0xf8b551)];
    }else{
        [self.contentView addSubview:_lblBad];
        [_lblGoid setTextColor:UIColorFromRGB(0x919191)];
    }
}

@end
