///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBClientsManager.h"
#import "DBOAuth.h"
#import "DBOAuthResult.h"
#import "DBSDKKeychain.h"
#import "DBTeamClient.h"
#import "DBTransportDefaultClient.h"
#import "DBTransportDefaultConfig.h"
#import "DBUserClient.h"

@implementation DBClientsManager

static DBTransportDefaultConfig *currentTransportConfig;

static NSString *currentAppKey;

/// An authorized client. This will be set to `nil` if unlinked.
static DBUserClient *authorizedClient;

/// An authorized team client. This will be set to `nil` if unlinked.
static DBTeamClient *authorizedTeamClient;

+ (NSString *)appKey {
  return currentAppKey;
}

+ (void)setAppKey:(NSString *)appKey {
  currentAppKey = appKey;
}

+ (DBTransportDefaultConfig *)transportConfig {
  return currentTransportConfig;
}

+ (void)setTransportConfig:(DBTransportDefaultConfig *)transportConfig {
  currentTransportConfig = transportConfig;
}

+ (DBUserClient *)authorizedClient {
  @synchronized (self) {
    return authorizedClient;
  }
}

+ (void)setAuthorizedClient:(DBUserClient *)client {
  @synchronized (self) {
    authorizedClient = client;
  }
}

+ (DBTeamClient *)authorizedTeamClient {
  @synchronized (self) {
    return authorizedTeamClient;
  }
}

+ (void)setAuthorizedTeamClient:(DBTeamClient *)client {
  @synchronized (self) {
    authorizedTeamClient = client;
  }
}

+ (void)setupWithOAuthManager:(DBOAuthManager *)oAuthManager
              transportConfig:(DBTransportDefaultConfig *)transportConfig {
  NSAssert(![DBOAuthManager sharedOAuthManager], @"Only call `[DBClientsManager setupWith...]` once");

  [[self class] setupHelperWithOAuthManager:oAuthManager transportConfig:transportConfig];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getFirstAccessToken];
  NSLog(@"\n\n%@\n\n", accessToken.uid);
  [[self class] setupAuthorizedClient:accessToken];
}

+ (void)setupWithOAuthManagerMultiUser:(DBOAuthManager *)oAuthManager
                       transportConfig:(DBTransportDefaultConfig *)transportConfig
                              tokenUid:(NSString *)tokenUid {
  NSAssert(![DBOAuthManager sharedOAuthManager], @"Only call `[DBClientsManager setupWith...]` once");

  [[self class] setupHelperWithOAuthManager:oAuthManager transportConfig:transportConfig];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  [[self class] setupAuthorizedClient:accessToken];
}

+ (void)setupWithOAuthManagerTeam:(DBOAuthManager *)oAuthManager
                  transportConfig:(DBTransportDefaultConfig *)transportConfig {
  NSAssert(![DBOAuthManager sharedOAuthManager], @"Only call `[DBClientsManager setupWith...]` once");

  [[self class] setupHelperWithOAuthManager:oAuthManager transportConfig:transportConfig];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getFirstAccessToken];
  [[self class] setupAuthorizedTeamClient:accessToken];
}

+ (void)setupWithOAuthManagerTeamMultiUser:(DBOAuthManager *)oAuthManager
                           transportConfig:(DBTransportDefaultConfig *)transportConfig
                                  tokenUid:(NSString *)tokenUid {
  NSAssert(![DBOAuthManager sharedOAuthManager], @"Only call `[DBClientsManager setupWith...]` once");

  [[self class] setupHelperWithOAuthManager:oAuthManager transportConfig:transportConfig];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  [[self class] setupAuthorizedTeamClient:accessToken];
}

+ (void)setupHelperWithOAuthManager:(DBOAuthManager *)oAuthManager
                    transportConfig:(DBTransportDefaultConfig *)transportConfig {
  [DBOAuthManager setSharedOAuthManager:oAuthManager];
  [[self class] setTransportConfig:transportConfig];
  [[self class] setAppKey:transportConfig.appKey];
}

