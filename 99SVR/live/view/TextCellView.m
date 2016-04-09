//
//  TextCellView.m
//  99SVR
//
//  Created by xia zhonglin  on 3/31/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextCellView.h"
#import "TextRoomModel.h"
#import "UIControl+BlocksKit.h"
#import "UIImageView+WebCache.h"

@interface TextCellView()
{
    UIImageView *_imageView; // 图片
    UILabel *_nameLabel; // 名称
    UILabel *_lookCountLabel; // 观看人数
    UILabel *_roomIdLabel; // 房间号
    UILabel *_count;
    UIButton *_btnPwd;
}

@end

@implementation TextCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0,4, frame.size.width,frame.size.height-8);
        [self addSubview:_imageView];
        [_imageView setImage:[UIImage imageNamed:@"default"]];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(_imageView.x,_imageView.height+_imageView.y-40, _imageView.width,40)];
        [imgView setImage:[UIImage imageNamed:@"romm_bg"]];
        [self addSubview:imgView];
        
        _roomIdLabel = [[UILabel alloc] init];
        _roomIdLabel.font = [UIFont systemFontOfSize:12];
        _roomIdLabel.textColor = UIColorFromRGB(0xffffff);
        [_roomIdLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_roomIdLabel];
        
        UIImageView *imgCount = [UIImageView new];
        [imgCount setImage:[UIImage imageNamed:@"eye"]];
        [self addSubview:imgCount];
        imgCount.contentMode = UIViewContentModeScaleAspectFit;
        //人气
        _lookCountLabel = [[UILabel alloc] init];
        _lookCountLabel.font = [UIFont systemFontOfSize:12];
        _lookCountLabel.textColor = UIColorFromRGB(0x919191);
        [_lookCountLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_lookCountLabel];
        
        [_roomIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.mas_left).offset(8);
            make.top.equalTo(imgView.mas_top).offset(3);
            make.width.equalTo(@(60));
        }];
        
        [_roomIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.mas_left).offset(8);
            make.top.equalTo(imgView.mas_top).offset(3);
            make.width.equalTo(@(60));
        }];
        [_lookCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_imageView.mas_right).offset(8);
            make.top.equalTo(imgView.mas_top).offset(8);
            make.width.equalTo(@(60));
        }];
       [imgCount mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(_lookCountLabel.mas_left).offset(5);
           make.top.equalTo(_lookCountLabel.mas_top);
       }];
        
        
    }
    return self;
}

- (void)setRoom:(TextRoomModel *)room
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kIMAGE_HTTP_URL,room.croompic];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    _roomIdLabel.text = room.nvcbid;
    _lookCountLabel.text = room.ncount;
}

- (void)addGesture:(void (^)(id sender))handler
{

}

@end
