//
//  MFTestDefaults.m
//  Obsidian
//
//  Created by Michaël Fortin on 2013-08-22.
//  Copyright (c) 2013 Michaël Fortin. All rights reserved.
//

#import "MFTestDefaults.h"

@implementation MFTestDefaults

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

@dynamic dataDefault;
@dynamic stringDefault;
@dynamic numberDefault;
@dynamic dateDefault;
@dynamic arrayDefault;
@dynamic dictionaryDefault;

#if TARGET_OS_IPHONE
@dynamic imageDefault;
@dynamic colorDefault;
#endif
@dynamic URLDefault;

@dynamic objectDefault;

@end