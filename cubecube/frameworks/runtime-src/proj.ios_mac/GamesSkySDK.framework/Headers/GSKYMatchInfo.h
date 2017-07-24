//
//  GSKYMatchInfo.h
//  GamesSkySDK
//
//  Created by xiaofeng xiao on 2017/6/23.
//  Copyright © 2017年 xiaofeng xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSKYPlayer.h"

@interface GSKYMatchInfo : NSObject

/**
 * Unique match id
 */
@property (readonly) NSInteger matchUserid;

/**
 * Match description as configured in the GameCenter Developer Portal
 */
@property (readonly, nullable) NSString *matchDescription;

/**
 * Cash entry fee, nil if there is none
 */
@property (readonly, nullable) NSNumber *entryCash;

/**
 * Z points entry fee, nil if there is none
 */
@property (readonly, nullable) NSNumber *entryPoints;

/**
 * Signifies a cash match
 */
@property (readonly) BOOL isCash;

/**
 *  Match name as configured in the GameCenter Developer Portal
 */
@property (readonly, nonnull) NSString *name;

/**
 * Current player in match
 */
@property (readonly, nonnull) GSKYPlayer *player;

/**
 * Template id for the template that the match is based on. These templates are
 * configured in the GameCenter Developer Portal
 */
@property (readonly, nonnull) NSNumber *templateId;

@end
