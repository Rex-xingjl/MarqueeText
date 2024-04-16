# MarqueeText

A SwiftUI Marquee or "scrolling text" effect found in Apple native apps. For when one line isn't enough, but two is just too much 😉

![MarqueeText Demo](readme/demo.gif)

## Usage
Add this repository as a Swift Package Dependency to your project. You find the option in Xcode unter "File > Swift Packages > Add Package Dependency...". Paste the link to this project in and voila!

```swift
import SwiftUI
import MarqueeText

struct ContentView: View {    
    var body: some View {
        PPMarqueeText(text: "66666", font: .systemFont(ofSize: 13))
            .foregroundColor(Color(PPRC.Text.primary))
            .lineLimit(1)
            .frame(maxWidth: .infinity, idealHeight: 20, alignment: .leading)
   }
}
```

## License

You can use this software under the terms and conditions of the MIT License.

Rex © 2024
