//
//  _DCTAuthURLOpener.h
//  DCTAuth
//
//  Created by Daniel Tull on 31/08/2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTAuthResponse.h"

@interface _DCTAuthURLOpener : NSObject

+ (_DCTAuthURLOpener *)sharedURLOpener;

- (BOOL)handleURL:(NSURL *)URL;
- (id)openURL:(NSURL *)URL withCallbackURL:(NSURL *)callbackURL handler:(void (^)(DCTAuthResponse *response))handler;
- (void)close:(id)object;
@property (nonatomic, copy) BOOL (^URLOpener)(NSURL *URL);

@end
