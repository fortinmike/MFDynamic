//
//  MFDynamicDefaults.h
//  MFDynamic
//
//  Created by Michaël Fortin on 2013-08-22.
//  Copyright (c) 2013 Michaël Fortin. All rights reserved.
//
//  Description: This is an abstract class meant to be subclassed and used instead of NSUserDefaults to
//               store and retrieve values from the user defaults system. It provides access to user defaults
//               through strongly typed, dynamically-implemented properties (as defined in your MFDynamicDefaults
//               subclass) as opposed to key-based access and type-specific methods for each value type
//               (such as -[NSUserDefaults boolForKey:]).
//
//               MFDynamicDefaults makes setting and retrieving values from the user defaults system type-safe,
//               removes the need to remember or check in the plist file which exact type of value you're dealing with
//               to find the appropriate type-specific accessor, removes the need to create constants for each
//               user defaults key and expose those constants to your classes and/or hard-code strings where
//               user defaults are accessed, makes accessing user defaults syntactically lighter and prevents you from
//               forgetting to add default values to your registered defaults plist by emitting warnings for
//               missing default values.
//
//  Usage:
//               1- Subclass MFDynamicDefaults
//
//               2- Declare one property per user default:
//                  @property NSString *userName;
//                  @property int appLaunchCount;
//                  ...
//
//               3- Define properties as @dynamic in your subclass' implementation.
//                  Your class should only contain @dynamic properties. Any non-dynamic property will cause an exception to be raised.
//
//               4- Obtain the shared instance of your subclass and use its properties:
//
//                  [[MYDefaults sharedDefaults] setLaunchAtStartup:newValue];
//                  BOOL launchAtStartup = [[MYDefaults sharedDefaults] launchAtStartup];
//
//                      instead of
//
//                  [[NSUserDefaults standardUserDefaults] setBool:newValue forKey:@"LaunchAtStartup"];
//                  BOOL launchAtStartup = [[NSUserDefaults standardUserDefaults] boolForKey:@"LaunchAtStartup"];
//
//  Property Name / User Default Key Mapping:
//
//                 [Property Name]                    [User Defaults Key]         [Note]
//
//                 launchAtStartup          ->        LaunchAtStartup             First letter was automatically capitalized (recommended)
//                 MYSuperPropertyName      ->        MYSuperPropertyName         The name stays as-is because the first letter was already capitalized
//                 MySuperPropertyName      ->        MySuperPropertyName         Same as above
//
//  Notes:
//               - Almost all Objective-C value types are supported. An exception is thrown when a property is of an unsupported type.
//
//               - You can declare any property whose type is supported by NSUserDefaults.
//
//               - You can declare any property whose type is not supported by NSUserDefaults but that implements NSCoding (such as
//                 UIImage, UIColor, or any of your own NSCoding-implementing classes) and it will be transparently converted to and
//                 from NSData for storage in NSUserDefaults.
//
//               - By default, MFDynamicDefaults emits a warning when one of its dynamic properties doesn't have a default value
//                 in the registered defaults dictionary. This helps to make sure a default value is always provided when relevant.
//                 Warnings can be disabled per-property by implementing the -shouldEmitWarningForProperty: template method or can
//                 be disabled completely by calling -registerDefaults:emitMissingDefaultValueWarnings: with NO.
//
//               - Only the "readonly" attribute is currently considered when generating accessor implementations.
//                 Any other attributes are ignored.
//

#import <Foundation/Foundation.h>
#import "MFDynamicBase.h"

@interface MFDynamicDefaults : MFDynamicBase
{
	@public
	NSUserDefaults *_userDefaults;
}

#pragma mark Lifetime

+ (instancetype)sharedDefaults;

#pragma mark Other Public Methods

- (void)registerDefaults:(NSDictionary *)defaults; // Registers defaults just like NSUserDefaults, emits warnings for missing default values
- (void)registerDefaults:(NSDictionary *)defaults emitMissingDefaultValueWarnings:(BOOL)emitWarnings;
- (void)synchronize;

@end