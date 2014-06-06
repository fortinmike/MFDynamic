//
//  MFDynamicStorage.m
//  MFDynamic
//
//  Created by Michaël Fortin on 11/29/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import "MFDynamicStorage.h"

@implementation MFDynamicStorage
{
	NSMutableDictionary *_values;
}

#pragma mark Lifetime

- (id)init
{
	self = [super init];
	if (self)
	{
		_values = [NSMutableDictionary dictionary];
	}
	return self;
}

#pragma mark Persistence

+ (instancetype)loadFromFile:(NSString *)file
{
	return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}

- (BOOL)saveToFile:(NSString *)file
{
	return [NSKeyedArchiver archiveRootObject:self toFile:file];
}

#pragma mark Template Methods Implementation

- (id)rawObjectForKey:(NSString *)key
{
	return [_values objectForKey:key];
}

- (void)setRawObject:(id)object forKey:(NSString *)key propertyName:(NSString *)propertyName
{
	object ? [_values setObject:object forKey:key] : [_values removeObjectForKey:key];
}

#pragma mark NSCoding Protocol Implementation

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:_values forKey:@"Root"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	MFDynamicStorage *instance = [[[self class] alloc] init];
	instance->_values = [decoder decodeObjectForKey:@"Root"];
	return instance;
}

@end