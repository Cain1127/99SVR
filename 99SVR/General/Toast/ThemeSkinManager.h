
/**主题皮肤管理类*/


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ThemeSkinType){
    
    ThemeSkinType_0 = 1,
    ThemeSkinType_1 = 2,
};

@interface ThemeSkinManager : NSObject
/**tabbar 标题*/
@property (nonatomic , strong) NSArray *titleArray;
/**tabbar 正常图片*/
@property (nonatomic , strong) NSArray *normalImageArray;
/**tabbar 选中图片*/
@property (nonatomic , strong) NSArray *selectImageArray;
/**tabbar 背景颜色*/
@property (nonatomic , strong) UIColor *tabbarBackColor;
/**tabbar 渐变图片名字*/
@property (nonatomic , copy) NSString *tabbarMoveImageName;
/**tabbar 选中文字颜色*/
@property (nonatomic , strong) UIColor *selectItemColor;
/**tabbar 正常文字颜色*/
@property (nonatomic , strong) UIColor *normalItemColor;
/**导航条的 颜色*/
@property (nonatomic , strong) UIColor *navBarColor;
/**导航条 标题的颜色*/
@property (nonatomic , strong) UIColor *navBarTitColor;
/**单利皮肤管理类*/
+(ThemeSkinManager *)standardThemeSkin;
/**切换不同的皮肤*/
-(void)changeThemeSkinType:(ThemeSkinType)type;



@end
