## Introduction
**Catie**  
Hey everybody! ***[point at self]*** Catie and ***[point at Jessy]*** Jessy here with a screencast on a new feature and API in iOS: alternate app icons!

**Jessy**  
Uncharacteristically with development for Apple platforms, we don't have to wait for our users to adopt a *major* release in order to try it out: it's available starting in iOS 10.3. Everything we'll be going over today assumes your app's deployment target is set specifically to that version. This API is unfortunately not working properly in the iOS 11 beta yet.

**Catie**  
In this screencast we'll be adding alternate icons to a raywenderlich.com classic game: Flappy Felipe. Thanks very much to Tammy Coron, who last updated the course in which you can learn how to make this game. We'd also like to thank Mike Berg at weHeartGames.com who created all of the original artwork for the game. 

And finally, thanks to Felipe Laso-Marsetti, the game's namesake. 

**Jessy**  
We asked Felipe what some of his favorite holidays are so we can add special icons to celebrate them with the game. To add alternate icons, the first stop is the info plist.

## Demo
**Catie**    
Felipe loves Valentine's Day, because the ruling color is pink, his favorite, and because it's his wedding anniversary! He also likes Christmas, because he loves turkey. Let's start by adding alternate icons for these two holidays.

I'll start by adding a new entry to the Information Property List. We want the one called `Icon files (iOS 5)`. Then I'll add a new dictionary entry above Primary Icon called `CFBundleAlternateIcons`, and inside of that, a dictionary entry with the name we want to use for an alternate icon.

Finally, inside of the Christmas dictionary, I'll add an array entry called `CFBundleIconFiles`, and add a string to it.

> Add `Icon files (iOS 5)` entry to the plist in the plist view. Open the disclosure triangle.
> 
> Add `CFBundleAlternateIcons` dictionary. 
> 
> Add `Christmas` dictionary inside of it.
> 
> Add `CFBundleIconFiles` array. Add empty string inside of it.

**Jessy**  
Editing p-lists like this can quickly become a painful experience, so at this point I'll switch to the source code view.

> Right click on Info.plist and Open As -> Source Code

Now I can easily add the names of the icon files to this array. Then I just copy the entire Christmas entry and paste it right underneath to create an entry for Valentine's day!

```
<key>CFBundleAlternateIcons</key>
<dict>
	<key>Christmas</key>
	<dict>
		<key>CFBundleIconFiles</key>
		<array>
	      <string>😺ChristmasIcon-60🏁</string>
		</array>
	</dict>
	📦<key>Valentine</key>
	<dict>
		<key>CFBundleIconFiles</key>
		<array>
			<string>😺Valentine🏁Icon-60</string>
		</array>
	</dict>📦
```
It doesn't matter at all what you name your icon files; the system will choose the correct size if it's included in this array. We did decide to use Apple's naming convention, however, so that we can omit the suffix and filename extensions in the plist and let the system find any 2x or 3x versions for us instead of having to add every single filename manually. 

In this screencast, we're only including the required app icon sizes. In your apps, you should provide all of the same sizes for alternate icons that you do for your primary app icon.

That will take care of the home screen icons for iPhone. What about iPad?

**Catie**  
We'll get to that in a minute. First, I'm going to clean this up a bit. We don't need the Newsstand Icon dictionary for this app, so I'll delete that part. And we don't need to bother with the Primary Icon data either.

> delete that stuff

**Jessy**  
Where's that set up?

**Catie**  
In an asset catalog. 

> show the asset catalog entry for the App Icon

Very unfortunately, you can't use asset catalogs for alternate icons.
It's also important to note that the system will be hunting for the alternate icon files in the main resources directory of the bundle, so none of this will work if you use folders to organize the project.

Now we can add alternate icon support for iPad. Back to the p-list! You have to create a separate dictionary to specify the alternate icon files for ipads. Luckily, it is structured in exactly the same way as the one we just made! I'll copy and paste the entire `CFBundleIcons` dictionary, and then add a little "tilde ipad" after `CFBundleIcons` to denote that these are the icons to be used on ipad.

**Jessy**  
With that done, it's easy to replace the icon numbers in each array to add the correct sizes for ipad, and add an additional string to the array to handle the ipad pro size. 

