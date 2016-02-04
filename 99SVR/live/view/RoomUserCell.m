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
    UILabel *lblNumber;
    
}

@end

@implementation RoomUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    imgView = [[UIImageView alloc] initWithFrame:Rect(10, 10, 17, 17)];
    
    imgViewPic = [[UIImageView alloc] initWithFrame:Rect(imgView.x+imgView.width+10, imgView.y, 20, 20)];
    
    lblName = [[UILabel alloc] initWithFrame:Rect(imgViewPic.x+imgViewPic.width+10, imgViewPic.y,150, 20)];
    
    [lblName setTextColor:UIColorFromRGB(0x000000)];
    
    lblNumber = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-100, imgViewPic.y, 90, 20)];
    
    [self.contentView addSubview:lblNumber];
    [self.contentView addSubview:lblName];
    [self.contentView addSubview:imgViewPic];
    [self.contentView addSubview:imgView];
    
    [lblNumber setTextAlignment:NSTextAlignmentRight];
    
    [lblNumber setFont:XCFONT(14)];
    [lblName setFont:XCFONT(14)];
    
    return self;
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
            strMsg = @"putong";
            break;
        default:
            strMsg = @"guan";
            break;
    }
    [imgView setImage:[UIImage imageNamed:strMsg]];
    
    UIImage *image = [UIImage imageNamed:NSStringFromInt(user.m_nHeadId)];
    if (image)
    {
        [imgViewPic setImage:image];
    }
    else
    {
        [imgViewPic setImage:[UIImage imageNamed:@"defaultHead"]];
    }
    
    [lblName setText:user.m_strUserAlias];
    [lblNumber setText:[NSString stringWithFormat:@"%d",user.m_nUserId]];
    
}

@end
