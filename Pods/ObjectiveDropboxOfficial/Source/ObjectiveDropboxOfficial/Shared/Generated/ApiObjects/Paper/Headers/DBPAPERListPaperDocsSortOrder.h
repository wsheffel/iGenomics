///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBPAPERListPaperDocsSortOrder;

#pragma mark - API Object

///
/// The `ListPaperDocsSortOrder` union.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBPAPERListPaperDocsSortOrder : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBPAPERListPaperDocsSortOrderTag` enum type represents the possible tag
/// states with which the `DBPAPERListPaperDocsSortOrder` union can exist.
typedef NS_ENUM(NSInteger, DBPAPERListPaperDocsSortOrderTag) {
  /// Sorts the search result in ascending order.
  DBPAPERListPaperDocsSortOrderAscending,

  /// Sorts the search result in descending order.
  DBPAPERListPaperDocsSortOrderDescending,

  /// (no description).
  DBPAPERListPaperDocsSortOrderOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBPAPERListPaperDocsSortOrderTag tag;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "ascending".
///
/// Description of the "ascending" tag state: Sorts the search result in
/// ascending order.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAscending;

///
/// Initializes union class with tag state of "descending".
///
/// Description of the "descending" tag state: Sorts the search result in
/// descending order.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithDescending;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithOther;

- (nonnull instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "ascending".
///
/// @return Whether the union's current tag state has value "ascending".
///
- (BOOL)isAscending;

///
/// Retrieves whether the union's current tag state has value "descending".
///
/// @return Whether the union's current tag state has value "descending".
///
- (BOOL)isDescending;

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
/// The serialization class for the `DBPAPERListPaperDocsSortOrder` union.
///
@interface DBPAPERListPaperDocsSortOrderSerializer : NSObject

///
/// Serializes `DBPAPERListPaperDocsSortOrder` instances.
///
/// @param instance An instance of the `DBPAPERListPaperDocsSortOrder` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBPAPERListPaperDocsSortOrder` API object.
///
+ (NSDictionary * _Nonnull)serialize:(DBPAPERListPaperDocsSortOrder * _Nonnull)instance;

///
/// Deserializes `DBPAPERListPaperDocsSortOrder` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBPAPERListPaperDocsSortOrder` API object.
///
/// @return An instantiation of the `DBPAPERListPaperDocsSortOrder` object.
///
+ (DBPAPERListPaperDocsSortOrder * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end
