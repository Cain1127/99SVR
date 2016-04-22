


#import "TraderViewController.h"
#import "SliderMenuView.h"
#import "ShareFunction.h"
#import "SearchController.h"
#import "TraderHomeCell.h"
#import "MacroHeader.h"
#import "StockDealViewController.h"
#import "TraderTableViewModel.h"

@interface TraderViewController ()
/**滑动控制器*/
@property (nonatomic, strong) SliderMenuView *sliderMenuView;
@property (nonatomic ,strong) TraderTableViewModel *tableViewModel;
/**日*/
@property (nonatomic, strong) UITableView *dayTab;
/**月*/
@property (nonatomic, strong) UITableView *monTab;
/**总的*/
@property (nonatomic, strong) UITableView *totalTab;

@end

@implementation TraderViewController

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
    
    _tableViewModel = [[TraderTableViewModel alloc]initWithViewController:self withDayTabViews:@[self.dayTab,self.monTab,self.totalTab]];
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
    }
    
    return _dayTab;
}

-(UITableView *)monTab{
    
    if (!_monTab) {
     
        _monTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
    }
    return _monTab;
}

-(UITableView *)totalTab{
    
    if (!_totalTab) {
        _totalTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
    }
    return _totalTab;
}


-(UITableView *)createTableViewWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor grayColor];
    return tableView;
}

#pragma mark tableView delegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ValueWithTheIPhoneModelString(@"150,180,200");
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"cellId";
    
    TraderHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        
        cell = [[TraderHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController pushViewController:[[StockDealViewController alloc]init] animated:YES];
    
}

@end
