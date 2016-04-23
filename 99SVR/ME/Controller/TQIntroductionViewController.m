//
//  TQIntroductionViewController.m
//  99SVR
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQIntroductionViewController.h"
#import "TQNoCustomHeader.h"
#import "TQIntroductCell.h"

@interface TQIntroductionViewController ()
@end

@implementation TQIntroductionViewController
static NSString *const IntroductCell = @"IntroductCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeaderView];
    
    

}
-(void)setupHeaderView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQIntroductCell class]) bundle:nil] forCellReuseIdentifier:IntroductCell];

    //头部视图
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TQNoCustomHeader" owner:nil options:nil] lastObject];
//    headerView.frame = CGRectMake(0, 0, 0, 200);
    self.tableView.tableHeaderView = headerView;
    
    //注册组头部视图
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TQIntroductCell *cell = [tableView dequeueReusableCellWithIdentifier:IntroductCell];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
