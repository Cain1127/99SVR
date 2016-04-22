


#import "StockHomeViewController.h"
#import "SliderMenuView.h"
#import "ShareFunction.h"
#import "SearchController.h"
#import "StockMacro.h"
#import "StockDealViewController.h"
#import "StockHomeTableViewModel.h"

@interface StockHomeViewController ()
/**滑动控制器*/
@property (nonatomic, strong) SliderMenuView *sliderMenuView;
/**日*/
@property (nonatomic, strong) UITableView *dayTab;
@property (nonatomic ,strong) StockHomeTableViewModel *dayTableViewModel;
/**月*/
@property (nonatomic, strong) UITableView *monTab;
@property (nonatomic ,strong) StockHomeTableViewModel *monTableViewModel;
/**总的*/
@property (nonatomic, strong) UITableView *totalTab;
@property (nonatomic ,strong) StockHomeTableViewModel *totalTableViewModel;

@end

@implementation StockHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUi];
    [self initData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark initUi
-(void)initUi{
    
    [self.navigationController.navigationBar setHidden:YES];
    UIView *_headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel *title;
    title = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [title setFont:XCFONT(20)];
    [_headView addSubview:title];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:UIColorFromRGB(0x0078DD)];
    UILabel *_lblContent;
    _lblContent = [[UILabel alloc] initWithFrame:Rect(0, 63.5, kScreenWidth, 0.5)];
    [_lblContent setBackgroundColor:[UIColor whiteColor]];
    [_headView addSubview:_lblContent];
    title.text = @"高手操盘";
    UIButton *btnLeft = [CustomViewController itemWithTarget:self action:@selector(showLeftView) image:@"nav_menu_icon_n" highImage:@"nav_menu_icon_p"];
    [self.view addSubview:btnLeft];
    [btnLeft setFrame:Rect(0,20,44,44)];
    
    UIButton *btnRight = [CustomViewController itemWithTarget:self action:@selector(searchClick) image:@"nav_search_icon_n" highImage:@"nav_search_icon_p"];
    [_headView addSubview:btnRight];
    [btnRight setFrame:Rect(kScreenWidth-44, 20, 44, 44)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.sliderMenuView];
    self.sliderMenuView.DidSelectSliderIndex = ^(NSInteger index){
        NSLog(@"模块%ld",(long)index);
    };
}

#pragma mark initData
-(void)initData{
    

    
}

#pragma mark nabbar左右两边按钮事件
- (void)showLeftView
{
    [self leftItemClick];
}

- (void)searchClick
{
    SearchController *search = [[SearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}
#pragma mark lazyView 懒加载
-(SliderMenuView *)sliderMenuView{
    
    if (!_sliderMenuView) {
        
        CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        CGFloat tabbarH = CGRectGetHeight(self.tabBarController.tabBar.frame);
        _sliderMenuView = [[SliderMenuView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH-tabbarH} withTitles:@[@"日收益",@"月收益",@"总收益"] withDefaultSelectIndex:1];
        _sliderMenuView.viewArrays = @[self.dayTab,self.monTab,self.totalTab];
    }
    return _sliderMenuView;
}

-(UITableView *)dayTab{

    if (!_dayTab) {
        
        _dayTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
        _dayTab.delegate = self.dayTableViewModel;
        _dayTab.dataSource = self.dayTableViewModel;
    }
    
    return _dayTab;
}

-(UITableView *)monTab{
    
    if (!_monTab) {
     
        _monTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
        _monTab.delegate = self.monTableViewModel;
        _monTab.dataSource = self.monTableViewModel;
    }
    return _monTab;
}

-(UITableView *)totalTab{
    
    if (!_totalTab) {
        _totalTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
        _totalTab.delegate = self.totalTableViewModel;
        _totalTab.dataSource = self.totalTableViewModel;
    }
    return _totalTab;
}

-(StockHomeTableViewModel *)dayTableViewModel{
    if (!_dayTableViewModel) {
        _dayTableViewModel = [[StockHomeTableViewModel alloc]initWithViewController:self];
    }
    return _dayTableViewModel;
}

-(StockHomeTableViewModel *)monTableViewModel{
    if (!_monTableViewModel) {
        _monTableViewModel = [[StockHomeTableViewModel alloc]initWithViewController:self];
    }
    return _monTableViewModel;
}

-(StockHomeTableViewModel *)totalTableViewModel{
    if (!_totalTableViewModel) {
        _totalTableViewModel = [[StockHomeTableViewModel alloc]initWithViewController:self];
    }
    return _totalTableViewModel;
}


-(UITableView *)createTableViewWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor grayColor];
    return tableView;
}


@end
