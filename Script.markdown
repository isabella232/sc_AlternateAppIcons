What does UIApplication.shared.supportsAlternateIcons
actually do

assume that you have your target set to 10.3, otherwise, you'll have to do (whatever #available is called)


experiment because this is brand and we don't actually know what all Apple will allow yet! Easter egg in a game, might get through! App, who knows?!

touchesBegan: no point in retaining self
processes the get accessor for the icon
touchesBegan isn't allowed to throw an error, so we'll use try with a question mark and just return if there's an error.
no rethrow 

happens on background thread (queue? get wording right.)


has to be an array or it doesn't work
investigate?
Array must contain