//
//  MFDynamicBase.m
//  Obsidian
//
//  Created by Michaël Fortin on 11/19/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import <MARTNSObject.h>
#import <RTProperty.h>
#import <RTMethod.h>
#import "MFDynamicBase.h"
#import "NSString+Additions.h"
#import "NSException+Additions.h"
#import "MFFoundation.h"
#import "MFHumanReadableConverter.h"
#import "NSString+Regexer.h"

@implementation MFDynamicBase

#pragma mark Lifetime

+ (instancetype)sharedDefaults
{
	static dispatch_once_t pred;
	static MFDynamicBase *instance = nil;
	dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
	return instance;
}

+ (void)initialize
{
	// TODO: Make sure this runs only once per subclass or that there is
	// no side-effect if this runs more than once as +initialize is not
	// guaranteed to be called only once.
	
	// Read: http://stackoverflow.com/questions/14110396/initialize-called-more-than-once
	[self implementDefaults];
}

#pragma mark Implementation

+ (void)implementDefaults
{
	NSArray *properties = [[self class] rt_properties];
	
	for (RTProperty *property in properties)
	{
		if ([property isDynamic])
			[self implementProperty:property];
	}
}

+ (void)implementProperty:(RTProperty *)property
{
	[self implementGetterForProperty:property];
	if (![property isReadOnly]) [self implementSetterForProperty:property];
}

+ (void)implementGetterForProperty:(RTProperty *)property
{
	SEL sel = [self getterSelectorForProperty:property];
	IMP imp = [self getterImplementationForProperty:property];
	[self rt_addMethod:[RTMethod methodWithSelector:sel implementation:imp signature:[property typeEncoding]]];
}

+ (void)implementSetterForProperty:(RTProperty *)property
{
	SEL sel = [self setterSelectorForProperty:property];
	IMP imp = [self setterImplementationForProperty:property];
	[self rt_addMethod:[RTMethod methodWithSelector:sel implementation:imp signature:[property typeEncoding]]];
}

// For a list of possible type encodings in Objective-C, read:
// https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100

+ (IMP)getterImplementationForProperty:(RTProperty *)property
{
	NSString *key = [self keyForProperty:property];
	
	if ([self isProperty:property ofType:@encode(char)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] charValue]; });
	
	if ([self isProperty:property ofType:@encode(int)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] intValue]; });
	
	if ([self isProperty:property ofType:@encode(short)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] shortValue]; });
	
	if ([self isProperty:property ofType:@encode(long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] longValue]; });
	
	if ([self isProperty:property ofType:@encode(long long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] longLongValue]; });
	
	if ([self isProperty:property ofType:@encode(unsigned char)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] unsignedCharValue]; });
	
	if ([self isProperty:property ofType:@encode(unsigned int)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] unsignedIntValue]; });
	
	if ([self isProperty:property ofType:@encode(unsigned short)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] unsignedShortValue]; });
	
	if ([self isProperty:property ofType:@encode(unsigned long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] unsignedLongValue]; });
	
	if ([self isProperty:property ofType:@encode(unsigned long long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] unsignedLongLongValue]; });
	
	if ([self isProperty:property ofType:@encode(float)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] floatValue]; });
	
	if ([self isProperty:property ofType:@encode(double)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] doubleValue]; });
	
	if ([self isProperty:property ofType:@encode(BOOL)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf objectForKey:key] boolValue]; });
	
	if ([self isObject:property])
	{
		if ([self isKindOfPropertyArchivableAsIs:property] || [self isProperty:property ofType:@encode(id)])
		{
			return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [iSelf objectForKey:key]; });
		}
		else if ([self isProperty:property ofKind:[NSURL class]])
		{
			return imp_implementationWithBlock(^(MFDynamicBase *iSelf)
			{
				return [MFHumanReadableConverter convertFromHumanReadable:[iSelf objectForKey:key] withTargetType:[NSURL class]];
			});
		}
#if TARGET_OS_IPHONE
		else if ([self isProperty:property ofKind:[UIColor class]])
		{
			return imp_implementationWithBlock(^(MFDynamicBase *iSelf)
			{
				return [MFHumanReadableConverter convertFromHumanReadable:[iSelf objectForKey:key] withTargetType:[UIColor class]];
			});
		}
#endif
		else if ([self propertyObjectTypeImplementsNSCoding:property])
		{
			return imp_implementationWithBlock(^(MFDynamicBase *iSelf)
		    {
				NSData *data = [iSelf objectForKey:key];
			    if (![data isKindOfClass:[NSData class]]) return (id)nil;
			    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
			});
		}
	}
	
	@throw [self unsupportedTypeExceptionForProperty:property];
}

