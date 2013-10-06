//
//  FBManager.h
//  Flight
//
//  Created by Siddhant Dange on 7/18/13.
//  Copyright (c) 2013 siddhantdange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBManager : NSObject

@property (nonatomic, strong) FBSession *fbSession;
@property (nonatomic, strong) id<FBGraphUser> user;



-(void)openSessionFromCacheWithCompletionBlock:(void(^)(id result, NSError *error))completionBlock;
-(void)fetchFriendsListWithCompletionBlock:(void(^)(id result, NSError *error))completionBlock;


-(void)openSessionWithMeWithCompletionBlock:(void(^)(id result, NSError* error))completionBlock;

#pragma -mark abstract methods

-(void)fetchDataUsingFQLStr:(NSString*)fqlQuery completionBlock:(void(^)(id result, NSError *error))completionBlock;

#pragma -mark dont touch

-(BOOL)checkFacebookLoggedIn;
-(BOOL)handleOpenUrl:(NSURL*)url;

#pragma -mark singleton

+(FBManager*)initInstance;
+(FBManager*)sharedInstance;

@end
