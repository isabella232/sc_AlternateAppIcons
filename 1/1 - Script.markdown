## Introduction
**Catie**  
Hey everybody! ***[point at self]*** Catie and ***[point at Jessy]*** Jessy here with a screencast on a new feature and API in iOS: alternate app icons!

**Jessy**  
Uncharacteristically with development for Apple platforms, we don't have to wait for our users to adopt a *major* release in order to try it out: it's available starting in iOS 10.3. Everything we'll be going over today assumes your app's deployment target is set specifically to that version. This API is unfortunately not working properly in the iOS 11 beta yet.

**Catie**  
thanks to [three]
based on Flappy Felipe
where to get it

## Demo
[do primary, valentine, and christmas to show at least two alternates.]

won't need Newsstand Icon dictionary for this app, delete that
because we have everything necessary in the main assets catalog, we don't need to bother with the the Primary Icon data either.
> delete that

**Jessy**  
Where's that set up?

**Catie**  
In an asset catalog.
Very unfortunately, you can't use asset catalogs for icons.

## Interlude
"Let's work with it in code."

## Demo
**Catie**  
Modeling AppIcon as an enumeration will work out fine for encapsulating what we want to explore with the alternate icons API. I'll start with two cases to represent the primary and valentine icons.
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
To start off with, I'll just switch between two icons. If the current icon is the primary one, I'll choose the Valentine icon. And vice versa.

```swift
 let icon =
      current == primary
      ? valentine
      : primary    
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
Now we just need some way to trigger the alternate function.

## Demo

### *`PlayerEntity.swift`*
**Jessy**  
Prior to the work you've seen in this screencast, the only notable change to the originalFlappy Felipé project that we'd made was to create an `SKSpriteNode` subclass, called `Hat`…
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

## Interlude
**Jessy**  
That's fun! But mostly, because it's new! You may be wondering, aside from the obvious fact that we're giving you an API demo "_Why_ are we changing the app icon? Why is there a valentine's day-theme hat and why doesn't it show up in-game?"

**Catie**  
Those questions are more than valid. Join us next time, and we'll go over some _practical_ sample code of how to use alternate app icons, including how to handle related errors. 

**Jessy**  
Stay tuned!