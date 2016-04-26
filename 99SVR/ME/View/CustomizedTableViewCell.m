//
//  CustomizedTableViewCell.m
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 jiangys. All rights reserved.
//  私有定制Cell

#import "CustomizedTableViewCell.h"

@interface CustomizedTableViewCell()

@property(nonatomic, strong) UIView *bgView;
/** 标题 */
@property(nonatomic, strong) UILabel *titleLable;
/** 时间 */
@property(nonatomic, strong) UILabel *timeLable;
/** 内容 */
@property(nonatomic, strong) UILabel *contentLable;

@end

@implementation CustomizedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        /** 标题 */
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = XCFONT(13);
        _titleLable.textColor = UIColorFromRGB(0x919191);
        [self addSubview:_titleLable];
        
        /** 时间 */
        _timeLable = [[UILabel alloc] init];
        _timeLable.font = XCFONT(13);
        _timeLable.textColor = UIColorFromRGB(0x919191);
        [self addSubview:_timeLable];
        
        /** 内容 */
        _contentLable = [[UILabel alloc] init];
        _contentLable.font = XCFONT(13);
        _contentLable.textColor = UIColorFromRGB(0x919191);
        [self addSubview:_contentLable];
    }
    return self;
}

//-(void)setHouseReservationModel:(RFHouseReservationModel *)houseReservationModel
//{
//
//    self.bgView.frame = CGRectMake(0, 0, RFSCREEN_W, 150);
//}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"RFMeReservationTableViewCell";
    CustomizedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CustomizedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

@end
