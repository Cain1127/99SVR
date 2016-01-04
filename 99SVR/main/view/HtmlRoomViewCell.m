//
//  HtmlRoomViewCell.m
//  99SVR
//
//  Created by xia zhonglin  on 12/11/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "HtmlRoomViewCell.h"
#import "HtmlRoom.h"
#import "UIImageView+WebCache.h"

@interface HtmlRoomViewCell()
{
    
}

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblRoomId;

@end



@implementation HtmlRoomViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _imgView = [[UIImageView alloc] initWithFrame:Rect(5, 5, 100,80)];
    
    [self.contentView addSubview:_imgView];
    
    _lblName = [[UILabel alloc] initWithFrame:Rect(_imgView.x+_imgView.width+10, 5, kScreenWidth-90, 20)];
    
    [_lblName setFont:XCFONT(15)];
    
    [self.contentView addSubview:_lblName];
    
    _lblRoomId = [[UILabel alloc] initWithFrame:Rect(_lblName.x, 40, _lblName.width, 20)];
    
    [_lblRoomId setFont:XCFONT(13)];
    
    [self.contentView addSubview:_lblRoomId];
    
    return self;
}

- (void)setCellInfo:(HtmlRoom *)room
{
    _lblName.text = room.strRoomName;
    _lblRoomId.text = room.strRoomId;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:room.strUrl]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
