//
//  LiveCoreTextCell.h
//  99SVR
//
//  Created by xia zhonglin  on 1/10/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCoreText.h"

@class LiveCoreTextCell;
@class TextLiveModel;

@protocol ThumCellDelagate <NSObject>

- (void)liveCore:(LiveCoreTextCell *)liveCore msgid:(int64_t)messageid;

@end

@interface LiveCoreTextCell : UITableViewCell

@property (nonatomic,strong) DTAttributedTextContentView *textCoreView;
@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) UIButton *btnThum;
@property (nonatomic,strong) UILabel *line;
@property (nonatomic) int64_t messageid;
@property (nonatomic,assign) id<ThumCellDelagate> delegate;
@property (nonatomic) NSInteger section;
@property (nonatomic) int64_t viewid;

//- (void)hiddenThum;

- (void)setTextModel:(TextLiveModel *)model;




@end
