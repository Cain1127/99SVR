//
//  TQcontentView.h
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComposeTextView;
@interface TQcontentView : UIView
/** 聊天框 */
@property (nonatomic ,weak)ComposeTextView *textView;

/** 取消 */
@property (nonatomic ,weak)UIButton *sendBtn;

/** 发送评论 */
@property (nonatomic ,weak)UIButton *commentBtn;
@end
