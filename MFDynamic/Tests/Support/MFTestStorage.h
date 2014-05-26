//
//  MFTestStorage.h
//  Obsidian
//
//  Created by Michaël Fortin on 11/30/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import "MFNSCodingImplementer.h"
#import "MFDynamicStorage.h"
#import "MFNSCodingImplementer.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface MFTestStorage : MFDynamicStorage

#pragma mark Value Types

@property BOOL boolValue;
@property char charValue;
@property int intValue;
@property short shortValue;
@property long longValue;
@property long long longLongValue;
@property unsigned char unsignedCharValue;
@property unsigned int unsignedIntValue;
@property unsigned short unsignedShortValue;
@property unsigned long unsignedLongValue;
@property unsigned long long unsignedLongLongValue;
@property float floatValue;
@property double doubleValue;

#pragma mark NSUserValues-Supported Types

@property NSData *dataValue;
@property NSString *stringValue;
@property NSNumber *numberValue;
@property NSDate *dateValue;
@property NSArray *arrayValue;
@property NSDictionary *dictionaryValue;

#pragma mark NSCoding-Conforming Types

@property NSURL *urlValue;
@property MFNSCodingImplementer *nsCodingImplementer;

#if TARGET_OS_IPHONE
@property UIImage *uiImageValue;
@property UIColor *uiColorValue;
#endif

#pragma mark id

@property id objectValue;

@end