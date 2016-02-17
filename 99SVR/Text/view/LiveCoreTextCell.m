//
//  LiveCoreTextCell.m
//  99SVR
//
//  Created by xia zhonglin  on 1/10/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

//#import "ThumButton.h"
#import "LiveCoreTextCell.h"
#import "ThumButton.h"

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
    _btnThum = [[ThumButton alloc] initWithFrame:Rect(0, -70, 70, 30) size:30 fontSize:14];
    [_btnThum setImage:[UIImage imageNamed:@"thum"] forState:UIControlStateNormal];
    [_btnThum setImage:[UIImage imageNamed:@"thum_h"] forState:UIControlStateHighlighted];
    [_btnThum setTitleColor:UIColorFromRGB(0x7a7a7a) forState:UIControlStateNormal];
    _btnThum.titleLabel.font = XCFONT(14);
    [self.contentView addSubview:_btnThum];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textCoreView.frame = Rect(0, _lblTime.y+_lblTime.height+5, kScreenWidth, self.contentView.height-66);
    _btnThum.frame = Rect(kScreenWidth - 80, self.contentView.height-35,70, 30);
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
