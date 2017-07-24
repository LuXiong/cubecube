//
//  GSKYPlayer.h
//  GamesSkySDK
//
//  Created by xiaofeng xiao on 2017/6/23.
//  Copyright © 2017年 xiaofeng xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSKYPlayer : NSObject

/**
 * Player's unique id
 */
@property (readonly, nonnull) NSString *userid;

/**
 * Player's profile picture (or avatar) URL
 */
@property (readonly, nullable) NSString *avatarURL;

/**
 *  Player's display name
 */
@property (readonly, nonnull) NSString *displayName;

/**
 *  URL for the flag for the player
 */
@property (readonly, nullable) NSString *flagURL;


@end