```
  📦<key>CFBundleIcons😺~ipad🏁</key>
  <dict>
    <key>CFBundleAlternateIcons</key>
    <dict>
      <key>Christmas</key>
      <dict>
        <key>CFBundleIconFiles</key>
        <array>
          <string>ChristmasIcon-😺76🏁</string>
          😺<string>ChristmasIcon-83.5</string>🏁
        </array>
      </dict>
      <key>Valentine</key>
      <dict>
        <key>CFBundleIconFiles</key>
        <array>
          <string>ValentineIcon-😺76🏁</string>
          😺<string>ValentineIcon-83.5</string>🏁
        </array>
      </dict>
    </dict>
  </dict>📦
```

That's all we need to do in the p-list! Now the system will be aware that the project contains alternate icons, but we still have to build some kind of representaton of this in our code in order to set the icon to an alternate.

**Catie**  
Modeling AppIcon as an enumeration will work out fine for encapsulating what we want to explore with the alternate icons API. I'll start with three cases to represent the primary, valentine, and christmas icons.
> Create `AppIcon.swift`

### *`AppIcon.swift`*
```swift
import UIKit

enum AppIcon {
  case primary
  case valentine
  case christmas
}
```

And then I'll use an instance property to match up the cases with the names of all the `CFBundleAlternateIcons` dictionaries.

**Jessy**  
But the names of the icon files, you don't need to represent them in code at all…?

**Catie**  
No, you don't! Those names are all hidden away in the `CFBundleIconFiles` arrays that we made, and from this point, we won't need to work with them directly anymore. Also, the alternate icons API doesn't make use of a name for the primary icon, so that's the one case whose name is `nil`.

```swift
  var name: String? {
    switch self {
    case .primary: return nil
    case .valentine: return "Valentine"
    case .christmas: return "Christmas" 
    }
  }
```

With the name property set up, we're equipped to programmatically find out which app icon is currently active.

```swift
  static var current: AppIcon {
 
  }
```
**Jessy**  
The way I'll do that –because UIKit doesn't have a sense of *our* `AppIcon` enumeration, of course– is to find out which one's name is equivalent to a new get-only instance property of `UIApplication`… 
which is `alternateIconName`, and, as Catie alluded to, is `nil` when –and only when– the primary app icon is being used.

```swift
   return [
      primary,
      valentine,
      christmas
    ].first{$0.name == UIApplication.shared.alternateIconName}!
```

Finally, for this file, let's write a static method to alternate the icons.

```swift
  static func alternate() {
   }
```

**Catie**  
To start off with, I'll just switch between two icons. If the current icon is the Valentine one, I'll choose the primary icon. Otherwise, I'll choose the Valentine icon.

```swift
let icon: AppIcon
    
if current == valentine {
  icon = primary
}
else {
  icon = valentine
}    
```

Then, I can use the other half of the `AlternateIconName` API, to `set` the current icon, by name, utilizing what I put in `Info.plist`.

```swift      
	UIApplication.shared.setAlternateIconName(icon.name)
```

**Jessy**  
Looks like `setAlternateIconName` takes a second parameter.

**Catie**  
That's a topic for our next screencast!

## Interlude

**Jessy**  
We've gone over all you need to know to get started with alternate app icons.

**Catie**  
Aside from actually creating the icons, most of the work is in matching up your Swift, and AlternateIcons property list dictionary.

**Jessy**  
Now we just need some way to trigger the alternate method.

## Demo

### *`PlayerEntity.swift`*
**Jessy**  
Prior to the work you've seen in this screencast, the only notable change to the original Flappy Felipé project that we'd made was to create an `SKSpriteNode` subclass, called `Hat`…
> command hover on Hat

…to encapsulate the code …relevant to the hat.

### *`Hat.swift`*

**Catie**  
Sprite Nodes are `UIResponder`s. So I can call `AppIcon.alternate()` in the hat's `touchesBegan` override… 

```swift
override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
   😺AppIcon.alternate() 
}
```
…and then, after building and running, when I tap the hat, the app icon will alternate back and forth!

> Build an run. Demo switching the icon multiple times and showing the home screen to prove icon is changed.

## Interlude
**Jessy**  
That's sort of fun! But mostly, because it's new! You may be wondering, aside from the obvious fact that we're giving you an API demo, "_Why_ are we changing the app icon? Why is there a valentine's day-themed hat and why doesn't it show up in-game?"

**Catie**  
Those questions are more than valid. Join us next time, and we'll go over some _practical_ sample code of how to use alternate app icons, including how to handle related errors. 

**Jessy**  
Stay tuned!