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
@interface CommentCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) DTAttributedTextContentView *textView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) UIButton *btnReply;
@property (nonatomic,strong) UILabel *lblLine;

- (void)setModel:(IdeaDetailRePly *)details;

@end
