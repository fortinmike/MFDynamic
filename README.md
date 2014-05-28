# MFDynamic

[![Version](http://cocoapod-badges.herokuapp.com/v/MFDynamic/badge.png)](http://cocoadocs.org/docsets/MFDynamic)
[![Platform](http://cocoapod-badges.herokuapp.com/p/MFDynamic/badge.png)](http://cocoadocs.org/docsets/MFDynamic)

MFDynamic eliminates NSCoding boilerplate, stringly-typed user defaults and more.

## Features



## MFDynamicDefaults

`MFDynamicDefaults` wraps `NSUserDefaults` in a super-nice manner:

- Makes accessing user defaults **syntactically lighter** (see below).
- Makes setting and retrieving values from the user defaults system **type-safe** through dynamically-implemented properties.
- Removes the need to create constants for or hard-code user defaults key strings.
- **Automatically archives objects that conform to `NSCoding`** as `NSData` and back for seamless storage in user defaults, including your own `NSCoding`-compatible objects.
- **No need to manually convert** `UIColor` and `NSColor` to `NSData` and back; it's all done for you.
- Some types are transparently **converted to human-readable formats** and back for storage in User Defaults for easy editing in Plist editors.
- Helps you **remember to provide default values** in your registered defaults by emitting warnings for missing default values when registering defaults (optional).

#### With MFDynamicDefaults:

```
[[MYDefaults sharedDefaults] setBackgroundColor:newBackgroundColor];

UIColor *color = [[MYDefaults sharedDefaults] backgroundColor];
```

#### Without MFDynamicDefaults:

```
FOUNDATION_EXPORT static NSString *MYBackgroundColorKey;

...

NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
[[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MYBackgroundColor];

NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:MYBackgroundColor];
UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
```

## MFDynamicStorage

`MFDynamicStorage` works exactly like `MFDynamicDefault` but uses a simple dictionary as its backing store instead of `NSUserDefaults`. The main use case for `MFDynamicStorage` is a model class that must be stored to disk. Instead of using "normal" synthesized properties and implementing `NSCoding` manually (which can be very error-prone), you simply subclass `MFDynamicStorage` and use `@dynamic` properties.

#### How To Use

1. Subclass `MFDynamicStorage` (say, `MYModelClass : MFDynamicStoarge`).
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

## MFDynamicBase

## Installation

MFDynamic is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "MFDynamic"

## Author

Michaël Fortin (fortinmike@irradiated.net)

## License

MFDynamic is available under the MIT license. See the LICENSE file for more info.