+ (BOOL)reauthorizeClient:(NSString *)tokenUid {
  NSAssert([DBOAuthManager sharedOAuthManager],
           @"Call the appropriate `[DBClientsManager setupWith...]` before calling this method");

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  if (accessToken) {
    DBUserClient *userClient = [[DBUserClient alloc] initWithAccessToken:accessToken.accessToken transportConfig:[DBClientsManager transportConfig]];
    [DBClientsManager setAuthorizedClient:userClient];
    return YES;
  }
  return NO;
}

+ (BOOL)reauthorizeTeamClient:(NSString *)tokenUid {
  NSAssert([DBOAuthManager sharedOAuthManager],
           @"Call the appropriate `[DBClientsManager setupWith...]` before calling this method");

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  if (accessToken) {
    DBTeamClient *teamClient = [[DBTeamClient alloc] initWithAccessToken:accessToken.accessToken transportConfig:[DBClientsManager transportConfig]];
    [DBClientsManager setAuthorizedTeamClient:teamClient];
    return YES;
  }
  return NO;
}

+ (void)setupAuthorizedClient:(DBAccessToken *)accessToken {
  if (accessToken) {
    DBTransportDefaultClient *transportClient =
        [[DBTransportDefaultClient alloc] initWithAccessToken:accessToken.accessToken
                                              transportConfig:[DBClientsManager transportConfig]];
    authorizedClient = [[DBUserClient alloc] initWithTransportClient:transportClient];
  }
}

+ (void)setupAuthorizedTeamClient:(DBAccessToken *)accessToken {
  if (accessToken) {
    DBTransportDefaultClient *transportClient =
        [[DBTransportDefaultClient alloc] initWithAccessToken:accessToken.accessToken
                                              transportConfig:[DBClientsManager transportConfig]];
    authorizedTeamClient = [[DBTeamClient alloc] initWithTransportClient:transportClient];
  }
}

+ (DBOAuthResult *)handleRedirectURL:(NSURL *)url {
  NSAssert([DBOAuthManager sharedOAuthManager],
           @"Call the appropriate `[DBClientsManager setupWith...]` before calling this method");

  DBOAuthResult *result = [[DBOAuthManager sharedOAuthManager] handleRedirectURL:url];

  if ([result isSuccess]) {
    NSString *accessToken = result.accessToken.accessToken;
    DBUserClient *userClient =
        [[DBUserClient alloc] initWithAccessToken:accessToken transportConfig:[DBClientsManager transportConfig]];
    [DBClientsManager setAuthorizedClient:userClient];
  }

  return result;
}

+ (DBOAuthResult *)handleRedirectURLTeam:(NSURL *)url {
  NSAssert([DBOAuthManager sharedOAuthManager],
           @"Call the appropriate `[DBClientsManager setupWith...]` before calling this method");

  DBOAuthResult *result = [[DBOAuthManager sharedOAuthManager] handleRedirectURL:url];

  if ([result isSuccess]) {
    NSString *accessToken = result.accessToken.accessToken;
    DBTeamClient *teamClient =
        [[DBTeamClient alloc] initWithAccessToken:accessToken transportConfig:[DBClientsManager transportConfig]];
    [DBClientsManager setAuthorizedTeamClient:teamClient];
  }

  return result;
}

+ (void)unlinkAndResetClients {
  if ([DBOAuthManager sharedOAuthManager]) {
    [[DBOAuthManager sharedOAuthManager] clearStoredAccessTokens];
    [[self class] resetClients];
  }
}

+ (void)resetClients {
  [DBClientsManager setAuthorizedClient:nil];
  [DBClientsManager setAuthorizedTeamClient:nil];
}

+ (BOOL)checkAndPerformV1TokenMigration:(DBTokenMigrationResponseBlock)responseBlock
                                  queue:(NSOperationQueue *)queue
                                 appKey:(NSString *)appKey
                              appSecret:(NSString *)appSecret {
  return [DBSDKKeychain checkAndPerformV1TokenMigration:responseBlock queue:queue appKey:appKey appSecret:appSecret];
}

@end
