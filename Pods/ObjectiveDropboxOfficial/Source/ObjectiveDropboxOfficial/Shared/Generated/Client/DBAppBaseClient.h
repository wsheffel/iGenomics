///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBAUTHAppAuthRoutes.h"
#import "DBRequestErrors.h"
#import "DBTasks.h"

@protocol DBTransportClient;

///
/// Base client object that contains an instance field for each namespace, each
/// of which contains references to all routes within that namespace.
/// Fully-implemented API clients will inherit this class.
///
@interface DBAppBaseClient : NSObject {

@protected
  id<DBTransportClient> _Nonnull _transportClient;
}

/// Routes within the `auth` namespace.
@property (nonatomic, readonly) DBAUTHAppAuthRoutes * _Nonnull authRoutes;

/// Initializes the `DBAppBaseClient` object with a networking client.
- (nonnull instancetype)initWithTransportClient:(id<DBTransportClient> _Nonnull)client;

@end
