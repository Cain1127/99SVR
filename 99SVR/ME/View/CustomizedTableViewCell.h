//
//  CustomizedTableViewCell.h
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 jiangys . All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomizedModel;

@interface CustomizedTableViewCell : UITableViewCell
/** 私人定制模型 */
@property (nonatomic, strong) CustomizedModel *customizedModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
