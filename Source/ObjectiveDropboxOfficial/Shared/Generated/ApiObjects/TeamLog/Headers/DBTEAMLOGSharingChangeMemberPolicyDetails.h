///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGExternalSharingPolicy;
@class DBTEAMLOGSharingChangeMemberPolicyDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SharingChangeMemberPolicyDetails` struct.
///
/// Changed whether team members can share files and folders externally (i.e.
/// outside the team).
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGSharingChangeMemberPolicyDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// New external invite policy.
@property (nonatomic, readonly) DBTEAMLOGExternalSharingPolicy *dNewValue;

/// Previous external invite policy. Might be missing due to historical data
/// gap.
@property (nonatomic, readonly, nullable) DBTEAMLOGExternalSharingPolicy *previousValue;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param dNewValue New external invite policy.
/// @param previousValue Previous external invite policy. Might be missing due
/// to historical data gap.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGExternalSharingPolicy *)dNewValue
                    previousValue:(nullable DBTEAMLOGExternalSharingPolicy *)previousValue;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param dNewValue New external invite policy.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGExternalSharingPolicy *)dNewValue;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `SharingChangeMemberPolicyDetails` struct.
///
@interface DBTEAMLOGSharingChangeMemberPolicyDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGSharingChangeMemberPolicyDetails` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGSharingChangeMemberPolicyDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGSharingChangeMemberPolicyDetails` API object.
///
+ (NSDictionary *)serialize:(DBTEAMLOGSharingChangeMemberPolicyDetails *)instance;

///
/// Deserializes `DBTEAMLOGSharingChangeMemberPolicyDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGSharingChangeMemberPolicyDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGSharingChangeMemberPolicyDetails`
/// object.
///
+ (DBTEAMLOGSharingChangeMemberPolicyDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
