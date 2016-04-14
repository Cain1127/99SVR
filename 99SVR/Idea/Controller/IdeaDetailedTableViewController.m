//
//  IdeaDetailedTableViewController.m
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "IdeaDetailedTableViewController.h"
#import "ideaDetailTableViewCell.h"
#import "DetaileHeaderView.h"

@interface IdeaDetailedTableViewController ()

@end

@implementation IdeaDetailedTableViewController
static NSString *const deataileCell = @"deataileCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"观点详情页";
    [self.tableView registerClass:([ideaDetailTableViewCell class]) forCellReuseIdentifier:deataileCell];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:0 target:self action:@selector(share)];
    
    DetaileHeaderView *headView = [[NSBundle mainBundle] loadNibNamed:@"DetaileHeaderView" owner:self options:nil].lastObject;
    self.tableView.tableHeaderView = headView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)share {
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const detaileCell = @"detaileCell";

    ideaDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deataileCell];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ideaDetailTableViewCell" bundle:nil] forCellReuseIdentifier:detaileCell];
        cell = [tableView dequeueReusableCellWithIdentifier:detaileCell];
    }
    
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
