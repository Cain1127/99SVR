//
//  MarchLiveTextCell.h
//  99SVR
//
//  Created by xia zhonglin  on 3/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//
#import <DTCoreText/DTCoreText.h>
@class MarchLiveTextCell;
@class TextLiveModel;

@protocol MarchLiveTextDelegate <NSObject>

- (void)textLive:(MarchLiveTextCell *)liveCore msgid:(int64_t)messageid;

@end

@interface MarchLiveTextCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) UIButton *btnThum;
@property (nonatomic,strong) UILabel *line;
@property (nonatomic) int64_t messageid;
@property (nonatomic,assign) id<MarchLiveTextDelegate> delegate;
@property (nonatomic) NSInteger section;
@property (nonatomic) int64_t viewid;
@property (nonatomic,copy) NSString *strInfo;
@property (nonatomic,strong) DTAttributedTextView *textView;
- (void)setTextModel:(TextLiveModel *)model;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
