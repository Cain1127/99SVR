
/**主题皮肤管理类*/


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ThemeSkinType){
    
    ThemeSkinType_0 = 1,
    ThemeSkinType_1 = 2,
};

@interface ThemeSkinManager : NSObject

/**单利皮肤管理类*/
+(ThemeSkinManager *)standardThemeSkin;
/**切换不同的皮肤*/
-(void)changeThemeSkinType:(ThemeSkinType)type;



@end
