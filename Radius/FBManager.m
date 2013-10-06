//
//  FBManager.m
//  Glamerous
//
//  Created by Siddhant Dange on 7/12/13.
//  Copyright (c) 2013 siddhantdange. All rights reserved.
//

#import "FBManager.h"

static FBManager *gInstance;
@implementation FBManager

#pragma -mark FB Content Acquisition

//fetch fb news feed with limits
-(void)fetchNewsFeedWithLowerLimit:(int)lowerLimit andNumItems:(int)numItems completionBlock:(void(^)(id result, NSError *error))completionBlock{
    
    NSString *fqlQuery = [NSString stringWithFormat:@"SELECT post_id, created_time, type, message, actor_id, description FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me() AND type='newsfeed')AND is_hidden = 0 LIMIT %d OFFSET %d", numItems, lowerLimit];
    NSLog(@"command: %@", fqlQuery);
    
    // Make the API request that uses FQL to gather posts
    [FBRequestConnection startWithGraphPath:@"/fql" parameters:[NSDictionary dictionaryWithObjectsAndKeys: fqlQuery, @"q", nil] HTTPMethod:@"GET"   completionHandler:^(FBRequestConnection *connection, id resultDict, NSError *error) {
        if(!error){
            completionBlock(resultDict, error);
        } else{
            NSLog(@"error gathering news feed: %@", error);
        }
     }];
}

-(void)fetchFriendsListWithCompletionBlock:(void(^)(id result, NSError *error))completionBlock{
    
    NSString *fqlQuery = [NSString stringWithFormat:@"SELECT name, birthday, email, uid FROM user WHERE uid in (SELECT uid2 FROM friend WHERE uid1  = me())"];
    NSLog(@"command: %@", fqlQuery);
    
    // Make the API request that uses FQL to gather posts
    [FBRequestConnection startWithGraphPath:@"/fql" parameters:[NSDictionary dictionaryWithObjectsAndKeys: fqlQuery, @"q", nil] HTTPMethod:@"GET"   completionHandler:^(FBRequestConnection *connection, id resultDict, NSError *error) {
        if(!error){
            completionBlock(resultDict, error);
        } else{
            NSLog(@"error gathering news feed: %@", error);
        }
    }];
}

-(void)fetchDataUsingFQLStr:(NSString*)fqlQuery completionBlock:(void(^)(id result, NSError *error))completionBlock{
    // Make the API request that uses FQL to gather posts
    [FBRequestConnection startWithGraphPath:@"/fql" parameters:[NSDictionary dictionaryWithObjectsAndKeys: fqlQuery, @"q", nil] HTTPMethod:@"GET"   completionHandler:^(FBRequestConnection *connection, id resultDict, NSError *error) {
        if(!error){
            completionBlock(resultDict, error);
        } else{
            NSLog(@"error gathering news feed: %@", error);
        }
    }];
}

#pragma -mark FB Account Management

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error withCompletionBlock:(void(^)(id<FBGraphUser> result, NSError *error))completionBlock{
    switch (state) {
        case FBSessionStateOpen: {
            self.fbSession = session;
            [self fetchMyInformationWithCompletionBlock:completionBlock];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            
            [FBSession.activeSession closeAndClearTokenInformation];
            NSLog(@"session wrong: %@", error);
            break;
        default:
            break;
    }
}

-(void)fetchMyInformationWithCompletionBlock:(void(^)(id result, NSError *error))completionBlock{
    [FBRequestConnection startWithGraphPath:@"/me" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(self.user == nil)
            self.user = result;
        completionBlock(result,error);
    }];
}

-(void)openSessionFromCacheWithCompletionBlock:(void(^)(id result, NSError *error))completionBlock{
    FBAccessTokenData *accessToken = [[FBSession activeSession] accessTokenData];
    
    self.fbSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:self.fbSession];
    
    [FBSession.activeSession openFromAccessTokenData:accessToken completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        self.fbSession = session;
        [self fetchMyInformationWithCompletionBlock:completionBlock];
    }];
}

-(void)openSessionWithMeWithCompletionBlock:(void(^)(id result, NSError* error))completionBlock{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"basic_info",
                            @"read_stream",
                            nil];
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler: ^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error withCompletionBlock:completionBlock];
    }];
}

-(BOOL)handleOpenUrl:(NSURL*)url{
    return [FBSession.activeSession handleOpenURL:url];
}

-(BOOL)checkFacebookLoggedIn{
    return (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded);
}

#pragma -mark singleton

+(FBManager *)initInstance{
    gInstance = [[FBManager alloc] init];
    
    //init mutable ivars here
    
    return gInstance;
}

+(FBManager *)sharedInstance{
    NSLog(@"instance: %@", gInstance);
    return gInstance;
}

@end
