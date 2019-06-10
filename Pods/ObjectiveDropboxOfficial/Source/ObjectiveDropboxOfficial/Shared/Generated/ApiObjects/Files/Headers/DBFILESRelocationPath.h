///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBFILESRelocationPath;

#pragma mark - API Object

///
/// The `RelocationPath` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBFILESRelocationPath : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Path in the user's Dropbox to be copied or moved.
@property (nonatomic, readonly, copy) NSString * _Nonnull fromPath;

/// Path in the user's Dropbox that is the destination.
@property (nonatomic, readonly, copy) NSString * _Nonnull toPath;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param fromPath Path in the user's Dropbox to be copied or moved.
/// @param toPath Path in the user's Dropbox that is the destination.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithFromPath:(NSString * _Nonnull)fromPath toPath:(NSString * _Nonnull)toPath;

- (nonnull instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `RelocationPath` struct.
///
@interface DBFILESRelocationPathSerializer : NSObject

///
/// Serializes `DBFILESRelocationPath` instances.
///
/// @param instance An instance of the `DBFILESRelocationPath` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBFILESRelocationPath` API object.
///
+ (NSDictionary * _Nonnull)serialize:(DBFILESRelocationPath * _Nonnull)instance;

///
/// Deserializes `DBFILESRelocationPath` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBFILESRelocationPath` API object.
///
/// @return An instantiation of the `DBFILESRelocationPath` object.
///
+ (DBFILESRelocationPath * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end
