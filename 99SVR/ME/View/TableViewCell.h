//
//  TableViewCell.h
//  Demo
//
//  Created by 林柏参 on 16/4/22.
//  Copyright © 2016年 XMG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewCellDelegate <NSObject>

-(void)tableViewCellWithClickButton:(UIButton *)button row:(NSInteger)row;

@end

@interface TableViewCell : UITableViewCell
/**背景图*/
@property (weak, nonatomic) IBOutlet UIView *BackgroundView;
/**介绍的lab*/
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
/**vip图片*/
@property (weak, nonatomic) IBOutlet UIImageView *vipIconImageView;
/**vip名字*/
@property (weak, nonatomic) IBOutlet UILabel *vipNameLab;
/**现价*/
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLab;
/**原价*/
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;
/**背景框*/
@property (weak, nonatomic) IBOutlet UIView *selectView;

/**<#type#>*/
@property (nonatomic , strong) UIButton *clickBtn;

@property (nonatomic,assign)NSInteger row;
@property (nonatomic,weak)id <TableViewCellDelegate>delegate;


@end
