//
//  CircleImageView.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/25.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "CircleImageView.h"

#define kSpace 10

@interface CircleImageView()
{
    UIImageView *_avatarImageView;
}

@end

@implementation CircleImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(59, 97, 166);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = (self.width) / 2;
        self.layer.borderColor = [RGBA(255, 255, 255, 0.13) CGColor];
        self.layer.borderWidth = 1.5;
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = (self.width - 2 * kSpace) / 2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"login_avatar"];
        [self addSubview:_avatarImageView];
    }
    return self;
}

@end
