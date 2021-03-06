//
//  MFTestStorage.m
//  MFDynamic
//
//  Created by Michaël Fortin on 11/30/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import "MFTestStorage.h"

@implementation MFTestStorage

#pragma mark Value Types

@dynamic boolValue;
@dynamic charValue;
@dynamic intValue;
@dynamic shortValue;
@dynamic longValue;
@dynamic longLongValue;
@dynamic unsignedCharValue;
@dynamic unsignedIntValue;
@dynamic unsignedShortValue;
@dynamic unsignedLongValue;
@dynamic unsignedLongLongValue;
@dynamic floatValue;
@dynamic doubleValue;

#pragma mark NSUserValues-Supported Types

@dynamic dataValue;
@dynamic stringValue;
@dynamic numberValue;
@dynamic dateValue;
@dynamic arrayValue;
@dynamic dictionaryValue;

#pragma mark NSCoding-Conforming Types

@dynamic urlValue;
@dynamic nsCodingImplementer;

#if TARGET_OS_IPHONE
@dynamic uiImageValue;
@dynamic uiColorValue;
#else
@dynamic nsImageValue;
@dynamic nsColorValue;
#endif

#pragma mark id

@dynamic objectValue;

@end