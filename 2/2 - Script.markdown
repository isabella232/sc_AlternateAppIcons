# Before starting, make sure…
…*`AppIcon.swift`* has these:

```swift
  case primary
  case valentine
  case christmas
  
  
	case thanksgiving
```

```swift
  var name: String? {
    switch self {
    case .primary: return nil
    case .valentine: return "Valentine"
    case .christmas: return "Christmas"
    case .thanksgiving: return "Thanksgiving"
    }
  }
```
…The Thanksgiving icons are set up in the Alternate Icons folder and Info.plist.

## Introduction
**Jessy**  
Hello! It's screencast time! I'm Jessy; she's Catie!

**Catie**  
Following from our last screencast, where we went over how to set up alternate app icons for runtime use, in iOS 10.3, we're going to explore a potential application of those alternate icons. We'll also be demonstrating a way to deal with related errors.

**Jessy**  
You've always been able to push out updates to your app, in order to theme the home screen icon for different seasons. But it's never before been possible to allow the user to decide whether to use that theming. Due to the necessity of app review, it's also never been reliably practical to allow theming to occur for a single day.

**Catie**  
Now, we can do both of those things! Let's try them out by theming an app, including its icon, for holidays. 


## Demo
### *`AppIcon.swift`*
**Catie**  
I'll start by documenting more clearly what this `alternate` method is going to do:  The alternation is between the primary app icon and today's holiday icon, if there is one.

```swift
/// Alternate between the primary app icon and today's holiday icon
static func alternate() {
```
> option-click the name to show that worked
 
Then, I'll use a nested computed property to encapsulate the logic for what todaysHolidayIcon might be.

```swift
static func alternate() {
	😺var todaysHolidayIcon: AppIcon? {   
    }
```
I'll potentially need four date components to figure out the holiday.

```swift
    var todaysHolidayIcon: AppIcon? {
      😺let currentDateComponents = Calendar.current.dateComponents(
        [ .day, .month,
          .weekOfMonth, .weekday
        ],
        from: .init()
      )
```
**Jessy**  

Thanksgiving in the US falls on the fourth Thursday in November…

```swift
      if
        currentDateComponents.month == 11,
        currentDateComponents.weekOfMonth == 4,
        currentDateComponents.weekday == 5
      {return thanksgiving}
```
The only other holidays we've got icons for right now are Valentine's Day and Christmas. If it's not one of these three days in question, `todaysHolidayIcon` is nil.

```swift
      switch (currentDateComponents.day!, currentDateComponents.month!) {
      case (14, 2): return valentine
      case (25, 12): return christmas
      default: return nil
      }
```

**Catie**  
If there's nothing to alternate to, let's throw an error. 

```swift
  static func alternate() 😺throws {
```

I'll define the error case as `AlternateError.noHolidayToday`…

```swift
  case christmas
  
  enum AlternateError: Error {
    case noHolidayToday
  }
  
  static var current: AppIcon {
```
… and throw it when the current app icon is the primary one, and today is not a holiday.

```swift
    guard let icon =
      current == primary
      ? todaysAlternate
      : primary
    else {throw AlternateError.noAlternateToday}
```
**Jessy**  
We also _should_ be dealing with the asynchronous error that `setAlternateIconName` might throw, in its "completion handler".
> option click `setAlternateIconName`

## Interlude
Another piece of information that that we need asynchronously, to theme other parts of the app, is what icon the app was switched to in the case where _no_ error occurs when using `setAlternateIconName`.

**Catie**  
Processing asynchronous errors in Swift, as you may be familiar with, isn't as straightforward as working synchronously. In this case, our method needs to process either an AppIcon, or an Error, asynchronously.

**Jessy**  
The way we think is simplest to handle that, in Swift, is to process a closure that either _returns_ an an AppIcon, or throws an Error. Let's see what that looks like.

## Demo
### *`AppIcon.swift`*

**Catie**  
_If_ we were able to guarantee that `setAlternateIconName` would succeed. we could use a completion handler-style closure whose argument is an app icon. And we could call that "processIcon", as that's what it would do.

```swift
  static func alternate(
    processIcon: @escaping (AppIcon) -> Void
  ) throws {
```

Then, we could call `processIcon`, in `setAlternateIconName`'s `completionHandler`.

```swift
    UIApplication.shared.setAlternateIconName(icon.name){
      error in
      
      processIcon(icon)
    }
```

…but that shouldn't be done when there's an error.
```swift
     if let error = error {
        return
      }
```
**Jessy**  
That would work, but just `return`-ing there, doesn't allow for the caller of the alternate function to have any idea that something went wrong. We can't directly propagate the error…

```swift
      if let error = error {
        throw error
        return
      }
```
But we could, if we were change `alternate `'s argument a bit.

Instead of processing an icon directly, we could process a closure that either returns one, or throws an error.

```swift
 ( () throws -> AppIcon )
```
If get accessors could throw, that would be what their signatures would look like. So I'll rename the parameter to "process _Get_ Icon".

**Catie**  
Then, it's easy enough to create a _closure_ that returns `icon`, by switching from parentheses to braces…

```swift
      processGetIcon{icon}
```

and using that same syntax, throwing `setAlternateIconName`'s error, when it exists, and should be propagated. 
```swift
      if let error = error {
        😺processGetIcon{throw error}
        return
      }
```

Now we're ready to alternate icons! Let's continue to do that by tapping on Felipe's hat.

### *`Hat.swift`*
**Jessy**  
In Hat.swift…


option click get icon, then icon.


Match up with.

```swift
❌"Sombrero"❌
self.init(imageNamed: AppIcon.current.textureName)
```

We know those are going to match up for everything but the primary app icon, which is what actually corresponds to `"Sombrero"`. Let's handle that logic with a private extension of `AppIcon`.

```swift
private extension AppIcon {
  var textureName: String {
    return name ?? "Sombrero"
  }
}
```

touchesBegan: no point in retaining self
processes the get accessor for the icon


`getIcon`: the get accessor, not the icon itself.


```swift
 AppIcon.alternate{
      [unowned self]
      getIcon in
      
      do {
        let icon = try getIcon()
        
           }
      catch AppIcon.AlternateError.noAlternateToday {}
      catch {fatalError()}
    }
```
happens on background thread (queue? get wording right.)

```swift
DispatchQueue.main.async{
	self.texture = SKTexture(imageNamed: icon.textureName)
}
```

Demo both errors getting triggered. The first on a day that has no alternates. The second when you spell something wrong.


Catie
In a real app, you might want to alert the user that their easter egg is broken.

Jessy
Left unchecked, talk about a code smell!

## Conclusion
experiment because this is brand and we don't actually know what all Apple will allow yet! 