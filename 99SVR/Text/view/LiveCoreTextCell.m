//
//  LiveCoreTextCell.m
//  99SVR
//
//  Created by xia zhonglin  on 1/10/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "LiveCoreTextCell.h"

@implementation LiveCoreTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _lblTime = [[UILabel alloc] initWithFrame:Rect(5, 5, kScreenWidth-30, 16)];
    [self.contentView addSubview:_lblTime];
    [_lblTime setTextColor:RGB(128, 128, 128)];
    [_lblTime setFont:XCFONT(14)];
    
    _textCoreView = [DTAttributedTextContentView new];
    
    [self.contentView addSubview:_textCoreView];
    
    _textCoreView.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    _btnThum = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.contentView addSubview:_btnThum];
    
    [_btnThum setTitle:@"赞" forState:UIControlStateNormal];
    
//    _line = [[UILabel alloc] init];
//    [self.contentView addSubview:_line];
//    [_line setBackgroundColor:[UIColor grayColor]];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textCoreView.frame = Rect(0, _lblTime.y+_lblTime.height+5, kScreenWidth, self.contentView.height-66);
    _btnThum.frame = Rect(kScreenWidth-120, self.contentView.height-35, 80, 30);
//    _line.frame = Rect(0, self.contentView.height-1,kScreenWidth,0.5);
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
