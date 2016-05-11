//
//  PrivateVipView.m
//  99SVR_UI
//
//  Created by jiangys on 16/4/26.
//  Copyright © 2016年 Jiangys. All rights reserved.
//

#import "PrivateVipView.h"
#import "DecodeJson.h"

@interface PrivateVipView ()
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation PrivateVipView

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)setPrivateVipArray:(NSArray *)privateVipArray
{
//    [privateVipArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    @WeakObj(self)
    _privateVipArray = privateVipArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        @StrongObj(self)
        int i = 1;
        for (NSDictionary *obj in self.privateVipArray) {
            BOOL isOpen = [obj[@"isOpen"] isEqualToString:@"1"]?true:false;
            [self addSubview:[self createAttrViewWithVipLevelId:obj[@"vipLevelId"] isOpen:isOpen viewCount:i]];
            i++;
        }
   });
//    }];
}

/**
 * 创建Vip按钮
 */
- (UIButton *)createAttrViewWithVipLevelId:(NSString *)vipLevelId
                                    isOpen:(BOOL)isOpen
                                viewCount:(NSInteger)viewCount
{
    NSUInteger column = 3; // 平分3列
    CGFloat viewH = 50;
    CGFloat viewW = kScreenWidth / column;
    CGFloat viewX = (viewCount - 1)%column * viewW;
    CGFloat viewY = (viewCount - 1)/column * viewH;
    
    UIButton *attrDescButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attrDescButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    attrDescButton.frame = CGRectMake(0, 0, viewW, viewH);
    attrDescButton.backgroundColor = [UIColor whiteColor];
    attrDescButton.tag = viewCount;
    [attrDescButton addTarget:self action:@selector(attrDescClick:) forControlEvents:UIControlEventTouchUpInside];
    attrDescButton.frame = CGRectMake(viewX, viewY, viewW, viewH);
    
    // 图标
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 30, 30)];
//    iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"customized_vip%@_icon",vipLevelId]];
    iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"customized_vip%zi_icon",viewCount]];
    [attrDescButton addSubview:iconImageView];
    
    // VIP
    UILabel *attrValueLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+8, 5, 80, 25)];
    attrValueLable.textColor = COLOR_Text_Black;
//    attrValueLable.text = [NSString stringWithFormat:@"VIP%@",vipLevelId];
    attrValueLable.text = [NSString stringWithFormat:@"VIP%zi",viewCount];
    attrValueLable.font = XCFONT(14);
    [attrDescButton addSubview:attrValueLable];
    
    // 购买状态
    UILabel *buyStatusLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+8, 23, 80, 25)];
    buyStatusLable.font = XCFONT(14);
    [attrDescButton addSubview:buyStatusLable];
    if (isOpen) {
        buyStatusLable.text = @"已兑换";
        buyStatusLable.textColor = UIColorFromRGB(0xff7a1e);
    } else {
        buyStatusLable.text = @"未兑换";
        buyStatusLable.textColor = COLOR_Text_Black;
    }
    
    // 分割线
    if (!(viewCount % column == 0 && viewCount >0)) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(viewW - 0.5, 10, 0.5, viewH - 2*10)];
        lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        lineView.tag = viewCount + 100; // 方便选中时隐藏
        [attrDescButton addSubview:lineView];
    }
    
    // 添加底部横线
    if(viewCount <= column)
    {
        UIView *lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, viewH - 0.5,viewW, 0.5)];
        lineBottomView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [attrDescButton addSubview:lineBottomView];
    }
    
    // 设置选中
    UIImage *gift_frame = [UIImage imageNamed:@"gift_frame"];
    UIEdgeInsets insets = UIEdgeInsetsMake(2,2,gift_frame.size.height-4,gift_frame.size.height-4);
    [attrDescButton setBackgroundImage:[DecodeJson stretchImage:gift_frame capInsets:insets resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
    if(viewCount==1){
        [self attrDescClick:attrDescButton];
    }
    return attrDescButton;
}

/**
 *  VIP选择点击
 */
- (void)attrDescClick:(UIButton *)button
{
    // 清空选中边框，显示分割线
    _selectButton.selected = NO;
    UIView *lineView = (UIView *)[_selectButton viewWithTag:_selectButton.tag + 100];
    if (lineView) {
        lineView.hidden = NO;
    }
    
    // 显示选中边框，隐藏分割线
    UIButton *selectbutton = [self viewWithTag:button.tag];
    selectbutton.selected = YES;
    UIView *nowLineView = (UIView *)[selectbutton viewWithTag:button.tag + 100];
    if (nowLineView) {
        nowLineView.hidden = YES;
    }
     _selectButton = selectbutton;
    
    if (self.selectVipBlock) {
        self.selectVipBlock(button.tag);
    }
}

@end
