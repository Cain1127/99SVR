


#import "ThemeSkinManager.h"

@implementation ThemeSkinManager

static ThemeSkinManager *manager = nil;

+(ThemeSkinManager *)standardThemeSkin{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ThemeSkinManager alloc]init];
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
