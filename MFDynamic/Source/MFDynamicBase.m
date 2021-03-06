//
//  MFDynamicBase.m
//  MFDynamic
//
//  Created by Michaël Fortin on 11/19/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//
//  For a list of possible type encodings in Objective-C, see:
//  https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100
//

#import <objc/message.h>
#import <MAObjCRuntime/MARTNSObject.h>
#import <MAObjCRuntime/RTMethod.h>
#import <MAObjCRuntime/RTProperty.h>
#import "MFDynamicBase.h"
#import "MFHumanReadableConverter.h"

@implementation MFDynamicBase

static NSRegularExpression *_typeEncodingClassExtractionRegex;

#pragma mark Lifetime

+ (void)initialize
{
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

+ (IMP)getterImplementationForProperty:(RTProperty *)property
{
	NSString *key = [self keyForProperty:property];
	
	if ([self isProperty:property ofType:@encode(char)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] charValue]; });
	
	if ([self isProperty:property ofType:@encode(int)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] intValue]; });
	
	if ([self isProperty:property ofType:@encode(short)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] shortValue]; });
	
	if ([self isProperty:property ofType:@encode(long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] longValue]; });
	
	if ([self isProperty:property ofType:@encode(long long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] longLongValue]; });
	
	if ([self isProperty:property ofType:@encode(unsigned char)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] unsignedCharValue]; });
	
	if ([self isProperty:property ofType:@encode(unsigned int)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] unsignedIntValue]; });
	
	if ([self isProperty:property ofType:@encode(unsigned short)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] unsignedShortValue]; });
	
	if ([self isProperty:property ofType:@encode(unsigned long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] unsignedLongValue]; });
	
	if ([self isProperty:property ofType:@encode(unsigned long long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] unsignedLongLongValue]; });
	
	if ([self isProperty:property ofType:@encode(float)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] floatValue]; });
	
	if ([self isProperty:property ofType:@encode(double)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] doubleValue]; });
	
	if ([self isProperty:property ofType:@encode(BOOL)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf) { return [[iSelf rawObjectForKey:key] boolValue]; });
	
	if ([self isObject:property])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf)
	{
		BOOL handled;
		id object = [iSelf getAndProcessRawObjectForKey:key property:property handled:&handled];
		
		if (!handled) @throw [self unsupportedTypeExceptionForProperty:property];
		return object;
	});
	
	@throw [self unsupportedTypeExceptionForProperty:property];
}

