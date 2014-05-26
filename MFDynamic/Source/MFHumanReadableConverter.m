//
//  MFHumanReadableConverter.m
//  Obsidian
//
//  Created by Michaël Fortin on 2014-04-11.
//  Copyright (c) 2014 irradiated.net. All rights reserved.
//

#if TARGET_OS_IPHONE
	#import <UIKit/UIKit.h>
#endif
#import <Collector.h>
#import "MFHumanReadableConverter.h"
#import "NSException+Additions.h"

@implementation MFHumanReadableConverter

+ (id<NSCoding>)convertToHumanReadable:(id)object
{
	if (!object) return nil;
	
	if ([object isKindOfClass:[NSURL class]])
		return [self stringRepresentationWithURL:object];
	
#if TARGET_OS_IPHONE
	if ([object isKindOfClass:[UIColor class]])
		return [self stringRepresentationWithUIColor:object];
#endif
	
	return nil;
}

+ (id<NSCoding>)convertFromHumanReadable:(id)object withTargetType:(Class)targetType
{
	if (!object) return nil;
	
	if (targetType == [NSURL class])
		return [self URLWithStringRepresentation:object];
	
#if TARGET_OS_IPHONE
	if (targetType == [UIColor class])
		return [self UIColorWithStringRepresentation:object];
#endif
	
	return nil;
}

#pragma mark NSURL Conversion

+ (NSString *)stringRepresentationWithURL:(NSURL *)url
{
	return [url absoluteString];
}

+ (NSURL *)URLWithStringRepresentation:(NSString *)stringRepresentation
{
	if ([stringRepresentation hasPrefix:@"file://"])
		return [NSURL fileURLWithPath:stringRepresentation];
	
	return [NSURL URLWithString:stringRepresentation];
}

#pragma mark UIColor Conversion

#if TARGET_OS_IPHONE
+ (NSString *)stringRepresentationWithUIColor:(UIColor *)color
{
	CGFloat red, green, blue, alpha;
	[color getRed:&red green:&green blue:&blue alpha:&alpha];
	
	return [NSString stringWithFormat:@"color(%f, %f, %f, %f)", red, green, blue, alpha];
}

+ (UIColor *)UIColorWithStringRepresentation:(NSString *)stringRepresentation
{
	NSString *componentsString = [stringRepresentation substringFromIndex:6];
	NSArray *components = [[componentsString componentsSeparatedByString:@","] ct_map:^id(NSString *string)
	{
		return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	}];
	
	if ([components count] != 4)
		@throw [NSException exceptionWithReason:@"Couldn't parse color from string %@", stringRepresentation];
	
	CGFloat red = [components[0] floatValue];
	CGFloat green = [components[1] floatValue];
	CGFloat blue = [components[2] floatValue];
	CGFloat alpha = [components[3] floatValue];
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
#endif

@end