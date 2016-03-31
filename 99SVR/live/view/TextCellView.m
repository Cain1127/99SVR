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
    UIButton *_lookCountBtn; // 观看人数
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
    }
    return self;
}

- (void)setRoom:(TextRoomModel *)room
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kIMAGE_HTTP_URL,room.croompic];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"default"]];
}

- (void)addGesture:(void (^)(id sender))handler
{

}

@end
