///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBPAPERRefPaperDoc.h"
#import "DBSerializableProtocol.h"

@class DBPAPERExportFormat;
@class DBPAPERPaperDocExport;

#pragma mark - API Object

///
/// The `PaperDocExport` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBPAPERPaperDocExport : DBPAPERRefPaperDoc <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// (no description).
@property (nonatomic, readonly) DBPAPERExportFormat * _Nonnull exportFormat;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param docId (no description).
/// @param exportFormat (no description).
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithDocId:(NSString * _Nonnull)docId
                         exportFormat:(DBPAPERExportFormat * _Nonnull)exportFormat;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `PaperDocExport` struct.
///
@interface DBPAPERPaperDocExportSerializer : NSObject

///
/// Serializes `DBPAPERPaperDocExport` instances.
///
/// @param instance An instance of the `DBPAPERPaperDocExport` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBPAPERPaperDocExport` API object.
///
+ (NSDictionary * _Nonnull)serialize:(DBPAPERPaperDocExport * _Nonnull)instance;

///
/// Deserializes `DBPAPERPaperDocExport` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBPAPERPaperDocExport` API object.
///
/// @return An instantiation of the `DBPAPERPaperDocExport` object.
///
+ (DBPAPERPaperDocExport * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end
