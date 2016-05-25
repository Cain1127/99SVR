
/**主题皮肤管理类*/


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ThemeSkinType){
    
    ThemeSkinType_0 = 1,
    ThemeSkinType_1 = 2,
};

@interface ThemeSkinManager : NSObject

@property (nonatomic , strong) NSArray *titleArray;
@property (nonatomic , strong) NSArray *normalImageArray;
@property (nonatomic , strong) NSArray *selectImageArray;

/**单利皮肤管理类*/
+(ThemeSkinManager *)standardThemeSkin;
/**切换不同的皮肤*/
-(void)changeThemeSkinType:(ThemeSkinType)type;



@end
