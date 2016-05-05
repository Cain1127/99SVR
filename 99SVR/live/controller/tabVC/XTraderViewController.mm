//
//  XTraderViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTraderViewController.h"
#import "StockHomeTableViewModel.h"
#import "ViewNullFactory.h"
#import "TableViewFactory.h"
#import "MJRefresh.h"
#import "StockDealModel.h"
#import "RoomHttp.h"
#import "MJRefresh.h"

#import <objc/runtime.h>

@interface XTraderViewController()
{
    
}
@property (nonatomic,strong) RoomHttp *room;
@property (nonatomic,strong) UIView *noView;
@property (nonatomic , strong) UITableView *totalTab;
@property (nonatomic , strong) StockHomeTableViewModel *totalTableViewModel;
@property (nonatomic , strong) __block NSMutableArray *totalDataArray;
@property (nonatomic , assign) __block NSInteger totalPagInteger;
@property (nonatomic , strong) UIView *totalEmptyView;

@property (nonatomic , assign) __block MJRefreshState refreshState;
@property (nonatomic, strong) UIViewController *control;

@end

@implementation XTraderViewController

- (id)initWithFrame:(CGRect)frame model:(RoomHttp *)room control:(UIViewController *)control
{
    self = [super initWithFrame:frame];
    _room = room;
    _control = control;
    [self initBody];
    
    return self;
}

- (void)addNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTotalData:) name:MESSAGE_STOCK_HOME_TOTAL__VC object:nil];
}

- (void)removeNotice
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadModel:(RoomHttp *)room
{
    _room = room;
    [self addNotice];
    [_totalTab.header beginRefreshing];
}

- (id)initWihModel:(RoomHttp *)room
{
    self = [super init];
    _room = room;
    return self;
}

- (void)initBody
{
    [self addNotice];
    [self initData];
    [self initUi];
}

#pragma mark initUi
-(void)initUi{
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark initData
-(void)initData
{
    WeakSelf(self);
   [self.totalTab addGifHeaderWithRefreshingBlock:^{
        weakSelf.refreshState = MJRefreshState_Header;
        weakSelf.totalPagInteger = 1;
        [kHTTPSingle RequestOperateStockProfitByAll:[weakSelf.room.teamid intValue] start:(int)weakSelf.totalPagInteger count:20];
    }];
    
    [self.totalTab addLegendFooterWithRefreshingBlock:^{
        weakSelf.refreshState = MJRefreshState_Footer;
        weakSelf.totalPagInteger ++;
        [kHTTPSingle RequestOperateStockProfitByAll:[weakSelf.room.teamid intValue] start:(int)weakSelf.totalPagInteger count:20];
    }];
    
    [self.totalTab.gifHeader loadDefaultImg];
    Loading_Bird_Show(self.totalTab);
    [self.totalTab.gifHeader beginRefreshing];
    self.totalTab.footer.hidden = YES;
}

#pragma mark 刷新数据
-(void)refreshTotalData:(NSNotification *)notfi{
    
    [self refreshTableDataWithTable:self.totalTab WithTableViewModel:self.totalTableViewModel fromDataDic:(NSDictionary *)notfi.object toDataArray:self.totalDataArray];
}
/**
 *  刷新数据
 *
 *  @param table         对应的tab
 *  @param tableModel    对应的tableMldel
 *  @param fromDataArray 原始数据
 *  @param toDataArray   实际的数据
 */
-(void)refreshTableDataWithTable:(UITableView *)table WithTableViewModel:(StockHomeTableViewModel *)tableModel fromDataDic:(NSDictionary *)fromDataDic toDataArray:(NSMutableArray *)toDataArray{
    
    Loading_Bird_Hide(table);
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *code = [NSString stringWithFormat:@"%@",fromDataDic[@"code"]];
        if ([code isEqualToString:@"1"]) {//请求成功
            
            if (self.refreshState == MJRefreshState_Header)
            {//头部刷新需要清空数据
                [toDataArray removeAllObjects];
            }
            
            NSArray *fromDataArray = fromDataDic[@"data"];
            
            if ([fromDataArray count]< selfWeak.totalPagInteger * 20 ) {
                [table.footer setHidden:YES];
            }
            else
            {
                table.footer.hidden = NO;
                [table.footer resetNoMoreData];
            }
            
            [table.gifHeader endRefreshing];
            [table.footer endRefreshing];
            
            for (int i=0; i!=[fromDataArray  count]; i++) {
                [toDataArray addObject:fromDataArray[i]];
            }
            
        }else{//请求失败
            
            table.footer.hidden = YES;
            [table.gifHeader endRefreshing];
            [table.footer endRefreshing];
            
        }
        
        [tableModel setDataArray:toDataArray];
        [table reloadData];
        
        [self chickEmptyViewShowWithTab:table withData:toDataArray withCode:code];
        
    });
    
    
}

