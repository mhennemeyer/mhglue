//
//  MHModel.h
//
//  Copyright (c) 2013 Matthias Hennemeyer. All rights reserved.
//  License: MIT. Source: github...
//

#import <Foundation/Foundation.h>

#define emptyStringIfNil(string) string==nil ? @"" : string

@interface MHModel : NSObject

@property (readonly) id json;

#pragma mark - Init
- (id)initFromJson:(id)json;


@end
