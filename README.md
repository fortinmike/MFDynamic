# MFDynamic

[![Coverage Status](https://coveralls.io/repos/fortinmike/MFDynamic/badge.png?branch=master)](https://coveralls.io/r/fortinmike/MFDynamic?branch=master)
[![Version](http://cocoapod-badges.herokuapp.com/v/MFDynamic/badge.png)](http://cocoadocs.org/docsets/MFDynamic)
[![Platform](http://cocoapod-badges.herokuapp.com/p/MFDynamic/badge.png)](http://cocoadocs.org/docsets/MFDynamic)

MFDynamic eliminates stringly-typed User Defaults, NSCoding boilerplate and more.

## MFDynamicDefaults

`MFDynamicDefaults` wraps `NSUserDefaults` in a super-nice manner:

- Makes accessing user defaults **syntactically lighter** (see below).
- Makes setting and retrieving values from the user defaults system **type-safe** through dynamically-implemented properties.
- Removes the need to create constants for or hard-code user defaults key strings.
- **Automatically archives objects that conform to `NSCoding`** as `NSData` and back for seamless storage in user defaults, including your own `NSCoding`-compatible objects.
- **No need to manually convert** `UIColor` and `NSColor` to `NSData` and back; it's all done for you.
- Some types are transparently **converted to human-readable formats** and back for storage in User Defaults for easy editing in Plist editors (such as colors and URLs).
- Helps you **remember to provide default values** in your registered defaults by emitting warnings for missing default values when registering defaults (optional).

Work with User Defaults like this:

```
[[MYDefaults sharedDefaults] setBackgroundColor:newBackgroundColor];

UIColor *color = [[MYDefaults sharedDefaults] backgroundColor];
```

... instead of like this:


```
FOUNDATION_EXPORT static NSString *MYBackgroundColorKey;

...

NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
[[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MYBackgroundColor];

NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:MYBackgroundColor];
UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
```

### Usage

1. Subclass `MFDynamicDefaults`.
2. Define `@dynamic` properties for each user default:

	**Interface**
	
	```
	@interface MYAppDefaults : MFDynamicDefaults
	
	@property BOOL autoPlayVoiceOver;
	@property NSTimeInterval loginTimeoutInterval;
	@property NSDate *lastUpdate;
		
	@end
	```
	
	**Implementation**
	
	```
	@implementation MYAppDefaults
	
	@property autoPlayVoiceOver;
	@property loginTimeoutInterval;
	@property lastUpdate;
	
	@end
	```
	
3. Use the shared instance of your `MYAppDefaults` class to access user defaults:

	```
	[[MYDefaults sharedDefaults] setAutoPlayVoiceOver:YES];
	
	BOOL autoPlayVoiceOver = [[MYDefaults sharedDefaults] autoPlayVoiceOver];
	```

### Registering Defaults

Like `NSUserDefaults`, `MFDynamicDefaults` allows registering defaults from a dictionary:

```
NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:@"/Path/To/Plist/File"];
[[MYAppDefaults sharedDefaults] registerDefaults:defaults emitMissingDefaultValueWarnings:YES];
```

By default, `MFDynamicDefaults` emits a warning when one of its dynamic properties doesn't have a default value in the registered defaults dictionary. This can help you remember to provide default values for your user defaults. Warnings can be disabled per-property by implementing the `-shouldEmitWarningForProperty:` template method in your `MFDynamicDefaults` subclass.

## MFDynamicStorage

`MFDynamicStorage` works exactly like `MFDynamicDefault` but uses a simple dictionary as its backing store instead of `NSUserDefaults`. The main use case for `MFDynamicStorage` is a model class that must be stored to disk. Instead of using "normal" synthesized properties and implementing `NSCoding` manually (which can be very error-prone and is quite tedious), you simply subclass `MFDynamicStorage` and use `@dynamic` properties.

### Usage

1. Subclass `MFDynamicStorage`.
2. Define properties that must be archived as `@dynamic`:

	**Interface**
	
	```
	@interface MYModelClass : MFDynamicStorage
	
	@property UIColor *backgroundColor;
	@property float brightness;
	@property NSURL *someURL;
	
	@property (copy) NSString *propertyThatWontBeArchived;
	
	@end
	```
	
	**Implementation**
	
	```
	@implementation MYModelClass
	
	@dynamic backgroundColor;
	@dynamic brightness;
	@dynamic someURL;
	
	// Because "propertyThatWontBeArchived" is not defined as @dynamic,
	// it acts as a normal synthesized property and won't be saved to disk.
	
	@end
	```

3. Save and load your objects from disk with zero `NSCoding` boilerplate:

	```
	[modelClass saveToFile:@"/Users/Michael/Desktop/WhyAmISavingAModelFileToTheDesktop"];
	
	MYModelClass *modelClass = [MYModelClass loadFromFile:@"/Users/Michael/Desktop/WhyAmISavingAModelFileToTheDesktop"];
	```

## Implementation Details

- Almost all [Objective-C value types](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100) are supported. An exception is thrown when a property is of an unsupported type. Feel free to send a pull request if you find that a type you need is missing; support for additional types is exceedingly easy to implement.
- Most property qualifiers (such as `assign`, `copy`, `weak` and `strong`) are ignored (which is why you don't see them used anywhere in the samples above). The only exception to this rule is `readonly`. If a property is declared as `readonly`, MFDynamicBase won't implement a setter for that property.


#### Property Name <---> User Default Key Mapping

When MFDynamic stores objects in its backing store (be it `NSUserDefaults` like `MFDynamicDefaults` or a simple `NSDictionary` like `MFDynamicStorage`), it does so by capitalizing the first letter of the property name and using the resulting string as the key:

Property Name | User Defaults Key | Explanation
--------------|-------------------|-----
launchAtStartup | LaunchAtStartup | First letter was capitalized (recommended Objective-C style)
MYSuperPropertyName | MYSuperPropertyName | The key is the same as the property name because the first letter was already capitalized
MySuperPropertyName | MySuperPropertyName | The key is the same as the property name because the first letter was already capitalized

## Installation

MFDynamic is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "MFDynamic"

## Author

Michaël Fortin (fortinmike@irradiated.net)

## License

MFDynamic is available under the MIT license. See the LICENSE file for more info.

