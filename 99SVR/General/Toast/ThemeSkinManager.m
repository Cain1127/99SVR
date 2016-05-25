


#import "ThemeSkinManager.h"

@implementation ThemeSkinManager

static ThemeSkinManager *manager = nil;

+(ThemeSkinManager *)standardThemeSkin{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ThemeSkinManager alloc]init];
        if ([UserInfo sharedUserInfo].nStatus){
            manager.titleArray = @[@"首页",@"财经直播",@"专家观点",@"高手操盘",@"我"];
            manager.normalImageArray = @[@"home",@"video_live",@"tab_text_icon_normal",@"tab_operate_n",@"tab_me_p"];
            manager.selectImageArray = @[@"home_h",@"video_live_h",@"tab_text_icon_pressed",@"tab_operate_h",@"tab_me_p"];
            
        }else{
            manager.titleArray = @[@"首页",@"财经直播",@"我"];
            manager.normalImageArray = @[@"home",@"video_live",@"tab_me_p"];
            manager.selectImageArray = @[@"home_h",@"video_live_h",@"tab_me_p"];
        }
    });
    
    return manager;
}


/**切换不同的皮肤*/
-(void)changeThemeSkinType:(ThemeSkinType)type{
    
    switch (type) {
        case ThemeSkinType_0:
        {
            
            
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
