//
//  MFDynamicDefaultsSpec.m
//  MFDynamic
//
//  Created by Michaël Fortin on 2013-08-22.
//  Copyright (c) 2013 Michaël Fortin. All rights reserved.
//

#import <Kiwi.h>
#import "MFDynamicDefaults.h"
#import "MFTestDefaults.h"
#import "MFTestUserDefaults.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#if TARGET_OS_IPHONE
UIImage *testImage()
{
	UIGraphicsBeginImageContext(CGSizeMake(64,64));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextFillRect(context, CGRectMake(0, 0, 64, 64));
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}
#endif

SPEC_BEGIN(MFDynamicDefaultsSpec)

describe(@"MFDynamicDefaults", ^
{
	__block MFTestDefaults *testDefaults;
	
	beforeEach(^
	{
		testDefaults = [[MFTestDefaults alloc] init];
		
		// We're going to use an empty user defaults instance for each test
		testDefaults->_userDefaults = (NSUserDefaults *)[[MFTestUserDefaults alloc] init];
	});
	
	context(@"when using accessors", ^
	{
		it(@"should have its dynamically-generated setter called", ^
		{
			[[[testDefaults->_userDefaults should] receive] setRawObject:any() forKey:any()];
			[testDefaults setBoolValue:YES];
		});
		
		it(@"should have its dynamically-generated getter called", ^
		{
			[[[testDefaults->_userDefaults should] receive] rawObjectForKey:any()];
			[testDefaults boolValue];
		});
		
		it(@"should store and retrieve NSUserDefaults-supported instances properly", ^
		{
			// NSUserDefaults supports NSData, NSString, NSNumber, NSDate, NSArray and NSDictionary
			// https://developer.apple.com/library/ios/DOCUMENTATION/Cocoa/Reference/Foundation/Classes/NSUserDefaults_Class/Reference/Reference.html
			
			NSData *data = [@"Data" dataUsingEncoding:NSUTF8StringEncoding];
			[testDefaults setDataValue:data];
			[[[testDefaults dataValue] should] equal:data];
			
			NSString *string = @"String";
			[testDefaults setStringValue:string];
			[[[testDefaults stringValue] should] equal:string];
			
			NSNumber *number = @(1023.3551);
			[testDefaults setNumberValue:number];
			[[[testDefaults numberValue] should] equal:number];
			
			NSDate *date = [NSDate date];
			[testDefaults setDateValue:date];
			[[[testDefaults dateValue] should] equal:date];
			
			NSArray *array = @[@"A", @"B", @"C"];
			[testDefaults setArrayValue:array];
			[[[testDefaults arrayValue] should] equal:array];
			
			NSDictionary *dictionary = @{@"A" : @"B", @"C" : @"D"};
			[testDefaults setDictionaryValue:dictionary];
			[[[testDefaults dictionaryValue] should] equal:dictionary];
		});
		
		it(@"should store and retrieve NSUserDefaults-supported objects if property is of type id", ^
		{
			NSDate *date = [NSDate date];
			[testDefaults setObjectValue:date];
			[[[testDefaults objectValue] should] equal:date];
			
			NSString *string = @"String";
			[testDefaults setObjectValue:string];
			[[[testDefaults objectValue] should] equal:string];
		});
		
		it(@"should store and retrieve instances that conform to NSCoding", ^
		{
			NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
			[testDefaults setUrlValue:url];
			[[[testDefaults urlValue] should] equal:url];
			
#if TARGET_OS_IPHONE
			UIImage *image = testImage();
			[testDefaults setUiImageValue:image];
			
			NSData *retrievedImageData = UIImagePNGRepresentation([testDefaults uiImageValue]);
			NSData *expectedImageData = UIImagePNGRepresentation(image);
			
			[[retrievedImageData should] equal:expectedImageData];
#endif
		});
		
		it(@"should return value types' default values when nothing exists in user defaults for the accessed value-type property", ^
		{
			[[theValue([testDefaults boolValue]) should] beNo];
			[[theValue([testDefaults charValue]) should] equal:theValue(0)];
			[[theValue([testDefaults intValue]) should] equal:theValue(0)];
			[[theValue([testDefaults shortValue]) should] equal:theValue(0)];
			[[theValue([testDefaults longValue]) should] equal:theValue(0)];
			[[theValue([testDefaults longLongValue]) should] equal:theValue(0)];
			[[theValue([testDefaults unsignedCharValue]) should] equal:theValue(0)];
			[[theValue([testDefaults unsignedIntValue]) should] equal:theValue(0)];
			[[theValue([testDefaults unsignedShortValue]) should] equal:theValue(0)];
			[[theValue([testDefaults unsignedLongValue]) should] equal:theValue(0)];
			[[theValue([testDefaults unsignedLongLongValue]) should] equal:theValue(0)];
			[[theValue([testDefaults floatValue]) should] equal:0 withDelta:FLT_EPSILON];
			[[theValue([testDefaults doubleValue]) should] equal:0 withDelta:DBL_EPSILON];
		});
		
		it(@"should return nil when nothing exists in user defaults for the accessed object property", ^
		{
			[[[testDefaults dataValue] should] beNil];
			[[[testDefaults stringValue] should] beNil];
			[[[testDefaults numberValue] should] beNil];
			[[[testDefaults dateValue] should] beNil];
			[[[testDefaults arrayValue] should] beNil];
			[[[testDefaults dictionaryValue] should] beNil];
			
#if TARGET_OS_IPHONE
			[[[testDefaults uiImageValue] should] beNil];
			[[[testDefaults uiColorValue] should] beNil];
#endif
			
			[[[testDefaults objectValue] should] beNil];
		});
	});
	
	context(@"when using defaults registration", ^
	{
		it(@"should register user defaults properly", ^
		{
			NSDate *date = [NSDate date];
			NSArray *array = @[@"A", @"B"];
			[testDefaults registerDefaults:@{@"BoolValue" : @(YES), @"DateValue" : date, @"ArrayValue" : array}];
			[[theValue([testDefaults boolValue]) should] beYes];
			[[theValue([[testDefaults dateValue] compare:date] == NSOrderedSame) should] beYes];
			[[[testDefaults arrayValue] should] equal:array];
		});
	});
});

SPEC_END