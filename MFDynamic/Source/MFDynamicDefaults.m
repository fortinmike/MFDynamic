//
//  MFDynamicDefaults.m
//  MFDynamic
//
//  Created by Michaël Fortin on 2013-08-22.
//  Copyright (c) 2013 Michaël Fortin. All rights reserved.
//

#import "MFDynamicDefaults.h"

@implementation MFDynamicDefaults

#pragma mark Lifetime

+ (instancetype)sharedDefaults
{
	static dispatch_once_t pred;
	static MFDynamicDefaults *instance = nil;
	dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
	return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
		// Default ivar values
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark Other Public Methods

- (void)registerDefaults:(NSDictionary *)defaults
{
	// For user defaults, it is relevant to emit warnings for missing default property values
	// to prevent the developer from forgetting to specify a default value for some user defaults.
	[self registerDefaults:defaults emitMissingDefaultValueWarnings:NO];
}

- (void)registerDefaults:(NSDictionary *)defaults emitMissingDefaultValueWarnings:(BOOL)emitWarnings
{
	[_userDefaults registerDefaults:defaults];
	if (emitWarnings) [self checkForMissingValuesAndEmitWarnings];
}

- (void)synchronize
{
	[_userDefaults synchronize];
}

#pragma mark Superclass Template Methods Implementation

- (id)rawObjectForKey:(NSString *)key
{
	return [_userDefaults objectForKey:key];
}

- (void)setRawObject:(id)object forKey:(NSString *)key
{
	[_userDefaults setObject:object forKey:key];
}

- (BOOL)shouldEmitMissingValueWarningForProperty:(NSString *)propertyName
{
	// By default, MFDynamicDefaults emits warnings for all properties. Override this method and
	// return NO for properties for which you don't want to provide default values
	// to silence the warning for those properties only.
	return YES;
}

@end