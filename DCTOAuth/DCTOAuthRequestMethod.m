//
//  _DCTOAuthRequestMethod.m
//  DCTOAuthController
//
//  Created by Daniel Tull on 24.08.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "DCTOAuthRequestMethod.h"

NSString * const DCTOAuthRequestMethodString[] = {
	@"GET",
	@"POST"
};

NSString * NSStringFromDCTOAuthRequestMethod(DCTOAuthRequestMethod method) {
	return DCTOAuthRequestMethodString[method];
}