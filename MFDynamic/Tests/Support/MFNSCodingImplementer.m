//
//  MFNSCodingImplementer.m
//  Obsidian
//
//  Created by Michaël Fortin on 11/30/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import "MFNSCodingImplementer.h"

@implementation MFNSCodingImplementer

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self)
	{
		_number = [aDecoder decodeIntegerForKey:@"number"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInteger:self.number forKey:@"number"];
}

@end