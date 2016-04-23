//
//  TQNoPurchaseTableview.m
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQNoPurchaseTableview.h"
#import "TQNoCustomHeader.h"
#import "TQIntroductCell.h"
#import "TQNoCustomHeader.h"
#import "TQPurchaseView.h"
@interface TQNoPurchaseTableview ()
/** 头部试图 */
@property (nonatomic ,weak)TQNoCustomHeader *headerView;
/** 购买框 */
@property (nonatomic ,weak)TQPurchaseView *purchaseView;

@end

@implementation TQNoPurchaseTableview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)creatViews {
    [self setupHeaderView];
    TQPurchaseView *purchaseView = [[NSBundle mainBundle] loadNibNamed:@"purchaseView" owner:nil options:nil] [0];
    [purchaseView.purchaseBtn addTarget:self action:@selector(purchaseViewPage) forControlEvents:UIControlEventTouchUpInside];
    purchaseView.frame = CGRectMake(10, kScreenHeight - 64, kScreenWidth - 20, 44);
    //    purchaseView.hidden = YES;
    _purchaseView = purchaseView;
    [self addSubview:purchaseView];
}

-(void)setupHeaderView {
//    [self registerNib:[UINib nibWithNibName:NSStringFromClass([TQIntroductCell class]) bundle:nil] forCellReuseIdentifier:IntroductCell];
    
    //头部视图
    TQNoCustomHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TQNoCustomHeader" owner:nil options:nil] lastObject];
    self.headerView = headerView;
    //    headerView.frame = CGRectMake(0, 0, 0, 200);
    self.tableHeaderView = headerView;
    [headerView.questionBtn addTarget:self action:@selector(DetailsPage) forControlEvents:UIControlEventTouchUpInside];
}


@end
