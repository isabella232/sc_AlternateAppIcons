## Introduction
**Catie**  
Hey everybody! Catie and ***[point at Jessy]*** Jessy here with a screencast on a new feature and API in iOS: alternate app icons!

**Jessy**  
Uncharacteristically with Apple, we don't have to wait for our users to adopt a *major* release in order to try it out: it's avaialble starting in iOS 10.3. Everything we'll be going over today assumes your app's deployment target is set specifically to that version; this API is unfortunately not working properly in the iOS 11 beta yet.

**Catie**  
thanks to [three]
based on Flappy Felipe
where to get it


## Demo
what the only change is: Hat


First screencast: use alternate() but 
Second:


AppIcon.swift
Hat.swift

has to be an array or it doesn't work
investigate?
Array must contain


What does UIApplication.shared.supportsAlternateIcons
actually do

assume that you have your target set to 10.3, otherwise, you'll have to do (whatever #available is called)


experiment because this is brand and we don't actually know what all Apple will allow yet! Easter egg in a game, might get through! App, who knows?!



What does that mean?
It's only literally Easter for one of these

***AppIcon.swift***
Write processGetIcon last. Mention that we'll write it then.




touchesBegan: no point in retaining self
processes the get accessor for the icon
touchesBegan isn't allowed to throw an error, so we'll use try with a question mark and just return if there's an error.

```swift
guard let icon = try? getIcon()
else {return}
```
`getIcon`: the get accessor, not the icon itself.

Catie
In a real app, you might want to alert the user that their easter egg is broken.

Jessy
Left unchecked, talk about a code smell!


happens on background thread (queue? get wording right.)


****PlayerEntity.swift***

PlayerEntity only needs one change.

```swift
let sombrero = Hat()
```

Demo both errors getting triggered. The first on a day that has no alternates. The second when you spell something wrong.





What are we actually doing?? Why is there a ❤️ and why doesn't it show up in-game? Doesn't make any sense to just change the icon. only a teaser. Let's get into a practical sample application of alternate icons in another screencast! 

Stay tuned!