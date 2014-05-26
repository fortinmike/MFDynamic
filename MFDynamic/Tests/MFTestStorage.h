//
//  MFTestStorage.h
//  Obsidian
//
//  Created by Michaël Fortin on 11/30/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import "MFNSCodingImplementer.h"
#import "MFDynamicStorage.h"

@interface MFTestStorage : MFDynamicStorage

@property NSString *string;
@property NSUInteger integer;
@property MFNSCodingImplementer *nsCodingImplementer;

@end