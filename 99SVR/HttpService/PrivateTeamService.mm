//
//  PrivateServiceForTeam.m
//  99SVR
//
//  Created by xia zhonglin  on 6/1/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "PrivateTeamService.h"
#include "HttpListener.h"
#include "HttpConnection.h"
#import "XPrivateService.h"

static PrivateTeamService *_privateService;

void TeamPrivateServiceSummaryPackListener::onResponse(vector<TeamPrivateServiceSummaryPack>& infos)
{
    NSMutableArray *aryDict = [NSMutableArray array];
    for(int i=0;i<infos.size();i++)
    {
        TeamPrivateServiceSummaryPack pack = infos[i];
        XPrivateService *service = [[XPrivateService alloc] init];
        service.vipLevelId = pack.vipLevelId();
        service.vipLevelName = [NSString stringWithUTF8String:pack.vipLevelName().c_str()];
        service.isOpen = pack.isOpen();
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0 ; j < pack.summaryList().size(); j++) {
            PrivateServiceSummary sumary = pack.summaryList()[j];
            XPrivateSummary *priSummary = [[XPrivateSummary alloc] init];
            
            priSummary.nId = sumary.id();
            priSummary.title = [NSString stringWithUTF8String:sumary.title().c_str()];
            priSummary.summary = [NSString stringWithUTF8String:sumary.summary().c_str()];
            priSummary.publishtime = [NSString stringWithUTF8String:sumary.publishtime().c_str()];
            priSummary.teamname = [NSString stringWithUTF8String:sumary.teamname().c_str()];
            [array addObject:priSummary];
        }
        service.summaryList = array;
        [aryDict addObject:service];
    }
    NSDictionary *dict = @{@"code":@(1),@"model":aryDict};
    [_privateService responseHttp:dict];
}

void TeamPrivateServiceSummaryPackListener::OnError(int errCode)
{
    NSDictionary *dict = @{@"code":@(errCode)};
    [_privateService responseHttp:dict];
}

@interface PrivateTeamService()
{
    TeamPrivateServiceSummaryPackListener *_teamPrivateListener;
    HttpConnection *_httpConnection;
}
@end

@implementation PrivateTeamService

- (void)requestTeamService:(int)teamid
{
    if (!_teamPrivateListener)
    {
        _teamPrivateListener = new TeamPrivateServiceSummaryPackListener;
    }
    if(!_httpConnection)
    {
        _httpConnection = new HttpConnection;
    }
    _privateService = self;
    _httpConnection->RequestTeamPrivateServiceSummaryPack(teamid,_teamPrivateListener);
}

- (void)responseHttp:(NSDictionary *)dict
{
    _privateService = nil;
    if (_block)
    {
        _block(dict);
    }
}

@end
