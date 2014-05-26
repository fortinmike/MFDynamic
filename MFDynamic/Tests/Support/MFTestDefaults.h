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

@property BOOL boolDefault;
@property char charDefault;
@property int intDefault;
@property short shortDefault;
@property long longDefault;
@property long long longLongDefault;
@property unsigned char unsignedCharDefault;
@property unsigned int unsignedIntDefault;
@property unsigned short unsignedShortDefault;
@property unsigned long unsignedLongDefault;
@property unsigned long long unsignedLongLongDefault;
@property float floatDefault;
@property double doubleDefault;

#pragma mark NSUserDefaults-Supported Types

@property NSData *dataDefault;
@property NSString *stringDefault;
@property NSNumber *numberDefault;
@property NSDate *dateDefault;
@property NSArray *arrayDefault;
@property NSDictionary *dictionaryDefault;

#pragma mark NSCoding-Conforming Types

@property NSURL *urlDefault;
@property MFNSCodingImplementer *nsCodingImplementer;

#if TARGET_OS_IPHONE
@property UIImage *uiImageDefault;
@property UIColor *uiColorDefault;
#endif

#pragma mark id

@property id objectDefault;

@end