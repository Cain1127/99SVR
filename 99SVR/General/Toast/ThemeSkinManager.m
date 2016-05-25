


#import "ThemeSkinManager.h"

@implementation ThemeSkinManager

static ThemeSkinManager *manager = nil;

+(ThemeSkinManager *)standardThemeSkin{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ThemeSkinManager alloc]init];
        [manager changeThemeSkinType:ThemeSkinType_0];
    });
    
    return manager;
}


/**切换不同的皮肤*/
-(void)changeThemeSkinType:(ThemeSkinType)type{
    
    switch (type) {
        case ThemeSkinType_0://默认皮肤
        {
            if ([UserInfo sharedUserInfo].nStatus){
                _titleArray = @[@"首页",@"财经直播",@"专家观点",@"高手操盘",@"我"];
                _normalImageArray = @[@"home",@"video_live",@"tab_text_icon_normal",@"tab_operate_n",@"tab_me_p"];
                _selectImageArray = @[@"home_h",@"video_live_h",@"tab_text_icon_pressed",@"tab_operate_h",@"tab_me_p"];
                
            }else{
                _titleArray = @[@"首页",@"财经直播",@"我"];
                _normalImageArray = @[@"home",@"video_live",@"tab_me_p"];
                _selectImageArray = @[@"home_h",@"video_live_h",@"tab_me_p"];
            }
            
            _tabbarBackColor = [UIColor whiteColor];
            _tabbarMoveImageName = @"";
            _normalItemColor =  UIColorFromRGB(0x919191);
            _selectItemColor = UIColorFromRGB(0x0078DD);
//            _navBarColor = UIColorFromRGB(rgbValue);
            
        }
            break;
        case ThemeSkinType_1:
        {
            
            
        }
            break;
        default:
            break;
    }
    
}


@end
