//
//  HomePageService.m
//  99SVR
//
//  Created by xia zhonglin  on 5/26/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HomePageService.h"
#import "HttpListener.h"
#import "HttpConnection.h"
#import "BannerModel.h"
#import "RoomHttp.h"
#import "ZLOperateStock.h"
#import "TQIdeaModel.h"

void HomePageListener::onResponse(std::vector<BannerItem>& banner_data, std::vector<Team>& team_data, std::vector<ViewpointSummary>& viewpoint_data, std::vector<OperateStockProfit>& operate_data)
{
    NSMutableArray *banner = [NSMutableArray array];
    int i;
    for (i=0; i<banner_data.size(); i++) {
        BannerItem _banner = banner_data[i];
        BannerModel *model = [[BannerModel alloc] initWithData:&_banner];
        [banner addObject:model];
    }
    
    NSMutableArray *videoRoom = [NSMutableArray array];
    for (i=0; i<team_data.size(); i++) {
        Team _team = team_data[i];
        RoomHttp *room = [[RoomHttp alloc] initWithData:&_team];
        [videoRoom addObject:room];
    }
    NSMutableArray *aryViewPoint = [NSMutableArray array];
    for (i=0; i<viewpoint_data.size(); i++) {
        ViewpointSummary summary = viewpoint_data[i];
        TQIdeaModel *model = [[TQIdeaModel alloc] initWithViewpointSummary:&summary];
        [aryViewPoint addObject:model];
    }
    NSMutableArray *aryOperate = [NSMutableArray array];
    for (i=0; i<operate_data.size(); i++) {
        OperateStockProfit item = operate_data[i];
        ZLOperateStock *operStock = [[ZLOperateStock alloc] init];
        
        operStock.operateid = item.operateid();
        operStock.teamname = [NSString stringWithUTF8String:item.teamname().c_str()];;
        operStock.teamicon = [NSString stringWithUTF8String:item.teamicon().c_str()];;
        operStock.focus = [NSString stringWithUTF8String:item.focus().c_str()];;
        
        operStock.goalprofit = item.goalprofit();
        operStock.totalprofit = item.totalprofit();
        operStock.dayprofit = item.dayprofit();
        operStock.monthprofit = item.monthprofit();
        operStock.winrate = item.winrate();
        [aryOperate addObject:operStock];
    }
    NSDictionary *dict = @{@"code":@(1),@"video":videoRoom,@"viewpoint":aryViewPoint,@"operate":aryOperate,@"banner":banner};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HOME_BANNER_VC object:dict];
}

void HomePageListener::OnError(int errCode)
{
    NSDictionary *dict = @{@"code":@(errCode)};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HOME_BANNER_VC object:dict];
}

@interface HomePageService()
{
    HomePageListener *_homeListener;
    HttpConnection *_httpConnection;
}
@end

@implementation HomePageService

- (void)requestHomePage
{
    if (!_homeListener)
    {
        _homeListener = new HomePageListener;
    }
    if(!_httpConnection)
    {
        _httpConnection = new HttpConnection;
    }
    _httpConnection->RequestHomePage(_homeListener);
}




@end
