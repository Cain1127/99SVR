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

@end

@implementation TextLivingCell

- (void)initCell
{
    _imgView = [[UIImageView alloc] initWithFrame:Rect(8, 10, 40, 40)];
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
    
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(8,59, kScreenWidth-16, 0.5)];
    [self.contentView addSubview:line];
    [line setBackgroundColor:kLineColor];
    
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
    [_imgView sd_setImageWithURL:[NSURL URLWithString:teacher.roomPic]
                placeholderImage:[UIImage imageNamed:@"logo"]];
    _lblName.text = teacher.roomName;
    _lblContent.text = teacher.rid;
}

@end
