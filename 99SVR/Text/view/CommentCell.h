//
//  CommentCell.h
//  99SVR
//
//  Created by xia zhonglin  on 3/3/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>
@class IdeaDetailRePly;
@class ZLReply;
@protocol CommentDelegate <NSObject>

- (void)commentCell:(ZLReply *)Reply;

@end

@interface CommentCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) DTAttributedTextContentView *textView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) UIButton *btnReply;
@property (nonatomic,strong) UILabel *lblLine;
@property (nonatomic,assign) id<CommentDelegate> delegate;
@property (nonatomic,strong) ZLReply *reply;

- (void)setModel:(IdeaDetailRePly *)details;
- (void)setReplyModel:(ZLReply *)reply;

@end
