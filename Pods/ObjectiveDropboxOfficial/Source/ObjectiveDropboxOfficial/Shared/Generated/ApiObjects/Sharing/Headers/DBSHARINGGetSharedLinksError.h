///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGGetSharedLinksError;

#pragma mark - API Object

///
/// The `GetSharedLinksError` union.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGGetSharedLinksError : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBSHARINGGetSharedLinksErrorTag` enum type represents the possible tag
/// states with which the `DBSHARINGGetSharedLinksError` union can exist.
typedef NS_ENUM(NSInteger, DBSHARINGGetSharedLinksErrorTag) {
  /// (no description).
  DBSHARINGGetSharedLinksErrorPath,

  /// (no description).
  DBSHARINGGetSharedLinksErrorOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBSHARINGGetSharedLinksErrorTag tag;

/// (no description). @note Ensure the `isPath` method returns true before
/// accessing, otherwise a runtime exception will be raised.
@property (nonatomic, readonly, copy) NSString * _Nullable path;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "path".
///
/// @param path (no description).
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithPath:(NSString * _Nullable)path;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithOther;

- (nonnull instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "path".
///
/// @note Call this method and ensure it returns true before accessing the
/// `path` property, otherwise a runtime exception will be thrown.
///
/// @return Whether the union's current tag state has value "path".
///
- (BOOL)isPath;

///
/// Retrieves whether the union's current tag state has value "other".
///
/// @return Whether the union's current tag state has value "other".
///
- (BOOL)isOther;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString * _Nonnull)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DBSHARINGGetSharedLinksError` union.
///
@interface DBSHARINGGetSharedLinksErrorSerializer : NSObject

///
/// Serializes `DBSHARINGGetSharedLinksError` instances.
///
/// @param instance An instance of the `DBSHARINGGetSharedLinksError` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGGetSharedLinksError` API object.
///
+ (NSDictionary * _Nonnull)serialize:(DBSHARINGGetSharedLinksError * _Nonnull)instance;

///
/// Deserializes `DBSHARINGGetSharedLinksError` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGGetSharedLinksError` API object.
///
/// @return An instantiation of the `DBSHARINGGetSharedLinksError` object.
///
+ (DBSHARINGGetSharedLinksError * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end
