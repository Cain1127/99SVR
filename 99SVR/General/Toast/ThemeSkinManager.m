


#import "ThemeSkinManager.h"

@implementation ThemeSkinManager

static ThemeSkinManager *manager = nil;

+(ThemeSkinManager *)standardThemeSkin{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ThemeSkinManager alloc]init];
        [manager changeThemeSkinType:ThemeSkinType_Default];
    });
    
    return manager;
}


/**切换不同的皮肤*/
-(void)changeThemeSkinType:(ThemeSkinType)type{
    
    switch (type) {
        case ThemeSkinType_Default://默认皮肤
        {
            if ([UserInfo sharedUserInfo].nStatus){
                _titleArray = @[@"首页",@"财经直播",@"专家观点",@"高手操盘",@"我"];
                _normalImageArray = @[@"home",@"video_live",@"tab_text_icon_normal",@"tab_operate_n",@"tab_me_p"];
                _selectImageArray = @[@"home_h",@"video_live_h",@"tab_text_icon_pressed",@"tab_operate_h",@"tab_me_p"];
                
            }else{
                _titleArray = @[@"首页",@"财经直播",@"专家观点",@"我"];
                _normalImageArray = @[@"home",@"video_live",@"tab_text_icon_normal",@"tab_me_p"];
                _selectImageArray = @[@"home_h",@"video_live_h",@"tab_text_icon_pressed",@"tab_me_p"];
            }
            
            //tabbar
            _tabbarBackColor = [UIColor whiteColor];
            _tabbarMoveImageName = @"";
            _normalItemColor =  UIColorFromRGB(0x919191);
            _selectItemColor = UIColorFromRGB(0x0078DD);
            _navBarColor = UIColorFromRGB(0xffffff);
            _navBarTitColor = UIColorFromRGB(0x4C4C4C);
            
            //导航条
            _navBarLBtnNImage = @"nav_menu_icon_n";
            _navBarLBtnHImage = @"nav_menu_icon_p";
            _navBarRBtnNImage = @"nav_search_icon_n";
            _navBarRBtnHImage = @"nav_search_icon_p";
            
            //
            

        }
            break;
        case ThemeSkinType_Gold:
        {
            
            if ([UserInfo sharedUserInfo].nStatus){
                _titleArray = @[@"首页",@"财经直播",@"专家观点",@"高手操盘",@"我"];
                _normalImageArray = @[@"home",@"video_live",@"tab_text_icon_normal",@"tab_operate_n",@"tab_me_p"];
                _selectImageArray = @[@"home_h",@"video_live_h",@"tab_text_icon_pressed",@"tab_operate_h",@"tab_me_p"];
                
            }else{
                _titleArray = @[@"首页",@"财经直播",@"专家观点",@"我"];
                _normalImageArray = @[@"home",@"video_live",@"tab_text_icon_normal",@"tab_me_p"];
                _selectImageArray = @[@"home_h",@"video_live_h",@"tab_text_icon_pressed",@"tab_me_p"];
            }
            
            _tabbarBackColor = [UIColor greenColor];
            _tabbarMoveImageName = @"";
            _normalItemColor =  [UIColor yellowColor];
            _selectItemColor = [UIColor blackColor];
            _navBarColor = COLOR_Text_Gay;
            _navBarTitColor = COLOR_Bg_Blue;
            
        }
            break;
        default:
            break;
    }
    
}


@end