-(NSMutableArray *)totalDataArray{
    
    if (!_totalDataArray) {
        
        _totalDataArray = [NSMutableArray array];
    }
    return _totalDataArray;
}

-(UITableView *)totalTab{
    
    if (!_totalTab)
    {
        _totalTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,self.height} withStyle:UITableViewStylePlain];
        _totalTab.delegate = self.totalTableViewModel;
        _totalTab.dataSource = self.totalTableViewModel;
        [self addSubview:_totalTab];
    }
    return _totalTab;
}

-(StockHomeTableViewModel *)totalTableViewModel
{
    if (!_totalTableViewModel)
    {
        _totalTableViewModel = [[StockHomeTableViewModel alloc]initWithViewController:_control];
    }
    return _totalTableViewModel;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark 请求成功时候-检测是否出现提示图
-(void)chickEmptyViewShowWithTab:(UITableView *)tab withData:(NSMutableArray *)dataArray withCode:(NSString *)code
{
    WeakSelf(self);
    if (dataArray.count==0&&[code intValue]!=1)
    {//数据为0 请求失败
        
        [self showErrorViewInView:tab withMsg:[NSString stringWithFormat:@"网络请求失败%@,点击重新请求",code] touchHanleBlock:
        ^{
            Loading_Bird_Show(weakSelf.totalTab);
            [weakSelf.totalTab.gifHeader beginRefreshing];
        }];
    }else if (dataArray.count==0&&[code intValue]==1){//数据为0 请求成功
        [self showEmptyViewInView:tab withMsg:[NSString stringWithFormat:@"暂无数据"] touchHanleBlock:^{
            Loading_Bird_Show(weakSelf.totalTab);
            [weakSelf.totalTab.gifHeader beginRefreshing];
        }];
    }
    else
    {
        //请求成功
        [self hideEmptyViewInView:tab];
    }
}

-(UITableView *)createTableViewWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_Bg_Gay;
    return tableView;
}

-(void)dealloc{
    
    DLog(@"释放");
    
}

#define EmptyViewTag 99999

static char  * TapRecognizerBlockKey;
-(void)showEmptyViewInView:(UIView *)targetView withMsg:(NSString *)msg  withImageName:(NSString *)imageName touchHanleBlock:(TouchHanleBlock)hanleBlock{
    UIView *emptyView = [targetView viewWithTag:EmptyViewTag];
    if (emptyView) {
        [emptyView removeFromSuperview];
    }
    
    CGFloat width = targetView.frame.size.width;
    CGFloat height = targetView.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,width,height}];
    view.userInteractionEnabled = YES;
    [view setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    view.tag = EmptyViewTag;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]init];
    tapRecognizer.numberOfTapsRequired = 1;
    [tapRecognizer addTarget:self action:@selector(tapRecognizerAction:)];
    [view addGestureRecognizer:tapRecognizer];
    objc_setAssociatedObject(self, &TapRecognizerBlockKey, hanleBlock, OBJC_ASSOCIATION_COPY);
    [targetView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = (CGRect){0,0,120,120};
    imageView.center = CGPointMake(view.center.x, view.center.y-60);
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
    
    UILabel *titLab = [[UILabel alloc]init];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.numberOfLines = 0;
    titLab.textColor = UIColorFromRGB(0x4c4c4c);
    titLab.text = msg;
    [titLab sizeToFit];
    titLab.frame = (CGRect){0,CGRectGetMaxY(imageView.frame),width,titLab.frame.size.height};
    [view addSubview:titLab];
}

-(void)tapRecognizerAction:(UITapGestureRecognizer *)tap{
    
    
    TouchHanleBlock block = objc_getAssociatedObject(self, &TapRecognizerBlockKey);
    if (block)
    {
        block();
    }
    
    UIView *tapView = tap.view;
    if (tapView) {
        [tapView removeFromSuperview];
    }
}


-(void)hideEmptyViewInView:(UIView *)targetView{
    
    UIView *view = [targetView viewWithTag:EmptyViewTag];
    if (view) {
        [view removeFromSuperview];
    }
}

-(void)showEmptyViewInView:(UIView *)targetView withMsg:(NSString *)msg touchHanleBlock:(TouchHanleBlock)hanleBlock{
    
    [self showEmptyViewInView:targetView withMsg:msg withImageName:@"text_blank_page" touchHanleBlock:hanleBlock];
}


-(void)showErrorViewInView:(UIView *)targetView withMsg:(NSString *)msg touchHanleBlock:(TouchHanleBlock)hanleBlock{
    
    [self showEmptyViewInView:targetView withMsg:msg withImageName:@"network_anomaly_fail" touchHanleBlock:hanleBlock];
    
}

@end