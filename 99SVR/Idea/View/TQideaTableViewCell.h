//
//  TQideaTableViewCell.h
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>
@class TQIdeaModel;
@class ZLViewPoint;
@interface TQIdeaTableViewCell : DTAttributedTextCell

/** 模型 */
//@property (nonatomic ,weak) TQIdeaModel *ideaModel;
@property (nonatomic,copy) NSString *content;
- (void)setIdeaModel:(TQIdeaModel *)ideaModel;

@end
