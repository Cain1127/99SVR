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
    UIImageView *_imageView; // 图片
    UILabel *_nameLabel; // 名称
    UIButton *_lookCountBtn; // 观看人数
    UILabel *_roomIdLabel; // 房间号
    UILabel *_count;
    UIButton *_btnPwd;
}

@end

@implementation VideoCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0,4, frame.size.width,frame.size.height-8);
        [self addSubview:_imageView];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(_imageView.x,_imageView.height+_imageView.y-40, _imageView.width,40)];
        [imgView setImage:[UIImage imageNamed:@"romm_bg"]];
        [self addSubview:imgView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = XCFONT(12);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        
        UIColor *smallFontColor = [UIColor colorWithHex:@"#ffffff"];
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
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews
{
    _nameLabel.frame = Rect(_imageView.x+5,_imageView.height+_imageView.y-20,self.width*0.35,15);
    
    _roomIdLabel.frame = Rect(_nameLabel.x+_nameLabel.width+2,_nameLabel.y,60,15);
    
    [_lookCountBtn setFrame:Rect(_imageView.x+_imageView.width-60,
                            _nameLabel.y,60, 15)];
}

- (void)setRoom:(RoomHttp *)room
{
    _room = room;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_HTTP_URL,room.croompic]] placeholderImage:[UIImage imageNamed:@"default"]];
    _nameLabel.text = room.cname;
    [_lookCountBtn setTitle:room.ncount forState:UIControlStateNormal];
    [_roomIdLabel setText:room.nvcbid];
}

- (void)addGesture:(void (^)(id sender))handler
{
//    if(_btnPwd)
//    {
//        [_btnPwd bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
//    }
}

@end
