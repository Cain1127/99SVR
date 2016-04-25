//
//  XTeamViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/21/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTeamViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "RoomHttp.h"
#import "XVideoTeamInfo.h"
@interface XTeamViewController()<DTAttributedTextContentViewDelegate>
{
    
}

@property (nonatomic,strong) DTAttributedTextView *textView;
@property (nonatomic,strong) RoomHttp *room;

@end

@implementation XTeamViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"战队简介"];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    
    _textView = [[DTAttributedTextView alloc] initWithFrame:Rect(8, 74, kScreenWidth-16, kScreenHeight-74)];
    _textView.textDelegate = self;
    [self.view addSubview:_textView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTeamContent:) name:MESSAGE_TEAM_INTRODUCE_VC object:nil];
    [kHTTPSingle RequestTeamIntroduce:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadTeamContent:(NSNotification *)notify
{
    XVideoTeamInfo *teamInfo = notify.object;
    if(teamInfo){
        NSString *strContent = teamInfo.introduce;
        _textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[strContent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    }
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
