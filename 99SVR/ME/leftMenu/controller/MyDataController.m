//
//  MyDataController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/25.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "MyDataController.h"
#import "UserInfo.h"

#define kImageWidth 107
#define kCircle (kImageWidth + 12)

@implementation TitleItem

- (instancetype)init
{
    if (self = [super init])
    {
        UIColor *textColor = [UIColor whiteColor];
        _nameLabel = [UILabel new];
        _nameLabel.font = XCFONT(14);
        _nameLabel.textColor = UIColorFromRGB(0xbbd0ed);
        _nameLabel.text = @"账号";
        [self addSubview:_nameLabel];
        
        _valueLabel = [UILabel new];
        _valueLabel.font = XCFONT(17);
        _valueLabel.textColor = textColor;
        _valueLabel.text = @"3265702";
        [self addSubview:_valueLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self);
             make.centerX.equalTo(self);
         }];
        
        [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (void)setTitleValue:(int)value
{
    _valueLabel.text = NSStringFromInt(value);
}

@end

@implementation MyDataController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kNavColor;
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
//    [self setLeftBtn:btnBack];
//    [self setLineHidden:YES];
    [self initSubviews];
}

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)initSubviews
{
    UIImageView *imgTemp = [[UIImageView alloc] initWithFrame:Rect(0, 100, kScreenWidth,102)];
    [imgTemp setImage:[UIImage imageNamed:@"left_bg"]];
    [self.view addSubview:imgTemp];
    
    UserInfo *info = [UserInfo sharedUserInfo];
    UIView *circleLine = [UIView new];
    circleLine.layer.masksToBounds = YES;
    circleLine.layer.cornerRadius = (kCircle) / 2;
    circleLine.layer.borderWidth = 0.5;
    circleLine.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    [self.view addSubview:circleLine];
    
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.cornerRadius = kImageWidth / 2;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:avatarImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = kFontSize(15);
    nameLabel.text = NSStringFromInt([UserInfo sharedUserInfo].nUserId);
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:nameLabel];
    
    UIButton *vipLevel = [UIButton buttonWithType:UIButtonTypeCustom];
    vipLevel.titleLabel.textColor = UIColorFromRGB(0xbbd0ed);
    vipLevel.titleLabel.font = kFontSize(12);
    [vipLevel setTitle:[info getVipDescript] forState:UIControlStateNormal];
    vipLevel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:vipLevel];
    
    circleLine.frame = Rect(kScreenWidth/2-kCircle/2, 80, kCircle, kCircle);
    avatarImageView.frame = Rect(circleLine.x+6,circleLine.y+6, kImageWidth, kImageWidth);
    nameLabel.frame = Rect(30, circleLine.height+circleLine.y+19, kScreenWidth-60, 20);
    vipLevel.frame = Rect(30, nameLabel.height+nameLabel.y, kScreenWidth-60, 20);
    
    TitleItem *accountItem = [[TitleItem alloc] init];
    accountItem.nameLabel.text = @"账号";
    accountItem.valueLabel.text = [NSString stringWithFormat:@"%d",[UserInfo sharedUserInfo].nUserId];
    
    TitleItem *cardItem = [[TitleItem alloc] init];
    cardItem.nameLabel.text = @"金币";
    cardItem.valueLabel.text = NSStringFromFloat(info.goldCoin);
    
    TitleItem *scoreItem = [[TitleItem alloc] init];
    scoreItem.nameLabel.text = @"积分";
    scoreItem.valueLabel.text = NSStringFromLong(info.score);
    
    [self.view addSubview:accountItem];
    [self.view addSubview:cardItem];
    [self.view addSubview:scoreItem];
    
    CGFloat itemHeight = 50;
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithHex:@"#ffffff" alpha:0.7];
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithHex:@"#ffffff" alpha:0.7];
    [self.view addSubview:line2];
    
    [accountItem mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.size.mas_equalTo(CGSizeMake(self.view.width / 3, 50));
         make.left.equalTo(self.view);
         make.top.mas_equalTo(vipLevel.mas_bottom).offset(36);
     }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5, itemHeight));
        make.left.mas_equalTo(accountItem.mas_right);
        make.top.equalTo(accountItem);
    }];
    [cardItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.width / 3, 50));
        make.left.mas_equalTo(line1.mas_right);
        make.top.equalTo(line1);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5, itemHeight));
        make.left.mas_equalTo(cardItem.mas_right);
        make.top.equalTo(cardItem);
    }];
    [scoreItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.width / 3, 50));
        make.left.mas_equalTo(line2.mas_right);
        make.top.equalTo(line2);
    }];
}

@end
