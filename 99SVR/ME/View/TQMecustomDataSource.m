//
//  TQMecustomView.m
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQMecustomView.h"
#import "TQMeCustomizedCell.h"

@interface TQMecustomDataSource () 


@end

@implementation TQMecustomDataSource

static NSString *const MeCustomizedCell = @"MeCustomizedCell";

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.delegate = self;
//        self.dataSource = self;
//        [self registerNib:[UINib nibWithNibName:NSStringFromClass([TQMeCustomizedCell class]) bundle:nil] forCellReuseIdentifier:MeCustomizedCell];
//
//    }
//    return self;
//}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryPurchase.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TQMeCustomizedCell *cell = [tableView dequeueReusableCellWithIdentifier:MeCustomizedCell];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    TQIntroductionViewController *vc = [[TQIntroductionViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}


@end
