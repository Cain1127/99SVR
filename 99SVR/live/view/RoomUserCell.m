//
//  RoomUserCell.m
//  99SVR
//
//  Created by xia zhonglin  on 12/23/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomUserCell.h"
#import "RoomUser.h"
#import "UIImageView+WebCache.h"

@interface RoomUserCell()
{
    UIImageView *imgView;
    UIImageView *imgViewPic;
    UILabel *lblName;
    UILabel *lblContent;
    UILabel *lblLine;
    UIImageView *imgMicView;
}

@end

@implementation RoomUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    imgView = [[UIImageView alloc] initWithFrame:Rect(kScreenWidth-25, 10, 17, 17)];
    
    imgViewPic = [[UIImageView alloc] initWithFrame:Rect(10, 10, 40, 40)];
    imgViewPic.layer.masksToBounds = YES;
    imgViewPic.layer.cornerRadius = 20;
    
    lblName = [[UILabel alloc] initWithFrame:Rect(imgViewPic.x+imgViewPic.width+8,10,kScreenWidth-80,40)];
    [lblName setTextColor:UIColorFromRGB(0x343434)];
    [lblName setFont:XCFONT(14)];

    [self.contentView addSubview:lblName];
    [self.contentView addSubview:imgViewPic];
    [self.contentView addSubview:imgView];
    
    imgMicView = [[UIImageView alloc] initWithFrame:Rect(kScreenWidth-50, 10, 17, 17)];
    [self.contentView addSubview:imgMicView];
    
    lblLine = [[UILabel alloc] initWithFrame:Rect(10, 59, kScreenWidth-10, 0.5)];
    [self.contentView addSubview:lblLine];
    [lblLine setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    lblLine.frame = Rect(10, 59,kScreenWidth-10,0.5);
}

- (void)setRoomUser:(RoomUser *)user
{
    int nLevel = [user GetRoomMgrLevel];
    NSString *strMsg = nil;
    switch (nLevel) {
        case 200:
            strMsg =@"mic";
            break;
        case 190:
            strMsg = @"zhuan";
            break;
        case 180:
            strMsg = @"fang";
            break;
        case 21://-区长
            strMsg = @"guan";
            break;
        case 0:
            strMsg = @"";
            break;
        default:
            strMsg = @"guan";
            break;
    }
    [imgView setImage:[UIImage imageNamed:strMsg]];
    
    [imgMicView removeFromSuperview];
    
    if ([user isOnMic]) {
        [imgMicView setImage:[UIImage imageNamed:@"mic"]];
        [self.contentView addSubview:imgMicView];
    }
    
    char cBuffer[100]={0};
    sprintf(cBuffer,"%d_1",user.m_nHeadId);
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [imgViewPic sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"defaultHead_1"]];
   
    [lblName setText:[NSString stringWithFormat:@"%@ (%d)",user.m_strUserAlias,user.m_nUserId]];
    [lblContent setText:@"这个家伙很懒，什么都没写"];
}

@end
