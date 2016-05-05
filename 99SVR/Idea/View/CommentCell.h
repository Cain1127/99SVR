//
//  CommentCell.h
//  99SVR
//
//  Created by xia zhonglin  on 4/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>

@class ZLReply;

@protocol CommentDelegate <NSObject>

- (void)commentCell:(ZLReply *)Reply;

@end

@interface CommentCell : DTAttributedTextCell

@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) UIButton *btnReply;
@property (nonatomic,strong) UILabel *lblLine;
@property (nonatomic,assign) id<CommentDelegate> delegate;
@property (nonatomic,strong) ZLReply *reply;

- (void)setReplyModel:(ZLReply *)reply;

@end