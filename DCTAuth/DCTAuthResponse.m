//
//  DCTAuthResponse.m
//  DCTAuth
//
//  Created by Daniel Tull on 22.01.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTAuthResponse.h"
#import "NSString+DCTAuth.h"
#import "_DCTAuthXMLParser.h"

#ifdef TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@implementation DCTAuthResponse

- (id)initWithData:(NSData *)data URLResponse:(NSHTTPURLResponse *)response {
	self = [self init];
	if (!self) return nil;
	_data = data;
	_HTTPHeaders = response.allHeaderFields;
	_statusCode = response.statusCode;
	_contentObject = [self objectFromData:data contentType:response.MIMEType];
	return self;
}


- (id)objectFromData:(NSData *)data contentType:(NSString *)contentType {

	if ([contentType hasPrefix:@"application/x-www-form-urlencoded"])
		return [self dictionaryFromFormData:data];

	//if ([contentType hasPrefix:@"text/xml"])
	//	return [_DCTAuthXMLParser dictionaryFromXMLData:data];


	if ([@[@"application/json", @"text/json", @"text/javascript"] containsObject:contentType])
		return [self dictionaryFromJSONData:data];

	if ([@[@"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap"] containsObject:contentType])
		return [self imageFromData:data];

	return [self dictionaryFromFormData:data];
}

- (NSDictionary *)dictionaryFromFormData:(NSData *)data {
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return [string dctAuth_parameterDictionary];
}

- (NSDictionary *)dictionaryFromJSONData:(NSData *)data {
	return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}

- (UIImage *)imageFromData:(NSData *)data {
#ifdef TARGET_OS_IPHONE
	return [[UIImage alloc] initWithData:data];
#else
	return [[NSImage alloc] initWithData:data];
#endif
}




- (id)initWithURL:(NSURL *)URL {
	self = [self init];
	if (!self) return nil;
	_URL = [URL copy];

	NSMutableDictionary *content = [NSMutableDictionary new];
	[content addEntriesFromDictionary:[[URL query] dctAuth_parameterDictionary]];
	[content addEntriesFromDictionary:[[URL fragment] dctAuth_parameterDictionary]];
	_contentObject = [content copy];
	
	return self;
}

- (NSString *)description {

	NSString *URLString = @"";
	if (self.URL) URLString = [NSString stringWithFormat:@"\n%@", [self.URL absoluteString]];

	NSMutableString *headerString = [NSMutableString new];
	[self.HTTPHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
		[headerString appendFormat:@"\n%@: %@", key, value];
	}];

	NSString *bodyString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
	if (bodyString.length > 0) bodyString = [NSString stringWithFormat:@"\n\n%@", bodyString];
	else bodyString = @"";

	return [NSString stringWithFormat:@"<%@: %p>%@%@%@\n\n",
			NSStringFromClass([self class]),
			self,
			URLString,
			headerString,
			bodyString];
}

@end



