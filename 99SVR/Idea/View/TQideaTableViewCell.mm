//
//  TQideaTableViewCell.m
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQideaTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TQIdeaModel.h"

@interface TQideaTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UILabel *conTentLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;

@end
@implementation TQideaTableViewCell



- (void)setIdeaModel:(TQIdeaModel *)ideaModel
{
    [_conTentLabel setText:ideaModel.content];
    [_authorLabel setText:ideaModel.authorname];
    [_DateLabel setText:ideaModel.publishtime];
    [_commentBtn setTitle:NSStringFromInt(ideaModel.replycount) forState:UIControlStateNormal];
    [_giftBtn setTitle:NSStringFromInt(ideaModel.giftcount) forState:UIControlStateNormal];
    if (ideaModel.authoricon) {
        [_iconView setImage:[UIImage imageNamed:ideaModel.authoricon]];
    }else{
        [_iconView setImage:[UIImage imageNamed:@"default"]];
    }
}

@end
