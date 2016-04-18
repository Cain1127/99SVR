//
//  TQMessageViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 系统消息 >**********************************/

#import "TQMessageViewController.h"
#import "TQMessageCell.h"
#import "Masonry.h"
@interface TQMessageViewController ()

@end

@implementation TQMessageViewController
static NSString *const messageCell = @"messageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQMessageCell class]) bundle:nil] forCellReuseIdentifier:messageCell];
    /*设置头部vieiw*/
    [self addtableHeaderView];
}

-(void)addtableHeaderView {
    UIView *headerview = [[UIView alloc] init];
    headerview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
    self.tableView.tableHeaderView = headerview;
    /*添加子控件*/
    UILabel *titileLabel = [[UILabel alloc] init];
    titileLabel.text = @"尊敬的用户:";
    titileLabel.textColor = [UIColor colorWithHex:@"#262626"];
    titileLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"恭喜您开通“一夜岛”的VIP6，服务周期为2016.1.1至2017.1.1。您可以享受以下服务:";
    contentLabel.textColor = [UIColor colorWithHex:@"#878787"];

    UILabel *vipLabel = [[UILabel alloc] init];
    vipLabel.font = [UIFont systemFontOfSize:15];
    vipLabel.text = @"VIP6：一对一私人定制";
    vipLabel.textColor = [UIColor colorWithHex:@"#878787"];

    [headerview addSubview:titileLabel];
    [headerview addSubview:contentLabel];
    [headerview addSubview:vipLabel];
    
    //添加头部子控件布局
    [titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview.mas_left).offset(20);
        make.top.equalTo(headerview.mas_top).offset(20);
        make.right.equalTo(headerview.mas_right).offset(-20);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview.mas_left).offset(20);
        make.top.equalTo(titileLabel.mas_bottom).offset(10);
        make.right.equalTo(headerview.mas_right).offset(-20);
        
    }];
    [vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview.mas_left).offset(20);
        make.top.equalTo(contentLabel.mas_bottom).offset(10);
        make.right.equalTo(headerview.mas_right).offset(-20);
        
    }];


    
}
-(void)setUpheaderchildView {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TQMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCell];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
