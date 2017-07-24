//
//  GameCenterInstance.h
//  GamesSkySDK
//
//  Created by xiaofeng xiao on 2017/6/20.
//  Copyright © 2017年 xiaofeng xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSKYMatchInfo.h"

/**
 * NS_ENUM defining the different servers that GameCenter can connect to.
 * //MARK: 服务端环境
 */
typedef NS_ENUM (NSInteger, GameCenterEnvironment) {
    /** Used when connecting to the live production server. */
    GameCenterProduction,
    /** Used when connecting to the test sandbox server. */
    GameCenterSandbox
};

/**
 * NS_ENUM defining the orientations that GameCenter can be launched in.
 * //MARK:启动游戏时屏幕旋转方向枚举
 */
typedef NS_ENUM (NSInteger, GameCenterOrientation) {
    /** Used to launch GameCenter in a portrait orientation. */
    GameCenterPortrait,
    /** Used to launch GameCenter in a landscape orientation. This will match the landscape orientation of your game. */
    GameCenterLandscape
};


@protocol GameCenterBaseDelegate <NSObject>

@required
/**
 * GameCenter will only query for this value upon display of the GameCenter UI, either via completion of game, or initial launch.
 * * //MARK:启动游戏时屏幕旋转方向
 * @return The orientation that will be used to construct the GameCenter UI. The GameCenter UI will then be locked to this orientation
 *         until it is dismissed.
 */
- (GameCenterOrientation)preferredGameCenterInterfaceOrientation;

@optional
/**
 * This method will be called when the GameCenter SDK will exit. It will NOT be called when a Skillz Tournament is launched.
 */
- (void)gameCenterWillExit;

/**
 * This method will be called before the GameCenter UI launches. Use this to clean up any state needed before you launch Skillz.
 */
- (void)gameCenterWillLaunch;

/**
 * This method will be called once the GameCenter UI has finished displaying. Use this to clean up your view hierarchy.
 */
- (void)gameCenterHasFinishedLaunching;


@end


@protocol GameCenterDelegate <GameCenterBaseDelegate>

@required
/**
 * This method will be called when a typical Skillz tournament will launch. You should use this method for constructing a new game
 * based on the supplied argument.
 *
 * @param gameParameters dictionary contains the Game Parameters that were configured in the Skillz Developer Portal
 * @param matchInfo class contain data relevant to the current match
 */
- (void)tournamentWillBegin:(NSDictionary *)gameParameters
              withMatchInfo:(GSKYMatchInfo *)matchInfo;

@optional


@end

///----------------------------------------------------
///@name GameCenter SDK Interface
///----------------------------------------------------


__attribute__ ((visibility("default")))
NS_AVAILABLE_IOS(8_0)
/**
  Skillz SDK Interface
 */
@interface GameCenterInstance : NSObject
/**
 //MARK: Whether or not a Skillz match is currently in progress.
 */
@property BOOL tournamentIsInProgress;
/**
 * Get the current logged in player. Use this method if you need this
 * information outside of a tournament.
 *
 * @return GSKYPlayer object that represent the current player. If there is no
 * player currently logged in, will return nil.
 */
@property (nonatomic,strong) GSKYPlayer *player;
/**
 * The current SkillzBaseDelegate instance
 */
@property (nonatomic, strong) id<GameCenterDelegate> gameCenterDelegate;

/**
 * Get a singleton reference to the GamesSkySDK SDK
 * //MARK: GameCenterInstance单例
 * @return The singleton instance of the GamesSkySDK SDK object
 */
+ (GameCenterInstance *)gameCenterInstance;

/**
 //MARK: 启动游戏中心界面
 */
- (void)launchGamesCenterViewController;
/**
 * This method must be called each time the current player's score changes during a GameCenter match.
 *  //MARK: 每当游戏比赛中当前玩家的得分变化时，都必须调用此方法。
 * For example, in many games this method is called when the player scores points, when the player is penalized, and whenever a
 * time bonus is applied. It is OK for this method to
 * be called very often.
 *
 * If a continuous in-game score is displayed to the player, this method is generally called as often as that score display is
 * updated - usually by placing the updatePlayersCurrentScore call in the same place within the game loop.
 *
 * @param currentScoreForPlayer Current score value for the player
 */
- (void)updatePlayersCurrentScore:(NSNumber *)currentScoreForPlayer;
/**
 * Call this function to report the player's score to GameCenter. Ends the current tournament, and returns the user to the GameCenter
 *  //MARK: 上传最终游戏比赛分数。
 * experience.
 *
 * @param score            Numeric value representing the player's final score
 * @param completion       Completion will be called on wrap up so that the developer can finish any ongoing processes, such as
 *                         saving game data or removing the game from the view hierarchy.
 */
- (void)displayTournamentResultsWithScore:(NSNumber *)score
                           withCompletion:(void (^)(void))completion;
/**
 * Call this function when a player aborts a GameCenter match in progress. Forfeits the match and brings the user back into the Skillz
 //MARK:处理正在游戏中的用户退出游戏的行为
 * experience.
 *
 * @param completion      Completion will be called on wrap up so that the developer can finish any ongoing processes, such as
 *                        saving game data or removing the game from the view hierarchy.
 */
- (void)notifyPlayerAbortWithCompletion:(void (^)(void))completion;

/**
 Deprecated, use
 //MARK: 初始化相关平台参数
 @param gameId 注册平台ID
 @param delegate Delegate responsible for handling GameCenter protocol call backs
 @param environment Environment to point the SDK to (Production or Sandbox)
 */
- (void)initWithGameId:(NSString *)gameId forDelegate:(id <GameCenterDelegate>)delegate
       withEnvironment:(GameCenterEnvironment)environment allowExit:(BOOL)allowExit;


@end