- (id)getAndProcessRawObjectForKey:(NSString *)key property:(RTProperty *)property handled:(BOOL *)handled
{
	if (handled) *handled = YES;
	
	if ([[self class] isKindOfPropertyArchivableAsIs:property] || [[self class] isProperty:property ofType:@encode(id)])
	{
		return [self rawObjectForKey:key];
	}
	else if ([[self class] isProperty:property ofKind:[NSURL class]] ||
			 [[self class] isProperty:property ofKind:[NSUUID class]] ||
#if TARGET_OS_IPHONE
			 [[self class] isProperty:property ofKind:[UIColor class]]
#else
			 [[self class] isProperty:property ofKind:[NSColor class]]
#endif
			 )
	{
		Class targetType = [[self class] classOfProperty:property];
		return [MFHumanReadableConverter convertFromHumanReadable:[self rawObjectForKey:key] withTargetType:targetType];
	}
	else if ([[self class] propertyObjectTypeImplementsNSCoding:property])
	{
		NSData *data = [self rawObjectForKey:key];
		if (![data isKindOfClass:[NSData class]]) return (id)nil;
		return [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	
	if (handled) *handled = NO;
	return [self rawObjectForKey:key];
}

+ (IMP)setterImplementationForProperty:(RTProperty *)property
{
	NSString *key = [self keyForProperty:property];
	NSString *name = [property name];
	
	if ([self isProperty:property ofType:@encode(char)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, char value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(int)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, int value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(short)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, short value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, long value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(long long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, long long value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(unsigned char)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, unsigned char value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(unsigned int)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, unsigned int value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(unsigned short)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, unsigned short value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(unsigned long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, unsigned long value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(unsigned long long)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, unsigned long long value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(float)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, float value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(double)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, double value){ return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isProperty:property ofType:@encode(BOOL)])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, BOOL value) { return [iSelf setRawObject:@(value) forKey:key propertyName:name]; });
	
	if ([self isObject:property])
		return imp_implementationWithBlock(^(MFDynamicBase *iSelf, id value)
	{
		BOOL handled;
		[iSelf processAndSetRawObject:value forKey:key property:property handled:&handled];
		
		if (!handled) @throw [[self class] unsupportedTypeExceptionForProperty:property];
	});
	
	@throw [self unsupportedTypeExceptionForProperty:property];
}

- (void)processAndSetRawObject:(id)object forKey:(NSString *)key property:(RTProperty *)property handled:(BOOL *)handled
{
	if (handled) *handled = YES;
	
	NSString *propertyName = [property name];
	
	if ([[self class] isKindOfPropertyArchivableAsIs:property] || [[self class] isProperty:property ofType:@encode(id)])
	{
		[self setRawObject:object forKey:key propertyName:propertyName];
		return;
	}
	else if ([[self class] isProperty:property ofKind:[NSURL class]] ||
			 [[self class] isProperty:property ofKind:[NSUUID class]] ||
#if TARGET_OS_IPHONE
			 [[self class] isProperty:property ofKind:[UIColor class]]
#else
			 [[self class] isProperty:property ofKind:[NSColor class]]
#endif
			 )
	{
		[self setRawObject:[MFHumanReadableConverter convertToHumanReadable:object] forKey:key propertyName:propertyName];
		return;
	}
	else if ([[self class] propertyObjectTypeImplementsNSCoding:property])
	{
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
		[self setRawObject:data forKey:key propertyName:propertyName];
		return;
	}
	
	if (handled) *handled = NO;
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
	NSError *error;
	
	if (!_typeEncodingClassExtractionRegex)
		_typeEncodingClassExtractionRegex = [NSRegularExpression regularExpressionWithPattern:@"@\"([A-Za-z]*)\"" options:0 error:&error];
	
	NSString *typeEncoding = [property typeEncoding];
	NSArray *results = [_typeEncodingClassExtractionRegex matchesInString:typeEncoding options:0 range:NSMakeRange(0, [typeEncoding length])];
	
	NSTextCheckingResult *result = [results firstObject];
	if (!result) return nil;
	
	NSRange classNameRange = [result rangeAtIndex:1];
	NSString *className = [typeEncoding substringWithRange:classNameRange];
	
	return NSClassFromString(className);
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
	NSString *reason = [NSString stringWithFormat:@"Unsupported type encoding '%@' for dynamic property key '%@'. See https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100 for possible type encoding and add support to MFDynamicBase if required.", [property typeEncoding], [self keyForProperty:property]];
	return [NSException exceptionWithName:@"MFDynamic Exception" reason:reason userInfo:nil];
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
	// Load values using the setRawObject:forKey: template method
	// (we know nothing of the backing store at that abstraction level)
	for (NSString *key in [values allKeys])
		[self setRawObject:values[key] forKey:key propertyName:nil];
	
	if (emitWarnings) [self checkForMissingValuesAndEmitWarnings];
}

#pragma mark Implementation

- (void)checkForMissingValuesAndEmitWarnings
{
	for (RTProperty *property in [[self class] rt_properties])
	{
		NSString *key = [[self class] keyForProperty:property];
		NSString *propertyName = [property name];
		
		BOOL valueMissing = ([self rawObjectForKey:key] == nil);
		BOOL shouldEmitWarningForProperty = [self shouldEmitMissingValueWarningForProperty:propertyName];
		
		if (valueMissing && shouldEmitWarningForProperty)
			NSLog(@"Warning: Missing value for key %@ to fill property \"%@\"", key, propertyName);
	}
}

#pragma mark Key-Value Coding

- (id)valueForKey:(NSString *)propertyName
{
	RTProperty *property = [[self class] rt_propertyForName:propertyName];
	NSString *key = [[self class] keyForProperty:property];
	return [self getAndProcessRawObjectForKey:key property:property handled:NULL];
}

- (void)setValue:(id)value forKey:(NSString *)propertyName
{
	RTProperty *property = [[self class] rt_propertyForName:propertyName];
	NSString *key = [[self class] keyForProperty:property];
	
	BOOL handled;
	[self processAndSetRawObject:value forKey:key property:property handled:&handled];
	
	if (!handled) [self setRawObject:value forKey:key propertyName:[property name]];
}

#pragma mark Template Methods

- (id)rawObjectForKey:(NSString *)key
{
	@throw [NSException exceptionWithName:@"MFDynamic Exception" reason:@"No backing store; this is an abstract class" userInfo:nil];
}

- (void)setRawObject:(id)object forKey:(NSString *)key propertyName:(NSString *)propertyName
{
	@throw [NSException exceptionWithName:@"MFDynamic Exception" reason:@"No backing store; this is an abstract class" userInfo:nil];
}

- (BOOL)shouldEmitMissingValueWarningForProperty:(NSString *)propertyName
{
	return NO;
}

@end