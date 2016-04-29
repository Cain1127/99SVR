//
//  TQMessageTableViewCell.m
//  99SVR
//
//  Created by jiangys on 16/4/28.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQMessageTableViewCell.h"

@interface TQMessageTableViewCell()

@property(nonatomic, strong) UIView *bgView;
/** 标题 */
@property(nonatomic, strong) UILabel *titleLabel;
/** 时间 */
@property(nonatomic, strong) UILabel *contentLabel;
/** 内容 */
@property(nonatomic, strong) UILabel *vipLabel;

@end

@implementation TQMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHex:@"#262626"];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
        [self addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithHex:@"#878787"];
        [self addSubview:_contentLabel];
        
        _vipLabel = [[UILabel alloc] init];
        _vipLabel.font = [UIFont systemFontOfSize:15];
        _vipLabel.textColor = [UIColor colorWithHex:@"#878787"];
        [self addSubview:_vipLabel];
    }
    return self;
}

-(void)setMessageModel:(TQMessageModel *)messageModel
{
    //添加头部子控件布局
    _titleLabel.text = messageModel.title;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    _contentLabel.text = messageModel.content;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        
    }];
    
    _vipLabel.text = messageModel.publishtime;
    [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(_contentLabel.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"RFMeReservationTableViewCell";
    TQMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TQMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
@end
