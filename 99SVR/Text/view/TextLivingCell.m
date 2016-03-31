//
//  TextLivingCell.m
//  99SVR
//
//  Created by xia zhonglin  on 1/14/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextLivingCell.h"
#import "UIImageView+WebCache.h"
#import "TextRoomModel.h"
#import "TeacherModel.h"

@interface TextLivingCell()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblContent;
@property (nonatomic,strong) UIButton *btnClick;
@property (nonatomic,strong) UILabel *lblRoomId;

@end

@implementation TextLivingCell

- (void)initCell
{
    _imgView = [[UIImageView alloc] initWithFrame:Rect(8, 10, 45, 45)];
    [self.contentView addSubview:_imgView];
    [_imgView.layer setMasksToBounds:YES];
    _imgView.layer.cornerRadius = 20;
    
    _lblName = [[UILabel alloc] initWithFrame:Rect(_imgView.width+_imgView.x+10, 10, 200,20)];
    [_lblName setTextColor:UIColorFromRGB(0x343434)];
    [self.contentView addSubview:_lblName];
    [_lblName setFont:XCFONT(15)];
    
    _lblContent = [[UILabel alloc] initWithFrame:Rect(_imgView.width+_imgView.x+10,_lblName.y+_lblName.height+5,kScreenWidth-70,20)];
    [self.contentView addSubview:_lblContent];
    [_lblContent setFont:XCFONT(14)];
    [_lblContent setTextColor:UIColorFromRGB(0x7a7a7a)];
    
    _btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_btnClick];
    [_btnClick setTitle:@"0" forState:UIControlStateNormal];
    [_btnClick setImage:[UIImage imageNamed:@"textcount"] forState:UIControlStateNormal];
    [_btnClick setTitleColor:UIColorFromRGB(0xffa926) forState:UIControlStateNormal];
    [self.contentView addSubview:_btnClick];
    _btnClick.frame = Rect(kScreenWidth-80,8,70,30);
    UIEdgeInsets btnInsets = _btnClick.imageEdgeInsets;
    btnInsets.left -= 10;
    _btnClick.imageEdgeInsets = btnInsets;
    
    _lblRoomId = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-130, 8, 50,20)];
    [self.contentView addSubview:_lblRoomId];
    
    [_lblRoomId setFont:XCFONT(15)];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initCell];
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTeacherModel:(TeacherModel*)teacher
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:teacher.strImg]
                placeholderImage:[UIImage imageNamed:@"logo"]];
    _lblName.text = teacher.strName;
    _lblContent.text = teacher.strContent;
}

- (void)setTextRoomModel:(TextRoomModel *)teacher
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kImage_TEXT_URL,teacher.teacherid];
    [_btnClick setTitle:teacher.ncount forState:UIControlStateNormal];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:url]
                placeholderImage:[UIImage imageNamed:@"logo"]];
    [_lblRoomId setText:teacher.nvcbid];
    _lblName.text = teacher.roomname;
    _lblContent.text = teacher.clabel;
}

@end
