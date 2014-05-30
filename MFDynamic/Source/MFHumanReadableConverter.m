//
//  MFHumanReadableConverter.m
//  MFDynamic
//
//  Created by Michaël Fortin on 2014-04-11.
//  Copyright (c) 2014 irradiated.net. All rights reserved.
//

#import "MFHumanReadableConverter.h"

@implementation MFHumanReadableConverter

+ (id<NSCoding>)convertToHumanReadable:(id)object
{
	if (!object) return nil;
	
	if ([object isKindOfClass:[NSURL class]])
		return [self stringRepresentationWithURL:object];
	
#if TARGET_OS_IPHONE
	if ([object isKindOfClass:[UIColor class]])
		return [self stringRepresentationWithUIColor:object];
#else
	if ([object isKindOfClass:[NSColor class]])
		return [self stringRepresentationWithNSColor:object];
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
#else
	if (targetType == [NSColor class])
		return [self NSColorWithStringRepresentation:object];
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

#pragma mark UIColor and NSColor Conversion

#if TARGET_OS_IPHONE

+ (NSString *)stringRepresentationWithUIColor:(UIColor *)color
{
	CGFloat red, green, blue, alpha;
	[color getRed:&red green:&green blue:&blue alpha:&alpha];
	
	return [self HEXColorStringWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)UIColorWithStringRepresentation:(NSString *)stringRepresentation
{
	CGFloat red, green, blue, alpha;
	[self red:&red green:&green blue:&blue alpha:&alpha fromHEXColorString:stringRepresentation];
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#else

+ (NSString *)stringRepresentationWithNSColor:(NSColor *)color
{
	CGFloat red, green, blue, alpha;
	[color getRed:&red green:&green blue:&blue alpha:&alpha];
	
	return [self HEXColorStringWithRed:red green:green blue:blue alpha:alpha];
}

+ (NSColor *)NSColorWithStringRepresentation:(NSString *)stringRepresentation
{
	CGFloat red, green, blue, alpha;
	[self red:&red green:&green blue:&blue alpha:&alpha fromHEXColorString:stringRepresentation];
	
	return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

#endif

#pragma mark Private Helpers

+ (NSString *)HEXColorStringWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
	int r = roundf(red * 255);
	int g = roundf(green * 255);
	int b = roundf(blue * 255);
	int a = roundf(alpha * 255);
	
	if (fabs(alpha - 1.0) < FLT_EPSILON)
	{
		// The alpha component is 1.0
		return [[NSString stringWithFormat:@"%02x%02x%02x", r, g, b] uppercaseString];
	}
	
	return [[NSString stringWithFormat:@"%02x%02x%02x%02x", r, g, b, a] uppercaseString];
}

+ (void)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha fromHEXColorString:(NSString *)hexColorString
{
	if ([hexColorString length] <= 6)
	{
		// Without alpha
		*red = [self colorComponentFromHex:hexColorString range:NSMakeRange(0, 2)];
		*green = [self colorComponentFromHex:hexColorString range:NSMakeRange(2, 2)];
		*blue = [self colorComponentFromHex:hexColorString range:NSMakeRange(4, 2)];
		*alpha = 1.0;
	}
	else if ([hexColorString length] == 8)
	{
		// With alpha
		*red = [self colorComponentFromHex:hexColorString range:NSMakeRange(0, 2)];
		*green = [self colorComponentFromHex:hexColorString range:NSMakeRange(2, 2)];
		*blue = [self colorComponentFromHex:hexColorString range:NSMakeRange(4, 2)];
		*alpha = [self colorComponentFromHex:hexColorString range:NSMakeRange(6, 2)];
	}
}

+ (CGFloat)colorComponentFromHex:(NSString *)hexString range:(NSRange)range
{
	NSString *substring = [hexString substringWithRange:range];
	
	unsigned int integer;
	[[NSScanner scannerWithString:substring] scanHexInt:&integer];
	
	return integer / 255.0f;
}

@end