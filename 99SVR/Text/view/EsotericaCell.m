//
//  EsotericaCell.m
//  99SVR
//
//  Created by xia zhonglin  on 3/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "EsotericaCell.h"
#import "UIImageView+WebCache.h"
#import "TextEsoterModel.h"

@implementation EsotericaCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _lblTitle = [[UILabel alloc] initWithFrame:Rect(8, 8, kScreenWidth-16, 20)];
    [_lblTitle setFont:XCFONT(15)];
    [self.contentView addSubview:_lblTitle];
    
    _imgView = [[UIImageView alloc] initWithFrame:Rect(_lblTitle.x, _lblTitle.y+_lblTitle.height,100,75)];
    [self.contentView addSubview:_imgView];
    
    _lblContent = [[UILabel alloc] initWithFrame:Rect(_imgView.x+_imgView.width+8,_imgView.y,kScreenWidth-(_imgView.x+_imgView.width+16), 75)];
    _lblContent.numberOfLines = 0;
    [_lblContent setFont:XCFONT(15)];
    [self.contentView addSubview:_lblContent];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:Rect(0,_imgView.y+_imgView.height+8,kScreenWidth,0.5)];
    [self.contentView addSubview:line1];
    [line1 setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    
    _lblTime = [[UILabel alloc] initWithFrame:Rect(_lblTitle.x,line1.y, 108, 46)];
    [_lblTime setFont:XCFONT(13)];
    [self.contentView addSubview:_lblTime];
    [_lblTime setTextColor:UIColorFromRGB(0x919191)];
    
    _btnPrice = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnPrice.frame =  Rect(_lblTime.x+_lblTime.width+8, line1.y, 108,46);
    _btnPrice.titleLabel.font = XCFONT(13);
    [self.contentView addSubview:_btnPrice];
    [_btnPrice setTitleColor:UIColorFromRGB(0x4c4c4c) forState:UIControlStateNormal];
    [_btnPrice setImage:[UIImage imageNamed:@"text_tips_monney_icon"] forState:UIControlStateNormal];
    
    _btnOper = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_btnOper];
    [_btnOper setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _btnOper.frame = Rect(kScreenWidth-120,line1.y, 120,46);
    _btnOper.titleLabel.font = XCFONT(15);
    _insets = _btnOper.titleEdgeInsets;

    
    UILabel *line2 = [[UILabel alloc] initWithFrame:Rect(0,line1.y+46,kScreenWidth,0.5)];
    [self.contentView addSubview:line2];
    [line2 setBackgroundColor:UIColorFromRGB(0xE5E5E5)];
    
    _lblInfo = [[UILabel alloc] initWithFrame:Rect(0,23, 120, 15)];
    [_lblInfo setTextColor:UIColorFromRGB(0xffffff)];
    [_lblInfo setFont:XCFONT(12)];
    _lblInfo.hidden = YES;
    [_btnOper addSubview:_lblInfo];
    return self;
}

- (void)setTextModel:(TextEsoterModel *)textModel
{
    _textModel = textModel;
    _lblTitle.text = _textModel.title;
    [_btnPrice setTitle:NSStringFromInt(_textModel.prices) forState:UIControlStateNormal];
    _lblContent.text = _textModel.content;
    [_imgView setImage:[UIImage imageNamed:@"logo"]];
    [_lblTime setText:textModel.strTime];
    if(_textModel.buyflag)
    {
        [_btnOper setTitle:@"查看" forState:UIControlStateNormal];
        [_btnOper setBackgroundColor:UIColorFromRGB(0x0078dd)];
        _btnOper.titleEdgeInsets = _insets;
    }
    else
    {
        [_btnOper setTitle:@"购买" forState:UIControlStateNormal];
        [_btnOper setBackgroundColor:UIColorFromRGB(0xFF7A1E)];
        UILabel *lblInfo = [[UILabel alloc] initWithFrame:Rect(0,23, 120, 15)];
        [lblInfo setTextColor:UIColorFromRGB(0xffffff)];
        [lblInfo setFont:XCFONT(12)];
        char cBuffer[50]={0};
        sprintf(cBuffer,"(%d人购买)",_textModel.buynums);
        
        _lblInfo.hidden = NO;
        [_lblInfo setText:[NSString stringWithUTF8String:cBuffer]];
        [_lblInfo setTextAlignment:NSTextAlignmentCenter];
        UIEdgeInsets insets = _insets;
        insets.top -=10;
        _btnOper.titleEdgeInsets = insets;
    }
}

@end
