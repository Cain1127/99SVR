//
//  MailboxTableViewCell.m
//  99SVR
//
//  Created by Jiangys on 16/5/3.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "MailboxTableViewCell.h"
#import "MailboxModel.h"

@interface MailboxTableViewCell()
@property(nonatomic, strong) UIView *bgView;
/** 图标 */
@property(nonatomic, strong) UIImageView *iconImageView;
/** 标题 */
@property(nonatomic, strong) UILabel *titleLabel;
/** 未读数 */
@property(nonatomic, strong) UIImageView *unreadimageView ;

@end

@implementation MailboxTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        lineView.backgroundColor = COLOR_Bg_Gay;
        [self.contentView addSubview:lineView];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 77)];
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = COLOR_Line_Small_Gay.CGColor;
        [self.contentView addSubview:_bgView];
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bgView  addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font_16;
        [_bgView  addSubview:_titleLabel];
        
        _unreadimageView = [[UIImageView alloc] init];
        _unreadimageView.layer.masksToBounds = YES;
        _unreadimageView.layer.cornerRadius = 4;
        [_bgView  addSubview:_unreadimageView];
    }
    return self;
}

-(void)setMailboxModel:(MailboxModel *)mailboxModel
{
    CGFloat H = 77;
    
    _iconImageView.frame = CGRectMake(12, 0, 40, H);
    _iconImageView.image = [UIImage imageNamed:mailboxModel.icon];
    
    CGSize titleSize = [mailboxModel.title sizeMakeWithFont:_titleLabel.font];
    _titleLabel.frame = CGRectMake(60, 0, titleSize.width, H);
    _titleLabel.text = mailboxModel.title;
    
    _unreadimageView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame), 25, 8, 8);
    _unreadimageView.image = [self imageWithColor:[UIColor redColor]];
    
    if(mailboxModel.unreadCount > 0)
    {
        _unreadimageView.hidden = NO;
    } else {
        _unreadimageView.hidden = YES;
    }
}

- (UIImage * _Nonnull)imageWithColor:(UIColor * _Nonnull)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MailboxTableViewCell";
    MailboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MailboxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
@end

