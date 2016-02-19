//
//  TeacherModel.m
//  99SVR
//
//  Created by xia zhonglin  on 1/8/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TeacherModel.h"

@implementation TeacherModel

- (id)initWithTeacher:(CMDTextRoomTeacherNoty_t *)teacher
{
    if(self =[super init])
    {
        [self decodeTeacherInfo:teacher];
        return self;
    }
    return nil;
}

- (void)decodeTeacherInfo:(CMDTextRoomTeacherNoty_t *)teacher
{
    _vcbid = teacher->vcbid;
    _userid = teacher->userid;
    _teacherid = teacher->teacherid;
    _strName = [NSString stringWithCString:teacher->teacheralias encoding:GBK_ENCODING];
    _headid = teacher->headid;
    _levellen = teacher->levellen;
    _labellen = teacher->labellen;
    _goodatlen = teacher->goodatlen;
    _introducelen = teacher->introducelen;
    _historymoods = teacher->historymoods;
    _fans = teacher->fans;
    _zans = teacher->zans;
    _todaymoods = teacher->todaymoods;
    _historyLives = teacher->historyLives;
    _liveflag = teacher->liveflag;
    _fansflag = teacher->fansflag;
    
    char cLevel[_levellen];
    memcpy(cLevel,teacher->content,_levellen);
    _strLevel = [NSString stringWithCString:cLevel encoding:GBK_ENCODING];
    
    char cLabel[_labellen];
    memcpy(cLabel,teacher->content+_levellen,_labellen);
    _strLabel = [NSString stringWithCString:cLabel encoding:GBK_ENCODING];
    
    char cGoodat[_goodatlen];
    memcpy(cGoodat,teacher->content+_levellen+_labellen,_goodatlen);
    _strGoodat = [NSString stringWithCString:cGoodat encoding:GBK_ENCODING];
    
    char cContent[_introducelen];
    memcpy(cContent,teacher->content+_levellen+_labellen+_goodatlen, _introducelen);
    _strContent = [NSString stringWithCString:cContent encoding:GBK_ENCODING];
    
}


@end