+ (IMP)setterImplementationForProperty:(RTProperty *)property
{
	NSString *key = [self keyForProperty:property];
	
	if ([self isProperty:property ofType:@encode(char)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, char value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(int)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, int value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(short)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, short value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, long value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(long long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, long long value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(unsigned char)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, unsigned char value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(unsigned int)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, unsigned int value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(unsigned short)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, unsigned short value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(unsigned long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, unsigned long value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(unsigned long long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, unsigned long long value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(float)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, float value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(double)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, double value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isProperty:property ofType:@encode(BOOL)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, BOOL value) { return [iSelf setObject:@(value) forKey:key]; });
	
	if ([self isObject:property])
	{
		if ([self isKindOfPropertyArchivableAsIs:property] || [self isProperty:property ofType:@encode(id)])
		{
			return imp_implementationWithBlock(^(MFDynamicBase *iSelf, id value) { [iSelf setObject:value forKey:key]; });
		}
		else if ([self isProperty:property ofKind:[NSURL class]])
		{
			return imp_implementationWithBlock(^(MFDynamicBase *iSelf, NSURL *url)
			{
				[iSelf setObject:[MFHumanReadableConverter convertToHumanReadable:url] forKey:key];
			});
		}
#if TARGET_OS_IPHONE
		else if ([self isProperty:property ofKind:[UIColor class]])
		{
			return imp_implementationWithBlock(^(MFDynamicBase *iSelf, UIColor *color)
			{
				[iSelf setObject:[MFHumanReadableConverter convertToHumanReadable:color] forKey:key];
			});
		}
#endif
		else if ([self propertyObjectTypeImplementsNSCoding:property])
		{
			return imp_implementationWithBlock(^(MFDynamicBase *iSelf, id value)
		    {
				NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
				[iSelf setObject:data forKey:key];
			});
		}
	}
	
	if ([self isObject:property])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, id value) { return [iSelf setObject:value forKey:key]; });
	
	@throw [self unsupportedTypeExceptionForProperty:property];
}

+ (BOOL)isProperty:(RTProperty *)property ofType:(const char *)type
{
	return strcmp([[property typeEncoding] UTF8String], type) == 0;
}

+ (BOOL)isProperty:(RTProperty *)property ofKind:(Class)kind
{
	return [[self classOfProperty:property] isSubclassOfClass:kind];
}

+ (BOOL)isObject:(RTProperty *)property
{
	return [[property typeEncoding] hasPrefix:@"@"];
}

+ (BOOL)isKindOfPropertyArchivableAsIs:(RTProperty *)property
{
	// Note: NSUserDefaults supports NSData, NSString, NSNumber, NSDate, NSArray and NSDictionary
	// https://developer.apple.com/library/ios/DOCUMENTATION/Cocoa/Reference/Foundation/Classes/NSUserDefaults_Class/Reference/Reference.html
	
	Class class = [self classOfProperty:property];
	if ([class isSubclassOfClass:[NSData class]]) return YES;
	if ([class isSubclassOfClass:[NSString class]]) return YES;
	if ([class isSubclassOfClass:[NSNumber class]]) return YES;
	if ([class isSubclassOfClass:[NSDate class]]) return YES;
	if ([class isSubclassOfClass:[NSArray class]]) return YES;
	if ([class isSubclassOfClass:[NSDictionary class]]) return YES;
	
	return NO;
}

+ (BOOL)propertyObjectTypeImplementsNSCoding:(RTProperty *)property
{
	Class class = [self classOfProperty:property];
	return (class && [class conformsToProtocol:@protocol(NSCoding)]);
}

+ (Class)classOfProperty:(RTProperty *)property
{
	return NSClassFromString([[[property typeEncoding] rx_textsForGroup:1 withPattern:@"@\"([A-Za-z]*)\""] firstObject]);
}

+ (NSString *)keyForProperty:(RTProperty *)property
{
	NSString *propertyName = [property name];
	NSString *capitalizedFirstLetter = [[propertyName substringToIndex:1] uppercaseString];
	return [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:capitalizedFirstLetter];
}

+ (SEL)getterSelectorForProperty:(RTProperty *)property
{
	return NSSelectorFromString([property name]);
}

+ (SEL)setterSelectorForProperty:(RTProperty *)property
{
	const char *rawPropertyName = [[property name] UTF8String];
	return NSSelectorFromString([NSString stringWithFormat:@"set%c%s:", toupper(rawPropertyName[0]), (rawPropertyName + 1)]);
}

+ (NSException *)unsupportedTypeExceptionForProperty:(RTProperty *)property
{
	return [NSException exceptionWithReason:@"Unsupported type encoding '%@' for dynamic property key '%@'. See https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100 for possible type encoding and add support to MFDynamicBase if required.", [property typeEncoding], [self keyForProperty:property]];
}

#pragma mark Loading

- (void)loadValues:(NSDictionary *)values
{
	// By default we don't emit warnings; we don't know if its relevant here,
	// that depends on the backing store that's going to be used in our concrete subclass.
	[self loadValues:values emitMissingValueWarnings:NO];
}

- (void)loadValues:(NSDictionary *)values emitMissingValueWarnings:(BOOL)emitWarnings
{
	// Load values using the template method (because we know nothing of the backing store)
	for (NSString *key in [values allKeys])
		[self setObject:values[key] forKey:key];
	
	// Emit warnings for any dynamic property that doesn't have a default value
	// in the given dictionary. Useful to make sure we don't forget to set a default
	// value for a property when loading values. Warnings can be disabled
	// per-property using the appropriate template method.
	if (emitWarnings) [self checkForMissingValuesAndEmitWarnings];
}

#pragma mark Implementation

- (void)checkForMissingValuesAndEmitWarnings
{
	for (RTProperty *property in [[self class] rt_properties])
	{
		NSString *key = [[self class] keyForProperty:property];
		NSString *propertyName = [property name];
		
		BOOL valueMissing = ([self objectForKey:key] == nil);
		BOOL shouldEmitWarningForProperty = [self shouldEmitMissingValueWarningWhenLoading:propertyName];
		
		if (valueMissing && shouldEmitWarningForProperty)
			MFLogWarn(@"Missing value for key %@ to fill property \"%@\"", key, propertyName);
	}
}

#pragma mark Template Methods

- (id)objectForKey:(NSString *)key
{
	@throw [NSException exceptionWithReason:@"No backing store; this is an abstract class"];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
	@throw [NSException exceptionWithReason:@"No backing store; this is an abstract class"];
}

- (BOOL)shouldEmitMissingValueWarningWhenLoading:(NSString *)propertyName
{
	return NO;
}

@end