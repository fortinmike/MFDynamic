//
//  MFDynamicBase.h
//  MFDynamic
//
//  Created by Michaël Fortin on 11/19/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Base class for dynamic objects. Subclass this and implement template methods to
 *  provide a custom backing store as required.
 */
@interface MFDynamicBase : NSObject

#pragma mark Loading

/**
 *  Same as loadValues:emitMissingValueWarnings: but will never emit warnings for missing values.
 *
 *  @param values The keys and values to load.
 */
- (void)loadValues:(NSDictionary *)values;

/**
 *  Loads a set of keys and values in the backing store. Because this method calls the
 *  setRawObject:forKey: template method, it works with whatever backing store you implement.
 *  Keys must match the *Key Specification* for the dynamic properties to map properly
 *  to the provided values.
 *
 *  You can also specify whether you want MFDynamicBase to emit warnings when the provided values
 *  dictionary does not contain a value for each of the dynamic properties. This is useful to
 *  make sure you don't forget to set a default value for a property when loading values from disk,
 *  which is especially useful for User Defaults (see MFDynamicDefaults). Warnings can be disabled
 *  per-property using the appropriate template method.
 *
 *  @param values The keys and values to load.
 *  @param emitWarnings Whether to emit warnings or not when some dynamic properties have no corresponding key in the values dictionary.
 */
- (void)loadValues:(NSDictionary *)values emitMissingValueWarnings:(BOOL)emitWarnings;

#pragma mark Implementation

- (void)checkForMissingValuesAndEmitWarnings;

#pragma mark Template Methods

/**
 *  Obtains the raw object for the given key from the backing store.
 *
 *  - You must override this method in your MFDynamicBase subclass.
 *  - The raw object may or may not be of the same class as the corresponding property.
 *  - The base class' implementation does nothing (throws).
 *  - You should not call this method directly; it is called internally with the proper keys by MFDynamicDefaults.
 *
 *  @param key The key of the object to retrieve (according to the *Key Specification*, as provided when MFDynamicDefaults calls this method).
 *
 *  @return You should return the appropriate value for the given key, as retrieved from the backing store.
 */
- (id)rawObjectForKey:(NSString *)key;

/**
 *  Sets the object for the given key in the backing store.
 *  
 *  - You must override this method in your MFDynamicBase subclass.
 *  - The base class' implementation does nothing (throws).
 *  - You should not call this method directly; it is called internally with the proper keys by MFDynamicDefaults.
 *
 *  @param object The raw object to store in the backing store.
 *  @param key The key with which to store the object (according to the *Key Specification*, as provided when MFDynamicDefault calls this method).
 *  @param propertyName The name of the property that will change. Useful to trigger change notifications for bindings support.
 */
- (void)setRawObject:(id)object forKey:(NSString *)key propertyName:(NSString *)propertyName;

/**
 *  By default, emits warnings for all properties (if warning emission is enabled).
 *  Override and return NO for properties for which having no value loaded is OK.
 *  This enables you to benefit from the missing value warning behavior in a more
 *  granular manner, disabling it selectively for specific properties.
 *
 *  @param propertyName The name of the property that MFDynamicBase would like to load.
 *
 *  @return Whether to emit a warning or not if there is no value to load for that property.
 */
- (BOOL)shouldEmitMissingValueWarningForProperty:(NSString *)propertyName;

@end