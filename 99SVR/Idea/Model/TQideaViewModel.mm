//
//  TQideaViewModel.m
//  99SVR
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQideaViewModel.h"
#import "HttpMessage.pb.h"
#import "TQIdeaModel.h"

/*
 string	_authorid; //用户ID
 string	_authorname; //用户名
 string	_authoricon;//头像
 uint32	_viewpointid;
 string	_publishtime;//发布时间
 string	_content; //内容
 uint32	_replycount; //回复数
 uint32	_flowercount; //献花数
 */
@implementation TQideaViewModel
//
//-(NSArray *)getArrayRturnRrray:(NSMutableArray *)array {
//    for (NSValue *value in array) {
//        TQIdeaModel *model = [[TQIdeaModel alloc] init];
//        ViewpointSummary *summary = (ViewpointSummary*)value.pointerValue;
//        //        DLog(@"%s",summary->authorname().c_str());
//         model.authorid = [NSString stringWithCString:summary->authorid().c_str() encoding:NSUTF8StringEncoding];
//         model.time = [NSString stringWithCString:summary->publishtime().c_str() encoding:NSUTF8StringEncoding];
//        
//        model.icon = [NSString stringWithCString:summary->authoricon().c_str() encoding:NSUTF8StringEncoding];
//        model.name = [NSString stringWithCString:summary->authorname().c_str() encoding:NSUTF8StringEncoding];
//        model.content = [NSString stringWithCString:summary->content().c_str() encoding:NSUTF8StringEncoding];
////        model.viewpointid = summary->viewpointid().c_str();
//        
//        //        NSString *str3
////        DLog(@"%@", str1);
//        //        DLog(@"%@---%@----%@+++++++%d", str1,str2,str4, summary->viewpointid());
//    }
//}

@end

    
