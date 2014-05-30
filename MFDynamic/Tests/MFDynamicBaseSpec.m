//
//  MFDynamicBaseSpec.m
//  MFDynamic
//
//  Created by Michaël Fortin on 2014-05-30.
//  Copyright 2014 Michaël Fortin. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "MFTestStorage.h"

SPEC_BEGIN(MFDynamicBaseSpec)

describe(@"MFDynamicBase", ^
{
	__block MFTestStorage *storage;
	
	beforeEach(^
	{
		storage = [[MFTestStorage alloc] init];
	});
	
	context(@"losslessness", ^
	{
		it(@"should store and retrieve BOOL (signed char) without loss", ^
		{
			[storage setBoolValue:YES];
			[[theValue([storage boolValue]) should] beYes];
		});
		   
		it(@"should store and retrieve int without loss", ^
		{
			[storage setIntValue:INT_MIN];
			[[theValue([storage intValue]) should] equal:theValue(INT_MIN)];
			[storage setIntValue:INT_MAX];
			[[theValue([storage intValue]) should] equal:theValue(INT_MAX)];
		});
		
		it(@"should store and retrieve short without loss", ^
		{
			[storage setShortValue:SHRT_MIN];
			[[theValue([storage shortValue]) should] equal:theValue(SHRT_MIN)];
			[storage setShortValue:SHRT_MAX];
			[[theValue([storage shortValue]) should] equal:theValue(SHRT_MAX)];
		});
		
		it(@"should store and retrieve long without loss", ^
		{
			[storage setLongValue:LONG_MIN];
			[[theValue([storage longValue]) should] equal:theValue(LONG_MIN)];
			[storage setLongValue:LONG_MAX];
			[[theValue([storage longValue]) should] equal:theValue(LONG_MAX)];
		});
		
		it(@"should store and retrieve long long without loss", ^
		{
			[storage setLongLongValue:LLONG_MIN];
			[[theValue([storage longLongValue]) should] equal:theValue(LLONG_MIN)];
			[storage setLongLongValue:LLONG_MAX];
			[[theValue([storage longLongValue]) should] equal:theValue(LLONG_MAX)];
		});
		
		it(@"should store and retrieve unsigned char without loss", ^
		{
			[storage setUnsignedCharValue:UCHAR_MAX];
			[[theValue([storage unsignedCharValue]) should] equal:theValue(UCHAR_MAX)];
		});
		
		it(@"should store and retrieve unsigned int without loss", ^
		{
			[storage setUnsignedIntValue:UINT_MAX];
			[[theValue([storage unsignedIntValue]) should] equal:theValue(UINT_MAX)];
		});
		
		it(@"should store and retrieve unsigned short without loss", ^
		{
			[storage setUnsignedShortValue:USHRT_MAX];
			[[theValue([storage unsignedShortValue]) should] equal:theValue(USHRT_MAX)];
		});
		
		it(@"should store and retrieve unsigned long without loss", ^
		{
			[storage setUnsignedLongValue:ULONG_MAX];
			[[theValue([storage unsignedLongValue]) should] equal:theValue(ULONG_MAX)];
		});
		
		it(@"should store and retrieve unsigned long long without loss", ^
		{
			[storage setUnsignedLongLongValue:ULLONG_MAX];
			[[theValue([storage unsignedLongLongValue]) should] equal:theValue(ULLONG_MAX)];
		});
		
		it(@"should store and retrieve float without loss", ^
		{
			[storage setFloatValue:FLT_MIN];
			[[theValue([storage floatValue]) should] equal:FLT_MIN withDelta:FLT_EPSILON];
			[storage setFloatValue:FLT_MAX];
			[[theValue([storage floatValue]) should] equal:FLT_MAX withDelta:FLT_EPSILON];
		});
		
		it(@"should store and retrieve double without loss", ^
		{
			[storage setDoubleValue:DBL_MIN];
			[[theValue([storage doubleValue]) should] equal:DBL_MIN withDelta:FLT_EPSILON];
			[storage setDoubleValue:DBL_MAX];
			[[theValue([storage doubleValue]) should] equal:DBL_MAX withDelta:FLT_EPSILON];
		});
	});
	
	context(@"special treatment", ^
	{
		it(@"should store and retrieve NSURL instances", ^
		{
			NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
			
			[storage setUrlValue:url];
			
			[[[storage urlValue] should] equal:url];
		});
		
#if TARGET_OS_IPHONE
		it(@"should store and retrieve UIColor instances", ^
		{
			UIColor *color = [UIColor redColor];
			
			[storage setUiColorValue:color];
			
			[[[storage uiColorValue] should] equal:color];
		});
#else
		it(@"should store and retrieve NSColor instances", ^
		{
			NSColor *color = [NSColor redColor];
			
			[storage setNsColorValue:color];
			
			[[[storage nsColorValue] should] equal:color];
		});
#endif
	});
	
	context(@"object compatibility", ^
	{
		it(@"should store and retrieve NSDictionary-compatible objects", ^
		{
			[storage setStringValue:@"Blah"];
			
			[[[storage stringValue] should] equal:@"Blah"];
		});
		
		it(@"should store and retrieve NSCoding-implementing objects", ^
		{
			MFNSCodingImplementer *original = [[MFNSCodingImplementer alloc] init];
			[original setNumber:42];
			[storage setNsCodingImplementer:original];
			
			[[theValue([[storage nsCodingImplementer] number]) should] equal:theValue(42)];
		});
	});
	
	context(@"when using accessors", ^
	{
		it(@"should store and retrieve supported objects if property is of type id", ^
		{
			NSString *string = @"String";
			[storage setObjectValue:string];
			[[[storage objectValue] should] equal:string];
		});
		
		it(@"should store and retrieve instances that conform to NSCoding", ^
		{
			NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
			[storage setUrlValue:url];
			[[[storage urlValue] should] equal:url];
			
			NSBundle *bundle = [NSBundle bundleForClass:[self class]];
			NSString *imagePath = [bundle pathForResource:@"test-image" ofType:@"png"];
			
#if TARGET_OS_IPHONE
			UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
			[storage setUiImageValue:image];
			
			NSData *retrievedImageData = UIImagePNGRepresentation([storage uiImageValue]);
			NSData *expectedImageData = UIImagePNGRepresentation(image);
			
			[[retrievedImageData should] equal:expectedImageData];
#else
			NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
			[storage setNsImageValue:image];
			
			NSData *retrievedImageData = [[storage nsImageValue] TIFFRepresentation];
			NSData *expectedImageData = [image TIFFRepresentation];
			
			[[retrievedImageData should] equal:expectedImageData];
#endif
		});
		
		it(@"should return value types' default values when nothing exists in user defaults for the accessed value-type property", ^
		{
			[[theValue([storage boolValue]) should] beNo];
			[[theValue([storage charValue]) should] equal:theValue(0)];
			[[theValue([storage intValue]) should] equal:theValue(0)];
			[[theValue([storage shortValue]) should] equal:theValue(0)];
			[[theValue([storage longValue]) should] equal:theValue(0)];
			[[theValue([storage longLongValue]) should] equal:theValue(0)];
			[[theValue([storage unsignedCharValue]) should] equal:theValue(0)];
			[[theValue([storage unsignedIntValue]) should] equal:theValue(0)];
			[[theValue([storage unsignedShortValue]) should] equal:theValue(0)];
			[[theValue([storage unsignedLongValue]) should] equal:theValue(0)];
			[[theValue([storage unsignedLongLongValue]) should] equal:theValue(0)];
			[[theValue([storage floatValue]) should] equal:0 withDelta:FLT_EPSILON];
			[[theValue([storage doubleValue]) should] equal:0 withDelta:DBL_EPSILON];
		});
		
		it(@"should return nil when nothing exists in user defaults for the accessed object property", ^
		{
			[[[storage dataValue] should] beNil];
			[[[storage stringValue] should] beNil];
			[[[storage numberValue] should] beNil];
			[[[storage dateValue] should] beNil];
			[[[storage arrayValue] should] beNil];
			[[[storage dictionaryValue] should] beNil];
			
#if TARGET_OS_IPHONE
			[[[storage uiImageValue] should] beNil];
			[[[storage uiColorValue] should] beNil];
#else
			[[[storage nsImageValue] should] beNil];
			[[[storage nsColorValue] should] beNil];
#endif
			
			[[[storage objectValue] should] beNil];
		});
	});
});

SPEC_END
