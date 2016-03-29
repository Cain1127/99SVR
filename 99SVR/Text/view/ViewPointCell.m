//
//  ViewPointCell.m
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "ViewPointCell.h"

#import "WonderfullView.h"

@interface ViewPointCell ()

@property (nonatomic, assign) CGFloat defaultMaxWidth;      //!<默认的标题最大宽度

@property (nonatomic, strong) UILabel *titleLabel;          //!<标题
@property (nonatomic, strong) UILabel *teacherNameLabel;    //!<观点发表讲师
@property (nonatomic, strong) UILabel *dateLabel;           //!<观点发表日期
@property (nonatomic, strong) UIImageView *readImageView;   //!<点赞图标
@property (nonatomic, strong) UILabel *readAccountLabel;    //!<点赞数量

@end

@implementation ViewPointCell

#pragma mark -
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        ///init default size
        self.defaultMaxWidth = kScreenWidth - 30.0f;
        
        ///create default UI
        [self initViewPointCustomCellUI];
        
    }
    
    return self;

}

#pragma mark -
#pragma mark - create viewPoint custom UI
- (void)initViewPointCustomCellUI
{
    
    ///底view
    UIView *rootView = [[UIView alloc] initWithFrame:Rect(0.0f, 0.0f, self.defaultMaxWidth, 100.0f)];
    [self.contentView addSubview:rootView];

    ///标题信息:WithFrame:Rect(0.0f, 20.0f, self.defaultMaxWidth, 32.0f)
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.textColor = UIColorFromRGB(0x4C4C4C);
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:self.titleLabel];
    
    ///讲师名字:WithFrame:Rect(0.0f, CGRectGetMaxY(self.titleLabel.frame) + CGRectGetHeight(self.titleLabel.frame) + 12.0f, 60.0f, 16.0f)
    self.teacherNameLabel = [[UILabel alloc] init];
    self.teacherNameLabel.font = XCFONT(10);
    self.teacherNameLabel.textColor = UIColorFromRGB(0x919191);
    self.teacherNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:self.teacherNameLabel];
    
    ///日期信息:WithFrame:Rect(CGRectGetWidth(self.teacherNameLabel.frame) + 10.0f, CGRectGetMaxY(self.teacherNameLabel.frame), 100.0f, CGRectGetHeight(self.teacherNameLabel.frame))
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = XCFONT(10.0f);
    self.dateLabel.textColor = UIColorFromRGB(0x919191);
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:self.dateLabel];
    
    ///观看提示图片
    self.readImageView = [[UIImageView alloc] init];
    self.readImageView.image = [UIImage imageNamed:@"home_viewpoint_indicator"];
    self.readImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:self.readImageView];
    
    ///观看次数
    self.readAccountLabel = [[UILabel alloc] init];
    self.readAccountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.readAccountLabel.font = XCFONT(10);
    self.readAccountLabel.textColor = UIColorFromRGB(0x919191);
    [rootView addSubview:self.readAccountLabel];
    
    ///控件字典
    NSDictionary *___viewDictionary = NSDictionaryOfVariableBindings(_titleLabel, _teacherNameLabel, _dateLabel, _readImageView, _readAccountLabel);
    
    ///约束描述
    NSString *___titleLabelHorizal = @"H:|-0-[_titleLabel]-0-|";
    NSString *___titleAndTeacherVertical = @"V:|-20-[_titleLabel]-12-[_teacherNameLabel]-20-|";
    NSString *___titleToReadAccountHorizal = @"H:|-0-[_teacherNameLabel]-10-[_dateLabel]-(>=1)-[_readImageView]-8-[_readAccountLabel]-0-|";
    
    ///生成结束
    NSArray *___titleLabelHorizalArray = [NSLayoutConstraint constraintsWithVisualFormat:___titleLabelHorizal options:NSLayoutFormatAlignAllLeft metrics:nil views:___viewDictionary];
    NSArray *___titleAndTeacherVerticalArray = [NSLayoutConstraint constraintsWithVisualFormat:___titleAndTeacherVertical options:NSLayoutFormatAlignAllLeft metrics:nil views:___viewDictionary];
    NSArray *___titleToReadAccountHorizalArray = [NSLayoutConstraint constraintsWithVisualFormat:___titleToReadAccountHorizal options:NSLayoutFormatAlignAllBottom metrics:nil views:___viewDictionary];
    
    ///添加约束
    [rootView addConstraints:___titleLabelHorizalArray];
    [rootView addConstraints:___titleAndTeacherVerticalArray];
    [rootView addConstraints:___titleToReadAccountHorizalArray];
    
    ///分隔线
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(0.0f, CGRectGetHeight(rootView.frame) - 0.5f, CGRectGetWidth(rootView.frame), 0.5f)];
    [line setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
    [rootView addSubview:line];

}

#pragma mark -
#pragma mark - Refresh viewPoint custom cell with dataModel
/**
 *  @author             yangshengmeng, 16-03-29 13:03:33
 *
 *  @brief              根据给定的精彩观点刷新观点cellUI，展现给定的信息
 *
 *  @param dataModel    精彩视点的数据模型
 *
 *  @since              v1.0.0
 */
- (void)setViewPointModel:(WonderfullView *)dataModel
{

    self.titleLabel.text = 0 < dataModel.title.length ? dataModel.title : nil;
    self.teacherNameLabel.text = 0 < dataModel.calias.length ? dataModel.calias : nil;
    self.dateLabel.text = 0 < dataModel.dtime.length ? dataModel.dtime : nil;
    self.readAccountLabel.text = NSStringFromInteger(0 < dataModel.czans ? dataModel.czans : 0);

}

@end
