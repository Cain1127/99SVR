//
//  ZLRoomVideoView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLRoomVideoView.h"
#import "XVideoTeamInfo.h"

@interface ZLRoomVideoView()
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

@implementation ZLRoomVideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0,4, frame.size.width,frame.size.height-8);
        [self addSubview:_imageView];
        
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(_imageView.x,_imageView.height+_imageView.y-40, _imageView.width,40)];
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        imgView.clipsToBounds = YES;
//        [self addSubview:imgView];
        
        UIImageView *videoBgImageView = [[UIImageView alloc] init];
        videoBgImageView.frame = _imageView.frame;
        videoBgImageView.contentMode = UIViewContentModeScaleToFill;
        videoBgImageView.image = [UIImage imageNamed:@"video_bg"];
        [self addSubview:videoBgImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = XCFONT(12);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        
//        UIColor *smallFontColor = [UIColor colorWithHex:@"#919191"];
//        _lookCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_lookCountBtn setTitleColor:smallFontColor forState:UIControlStateNormal];
//        _lookCountBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_lookCountBtn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
//        [self addSubview:_lookCountBtn];
//        
//        _roomIdLabel = [[UILabel alloc] init];
//        _roomIdLabel.font = [UIFont systemFontOfSize:12];
//        _roomIdLabel.textColor = smallFontColor;
//        [_roomIdLabel setTextAlignment:NSTextAlignmentLeft];
//        [self addSubview:_roomIdLabel];
//        
//        ///观看次数
//        _lookCountLabel = [[UILabel alloc] init];
//        _lookCountLabel.font = [UIFont systemFontOfSize:12];
//        _lookCountLabel.textColor = smallFontColor;
//        [_lookCountLabel setTextAlignment:NSTextAlignmentLeft];
//        [self addSubview:_lookCountLabel];
        
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews
{
    _nameLabel.frame = Rect(_imageView.x+5,_imageView.height+_imageView.y-20,self.width*0.90,15);
    
//    _roomIdLabel.frame = Rect(_nameLabel.x+_nameLabel.width+2,_nameLabel.y,60,15);
//    
//    [_lookCountBtn setFrame:Rect(_imageView.x+_imageView.width-55,
//                                 _nameLabel.y,20, 15)];
//    _lookCountLabel.frame = Rect(_lookCountBtn.x+_lookCountBtn.width+1, _nameLabel.y, 33, 15);
}

- (void)setVideoModel:(XVideoModel *)videoModel
{
    _videoModel = videoModel;
    NSString *strUrl=nil;
    if([_videoModel.picurl length]==0)
    {
        strUrl = @"";
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@",_videoModel.picurl];
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"video_profiles_curriculum_default_img"]];
    _nameLabel.text = _videoModel.name;
    
}


@end
