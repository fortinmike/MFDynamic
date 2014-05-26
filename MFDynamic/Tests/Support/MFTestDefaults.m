//
//  MFTestDefaults.m
//  MFDynamic
//
//  Created by Michaël Fortin on 2013-08-22.
//  Copyright (c) 2013 Michaël Fortin. All rights reserved.
//

#import "MFTestDefaults.h"

@implementation MFTestDefaults

#pragma mark Value Types

@dynamic boolDefault;
@dynamic charDefault;
@dynamic intDefault;
@dynamic shortDefault;
@dynamic longDefault;
@dynamic longLongDefault;
@dynamic unsignedCharDefault;
@dynamic unsignedIntDefault;
@dynamic unsignedShortDefault;
@dynamic unsignedLongDefault;
@dynamic unsignedLongLongDefault;
@dynamic floatDefault;
@dynamic doubleDefault;

#pragma mark NSUserDefaults-Supported Types

@dynamic dataDefault;
@dynamic stringDefault;
@dynamic numberDefault;
@dynamic dateDefault;
@dynamic arrayDefault;
@dynamic dictionaryDefault;

#pragma mark NSCoding-Conforming Types

@dynamic urlDefault;

#if TARGET_OS_IPHONE
@dynamic uiImageDefault;
@dynamic uiColorDefault;
#endif

#pragma mark id

@dynamic objectDefault;

@end