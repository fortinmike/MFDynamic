//
//  MFDynamicBase.h
//  MFDynamic
//
//  Created by Michaël Fortin on 11/19/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTProperty;

@interface MFDynamicBase : NSObject

#pragma mark Loading

- (void)loadValues:(NSDictionary *)values;
- (void)loadValues:(NSDictionary *)values emitMissingValueWarnings:(BOOL)emitWarnings;

#pragma mark Implementation

- (void)checkForMissingValuesAndEmitWarnings;

#pragma mark Template Methods

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;

// By default, emits no warnings. Override and return yes if you
// want to benefit from this behavior in your subclass.
- (BOOL)shouldEmitMissingValueWarningWhenLoading:(NSString *)propertyName;

@end