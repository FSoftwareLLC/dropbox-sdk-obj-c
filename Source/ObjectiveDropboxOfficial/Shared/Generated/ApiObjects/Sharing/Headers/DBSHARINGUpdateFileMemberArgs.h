///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSHARINGChangeFileMemberAccessArgs.h"
#import "DBSerializableProtocol.h"

@class DBSHARINGAccessLevel;
@class DBSHARINGMemberSelector;
@class DBSHARINGUpdateFileMemberArgs;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `UpdateFileMemberArgs` struct.
///
/// Arguments for `updateFileMember`.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGUpdateFileMemberArgs : DBSHARINGChangeFileMemberAccessArgs <DBSerializable, NSCopying>

#pragma mark - Instance fields

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param file File for which we are changing a member's access.
/// @param member The member whose access we are changing.
/// @param accessLevel The new access level for the member.
///
/// @return An initialized instance.
///
- (instancetype)initWithFile:(NSString *)file
                      member:(DBSHARINGMemberSelector *)member
                 accessLevel:(DBSHARINGAccessLevel *)accessLevel;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `UpdateFileMemberArgs` struct.
///
@interface DBSHARINGUpdateFileMemberArgsSerializer : NSObject

///
/// Serializes `DBSHARINGUpdateFileMemberArgs` instances.
///
/// @param instance An instance of the `DBSHARINGUpdateFileMemberArgs` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGUpdateFileMemberArgs` API object.
///
+ (NSDictionary *)serialize:(DBSHARINGUpdateFileMemberArgs *)instance;

///
/// Deserializes `DBSHARINGUpdateFileMemberArgs` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGUpdateFileMemberArgs` API object.
///
/// @return An instantiation of the `DBSHARINGUpdateFileMemberArgs` object.
///
+ (DBSHARINGUpdateFileMemberArgs *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
