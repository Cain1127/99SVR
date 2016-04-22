//
//  TQNoCustomView.m
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQNoCustomView.h"
#import "TQPersonalTailorCell.h"

@interface TQNoCustomView () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation TQNoCustomView
static NSString *const NoCustomCell = @"NoCustomCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([TQPersonalTailorCell class]) bundle:nil] forCellReuseIdentifier:NoCustomCell];
        
    }
    return self;
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TQPersonalTailorCell *cell = [tableView dequeueReusableCellWithIdentifier:NoCustomCell];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    TQIntroductionViewController *vc = [[TQIntroductionViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}


@end