//
//  MFDynamicDefaults.h
//  MFDynamic
//
//  Created by Michaël Fortin on 2013-08-22.
//  Copyright (c) 2013 Michaël Fortin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFDynamicBase.h"

/**
 *  This is an abstract class meant to be subclassed and used instead of NSUserDefaults to
 *  store and retrieve values from the user defaults system. It provides access to user defaults
 *  through strongly typed, dynamically-implemented properties (as defined in your MFDynamicDefaults
 *  subclass) as opposed to key-based access and type-specific methods for each value type
 *  (such as -[NSUserDefaults boolForKey:]).
 */
@interface MFDynamicDefaults : MFDynamicBase
{
	@public
	NSUserDefaults *_userDefaults;
}

#pragma mark Lifetime

+ (instancetype)sharedDefaults;

#pragma mark Other Public Methods

/**
 *  Registers defaults, just like -[NSUserDefaults registerDefaults:]. Emits warnings for missing default values,
 *  that is for properties that do not have a corresponding value in the provided defaults dictionary.
 *
 *  @param defaults The defaults to register.
 */
- (void)registerDefaults:(NSDictionary *)defaults;

/**
 *  Registers defaults, just like -[NSUserDefaults registerDefaults:].
 *
 *  @param defaults     The defaults to register.
 *  @param emitWarnings Whether to emit warnings for missing default values or not.
 */
- (void)registerDefaults:(NSDictionary *)defaults emitMissingDefaultValueWarnings:(BOOL)emitWarnings;
- (void)synchronize;

@end