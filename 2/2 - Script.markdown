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
We also should be dealing with 
It's going to be asynchronous.

```swift
processGetIcon{throw AlternateError.noAlternateToday}
```

Write processGetIcon last. Mention that we'll write it then.


Now that that's all set up, let's allow one more error.
```swift
  enum AlternateError: Error {
    case noAlternateToday
  }
```

## Demo
### *`Hat.swift`*

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