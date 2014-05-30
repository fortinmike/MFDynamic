//
//  MFTestDefaults.h
//  MFDynamic
//
//  Created by Michaël Fortin on 2013-08-22.
//  Copyright (c) 2013 Michaël Fortin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFDynamicDefaults.h"
#import "MFNSCodingImplementer.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface MFTestDefaults : MFDynamicDefaults

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
#else
@property NSImage *nsImageValue;
@property NSColor *nsColorValue;
#endif

#pragma mark id

@property id objectValue;

@end