## Introduction / Conclusion
experiment because this is brand and we don't actually know what all Apple will allow yet! Easter egg in a game, might get through! App, who knows?!

What does that mean?
It's only literally Easter for one of these

## Demo



### *`AppIcon.swift`*
`alternate` is going to be slightly more complex. I'll document what that will entail: alternating between the primary app icon and today's Easter egg.

```swift
/// Alternate between the primary app icon and today's Easter egg
static func alternate() {
```

```swift
static func alternate() {
	😺var todaysAlternate: AppIcon? {
      let currentDateComponents = Calendar.current.dateComponents(
        [.day, .month],
        from: .init()
      )
      switch (currentDateComponents.day!, currentDateComponents.month!) {
      case (9, 7): return pinkSombrero
      default: return nil
      }
    }
```


More cases.

```swift
  case pinkSombrero
  etc.
```

```swift
  enum AlternateError: Error {
    case noAlternateToday
  }
```

```swift
    guard let icon =
      current == primary
      ? todaysAlternate
      : primary
    else {
      throw AlternateError.noAlternateToday
      return
    }
```
It's going to be asynchronous.

```swift
processGetIcon{throw AlternateError.noAlternateToday}
```

Write processGetIcon last. Mention that we'll write it then.



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