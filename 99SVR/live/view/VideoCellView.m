//
//  VedioCellView.m
//  StrechableTableView
//
//  Created by 邹宇彬 on 15/12/16.
//  Copyright © 2015年 邹宇彬. All rights reserved.
//

#import "VideoCellView.h"
#import "RoomHttp.h"
#import "UIControl+BlocksKit.h"
#import "UIImageView+WebCache.h"

@interface VideoCellView()
{
    UIImageView *_imageView;        //!<图片
    UILabel *_nameLabel;            //!<名称
    UIButton *_lookCountBtn;        //!<观看人数
    UILabel *_roomIdLabel;          //!<房间号
    UILabel *_count;
    UIButton *_btnPwd;
    UILabel *_lookCountLabel;       //!<观看次数
}

@end

@implementation VideoCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0,8, frame.size.width,frame.size.height-8);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 2.5;
        [self addSubview:_imageView];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(_imageView.x,_imageView.height+_imageView.y-40, _imageView.width,40)];
        [imgView setImage:[UIImage imageNamed:@"romm_bg"]];
        [self addSubview:imgView];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 2.5;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = XCFONT(12);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        
        UIColor *smallFontColor = [UIColor colorWithHex:@"#919191"];
        _lookCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookCountBtn setTitleColor:smallFontColor forState:UIControlStateNormal];
        _lookCountBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_lookCountBtn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
        [self addSubview:_lookCountBtn];
        
        _roomIdLabel = [[UILabel alloc] init];
        _roomIdLabel.font = [UIFont systemFontOfSize:12];
        _roomIdLabel.textColor = smallFontColor;
        [_roomIdLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_roomIdLabel];
        
        ///观看次数
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews
{
    _nameLabel.frame = Rect(_imageView.x+5,_imageView.height+_imageView.y-40,120,15);
    
    _roomIdLabel.frame = Rect(_nameLabel.x,_imageView.y+_imageView.height-20,80,15);
    
    [_lookCountBtn setFrame:Rect(_imageView.x+_imageView.width-90,_roomIdLabel.y,80, 15)];
}

- (void)setNewRoom:(RoomHttp *)room
{
    _room = room;
    NSString *strUrl=nil;
    if([room.croompic length]==0)
    {
        strUrl = @"";
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@",room.teamicon];
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    [_lookCountBtn setTitle:room.onlineusercount forState:UIControlStateNormal];
//    _nameLabel.text = room.teamname;
    CGRect frame = [room.onlineusercount boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XCFONT(12)} context:nil];
    _lookCountLabel.frame = Rect(_imageView.x+_imageView.width-frame.size.width-16, _nameLabel.y, frame.size.width+8, 15);
    [_roomIdLabel setText:room.roomid];
}

- (void)setRoom:(RoomHttp *)room
{
    _room = room;
    NSString *strUrl=nil;
    if([room.croompic length]==0)
    {
        strUrl = @"";
    }
    else
    {
       strUrl = [NSString stringWithFormat:@"%@%@",kIMAGE_HTTP_URL,room.croompic];
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    _nameLabel.text = room.teamname;
    _lookCountLabel.text = room.onlineusercount;
    [_roomIdLabel setText:room.roomid];
}


@end
