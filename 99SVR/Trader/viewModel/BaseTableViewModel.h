

/**TableViewModel 的基型*/


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BaseTableViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UIViewController *viewController;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *dataArray;

- (instancetype)initWithViewController:(UIViewController *)viewController withDayTabViews:(NSArray *)tableViews;
-(void)setTableViewData:(NSArray *)dataArray;

@end
