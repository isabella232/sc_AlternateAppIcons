# Before starting, make sure…
…to delete the `AppIcon.alternate()` call (we don't want its error sticking around for most of this screencast)

…*`Hat.swift`* has this at the bottom

```swift
private extension AppIcon {
  var textureName: String {
    if let name = name {
      return name + " Hat"
    }
    else {
      return "Sombrero"
    }
  }
}
```

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

…System date is set to Thanksgiving and it's open for switching to xmas later
…Calendar notifications for December are off

## Introduction
**Jessy**  
Hello! I'm Jessy, she's Catie, and it's time for another screencast!

**Catie**  
Following from our last screencast, where we went over how to set up alternate app icons for runtime use, in iOS 10.3, we're going to explore a potential application of those alternate icons. We'll also be demonstrating a way to deal with related errors.

**Jessy**  
You've always been able to push out updates to your app, in order to theme the home screen icon for different seasons. But it's never before been possible to allow the user to decide whether to use that theming. Due to the necessity of app review, it's also never been reliably practical to allow theming to occur for a single day.

**Catie**  
Now, we can do both of those things! We'll update the raywenderlich.com classic, Flappy Felipe, to let players change the game's theme and icon, but only on Felipe's favorite holidays. 

Thanks very much to Tammy Coron, who last updated the course in which you can learn how to make this game. We'd also like to thank Mike Berg at weHeartGames.com who created all of the original artwork for the game. And, of course, thanks to the real Felipe, Felipe Laso-Marsetti.

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
…document that it's what alternate might throw
```swift
/// Alternate between the primary app icon and today's holiday icon
/// - Throws: AppIcon.AlternateError.noHolidayToday
```

> option-click the name to show that worked

… and throw it when the current app icon is the primary one, and today is not a holiday. While I'm here, I'll also account for switching previous holiday icons to whatever the icon should be, today. 

```swift
	else{
      😺switch (current, todaysHolidayIcon) {
      case (primary, nil): throw AlternateError.noHolidayToday
      😺case (_, let todaysHolidayIcon?):🏁 icon = todaysHolidayIcon
      case (_, nil): icon = primary
      }
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

Now we're ready to alternate icons! Let's continue from last, doing that by tapping on Felipe's hat.

### *`Hat.swift`*
**Jessy**  
In Hat.swift, I'll call `AppIcon.alternate` in `touchesBegan`. It's fine to ignore the synchronous error, where there's no holiday icon. The icon switching in this game is sort of a secret easter egg for players in-the-know, and they'll expect it to only work on certain days.

```swift
  override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
    try? AppIcon.alternate{
     
    }
  }
```
Again, I'll use the name `getIcon` for the closure's argument.

**Catie**  
Then, in a `do` block, I'll see if I can in fact get the icon. If so, I'll change the hat's texture to match up with the app icon! Note that I've got to dispatch to the main queue because `setAlternateIconName`'s completion handler is not guaranteed to run there.

```swift
    try? AppIcon.alternate{
      getIcon in
      
      do {
        let icon = try getIcon()
        
        DispatchQueue.main.async{
          self.texture = SKTexture(imageNamed: icon.textureName)
        }
      }
    }
```
I need a reference to self for that but there's no point in retaining it.

```swift
[unowned self]
```

If getting the icon fails, I'll just use `fatalError()`. 
```swift
      catch {fatalError()}
```
I'll show you why shortly.

**Jessy**  
I wrote the `textureName` extension property since the last screencast.
> zoom in on it

It's a way to translate the `CFBundleAlternateIcons` keys into the names of sprite textures. I'll use it to make the scene launch with a hat that matches the current app icon.

```swift
❌"Sombrero"❌
self.init(imageNamed: AppIcon.current.textureName)
```

And now, let's see what we've cooked up for Thanksgiving!

> build and run

**Catie**  
(We set the date to Thanksgiving 2017 before starting the screencast.)

**Jessy**  
Pumpkin Pie!
> command-2 (just demo) each time

Now I'll set the date to Christmas…
> do that.  
> tap hat.

And it's Santa Felipe!

**Catie**  
> tap hat and undo and show home screen

And with another tap, the app's back to normal!

Now, let's trigger my error, fatally!
### *`AppIcon.swift`*
> Change "Christmas" to the xmas emojis

Changing the name for the Christmas app icon will cause the `alternate` method to look up a key that isn't in the Alternate Icons property list dictionary, and that will trigger the propagated error, in `Hat`'s touchesBegan method.

> show that happening

## Conclusion

**Jessy**  
There's no documentation for why `setAlternateIconName` might throw an error, other than due to _programmer_ error, so fatal error might actually be a reasonable option, depending on the test coverage of your app. Coming up with a way to keep your Info.plist and Swift code in-sync, is up to you.
 
experiment because this is brand and we don't actually know what all Apple will allow yet! 