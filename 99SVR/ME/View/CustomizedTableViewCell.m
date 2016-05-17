//
//  CustomizedTableViewCell.m
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 jiangys. All rights reserved.
//  私有定制Cell

#import "CustomizedTableViewCell.h"
#import "CustomizedModel.h"

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
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        /** 标题 */
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = XCFONT(13);
        _titleLable.textColor = UIColorFromRGB(0x919191);
        [self addSubview:_titleLable];
        
        /** 时间 */
        _timeLable = [[UILabel alloc] init];
        _timeLable.font = XCFONT(12);
        _timeLable.textColor = UIColorFromRGB(0x919191);
        [self addSubview:_timeLable];
        
        /** 内容 */
        _contentLable = [[UILabel alloc] init];
        _contentLable.font = XCFONT(13);
        _contentLable.numberOfLines = 0;
        _contentLable.textColor = UIColorFromRGB(0x919191);
        [self addSubview:_contentLable];
    }
    return self;
}

- (void)setCustomizedModel:(CustomizedModel *)customizedModel
{
    _customizedModel = customizedModel;
    CGFloat padding = 12;
    
    /** 标题 */
    _titleLable.text = customizedModel.title;
    _titleLable.frame = CGRectMake(padding, 10, kScreenWidth - 2*padding, 20);
    
    /** 时间 */
    _timeLable.text = customizedModel.publishTime;
    _timeLable.frame = CGRectMake(padding, CGRectGetMaxY(_titleLable.frame), kScreenWidth - 2*padding, 20);
    
    /** 内容 */
    _contentLable.text = customizedModel.summary;
    _contentLable.frame = CGRectMake(padding, CGRectGetMaxY(_timeLable.frame), kScreenWidth - 2*padding,20);
    
    if(customizedModel.isOpen)
    {
        self.userInteractionEnabled = YES;
        _titleLable.textColor = COLOR_Text_Black;
        _timeLable.textColor = COLOR_Text_Black;
        _contentLable.textColor = COLOR_Text_Black;
    } else {
        self.userInteractionEnabled = NO;
        _titleLable.textColor = COLOR_Text_Gay;
        _timeLable.textColor = COLOR_Text_Gay;
        _contentLable.textColor = COLOR_Text_Gay;
    }
}

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
