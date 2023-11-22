# SwiftUI: Mastering Custom Transitions - Symmetric and Asymmetric
Learn how to create and customise symmetric, asymmetric, and custom transitions to improve your app's user experience.

![Cover Image](https://cdn-images-1.medium.com/max/1600/1*AUYdEMCI0LNriLQLUDCWuA.png)

SwiftUI is getting close to becoming a replacement for UIKit, and it's not just because of the new UI component updates. It's because of the simplicity and SwiftUI's declarative syntax. Developers can create complex transitions with just a few lines of code in SwiftUI, as opposed to writing numerous lines of code in UIKit. In this article, we are going to deep dive into how to create transitions and make custom, reusable transitions in SwiftUI.

## Basic Concepts of Transitions in SwiftUI

Transitions in SwiftUI is a powerful tool to create stunning and flawless user interfaces. They are basically introduce or remove views within an app's interface. It's allowing how a view enters or exits the screen, and that makes our app's user experience more visually appealing.
Let's create an example text transition which is moves the text from leading edge to center of the screen with a smooth animation. 
Firstly create an example view to apply our transition.

```
struct TransitionBasics: View {
    // MARK: Properties
    @State var isTextActive: Bool = false
    // MARK: Body
    var body: some View {
        VStack {
            Spacer()
            // Transition Text
            if isTextActive {
                Text("Taylor Swift 🧣")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            Spacer()
            // On/Off Button
            Button("Show") {
                withAnimation(.easeInOut) {
                    isTextActive.toggle()
                }
            }
        }
    }
}
```

In the `TransitionBasics` struct, I've designed a SwiftUI view featuring an interactive text element. This text, displaying "Taylor Swift 🧣" in a bold, large title font, is toggled on and off by a button. The button manipulates the `isTextActive` state variable, thereby controlling the visibility of the text. Also, when `isTextActive` variable changes, it will change with smooth `.easeInOut` animation.

Okay, now we want to move the text from the leading edge to the center of the screen. How can we achieve this? Of course, with transitions! But it looks too complicated, right? What if I told you it's just a line of code? This demonstrates how powerful SwiftUI is.

Just add `.transition(.move(edge: .leading))` modifier to the `Text` object.

```
struct TransitionBasics: View {
    // MARK: Properties
    @State var isTextActive: Bool = false
    // MARK: Body
    var body: some View {
        VStack {
            Spacer()
            // Transition Text
            if isTextActive {
                Text("Taylor Swift 🧣")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .transition(.move(edge: .leading)) //Added 
            }
            Spacer()
            // On/Off Button
            Button("Show") {
                withAnimation(.easeInOut) {
                    isTextActive.toggle()
                }
            }
        }
    }
}
```

Now, let's try it and see if it works.

![TransitionBasics Example](https://cdn-images-1.medium.com/max/1600/1*PyR_AtKLKIy7pd-9m0QR5Q.gif)

## Differences of Symmetric & Asymmetric Transitions
In SwiftUI, we often deal with two main types of transitions: symmetric and asymmetric.

### Symmetric Transitions:
- **Uniformity:** These transitions are identical in how they appear and disappear. For example, if a view fades in, it will also fade out in the same manner.
- **Use Case:** Ideal for scenarios where you need a consistent and predictable animation, like a button that appears and disappears with the same effect.

### Asymmetric Transitions:
- **Variability:** In contrast, asymmetric transitions use different animations for entering and exiting. A view might slide in from one side but fade out when it leaves.
- **Use Case:** Best for creating more dynamic and engaging interfaces where each transition adds a unique touch to the user experience.

Actually, we already created a symmetric transition example in the previous section. It's a great example of symmetric transitions because the text moves from the leading edge and disappears from the leading edge of the screen when the user taps the 'Show' button. But what if we want to create a transition that moves the text from the leading edge and then moves it off from the trailing edge of the screen?

That's where Asymmetric transitions come into play. Asymmetric transitions offer the flexibility to have different animations for entering and exiting views. In this case, we can have our text slide in from the leading edge, but when it's time to disappear, it can slide off to the trailing edge.

Let's create an asymmetric transition. Guess what we don't need to do? That's right, write complex code. In SwiftUI, creating an asymmetric transition is very easy. We just need to change a few things. 

Just change the `.transition(.move(edge: .leading))` line with `.transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))`.

```
struct AsymmetricTransition: View {
    // MARK: Properties
    @State var isTextActive: Bool = false
    // MARK: Body
    var body: some View {
        VStack {
            Spacer()
            // Transition Text
            if isTextActive {
                Text("Taylor Swift 🧣")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))) // Changed
            }
            Spacer()
            // On/Off Button
            Button("Show") {
                withAnimation(.easeInOut) {
                    isTextActive.toggle()
                }
            }
        }
    }
}
```

Let’s look closer at the `.asymmetric()` function in SwiftUI: the `insertion` parameter defines the animation for when a view appears, and the `removal` parameter sets the animation for when the view disappears.

Now, let’s try it and see how it works.

![AsymmetricTransition Example](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*cmClrX9IERE0gvxCw3d_Yw.gif)

Okay, we’ve created a symmetric transition, learned the differences between symmetric and asymmetric transitions, and created an asymmetric transition example. Now, how can we create a custom transition and use it in both symmetric and asymmetric transitions?

## Creating Custom Transitions
So far, we’ve learned the built-in transitions SwiftUI offers, but what truly sets SwiftUI apart is its capability to create custom transitions. This flexibility allows us to create unique transitions based on our app’s needs. Let’s dive into how we can build a custom transition using SwiftUI.

Our goal here is to create a custom transition that involves rotating a view. To do this, we’ll first define a `ViewModifier` and then extend `AnyTransition` to use this modifier.

```
// MARK: Custom Rotate View Modifier
struct RotateViewModifier: ViewModifier {
    let degree: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: degree))
            .offset(
                x: degree != 0 ? UIScreen.main.bounds.width : 0,
                y: degree != 0 ? UIScreen.main.bounds.height : 0)
    }
}
```

Here, `RotateViewModifier` takes a `degree` parameter and applies a rotation effect to the content. The `offset` is used to move the view off-screen based on its rotation degree.
Now, let’s add an extension to `AnyTransition` to include our custom rotation.

```
// MARK: Extensions
extension AnyTransition {
    static var rotating: AnyTransition {
        modifier(active: RotateViewModifier(degree: 180), identity: RotateViewModifier(degree: 0))
    }
    
    static func rotating(degree: Double) -> AnyTransition {
        modifier(active: RotateViewModifier(degree: degree), identity: RotateViewModifier(degree: 0))
    }
    
    static var rotateAsymmetric: AnyTransition {
        asymmetric(insertion: .rotating, removal: .scale(scale: 0))
    }
}
```

Here’s what’s happening: We’ve got our `rotating` transition that spins the view 180 degrees, whether it's coming or going. But then, there's the `rotateAsymmetric` - this is where the magic happens. We're using our rotating effect when the view appears and a scaling effect when it disappears. It's like having the best of both worlds: a cool spin when it shows up and a slick scale-down when it leaves.

This is what makes SwiftUI so awesome. We’re mixing and matching transitions, creating something totally unique with just a few lines of code. It’s all about being creative and playing around with SwiftUI.

Finally, let’s apply our custom transition to a view.

```
// MARK: View
struct CustomTransition: View {
    // MARK: Properties
    @State var isTextActive: Bool = false
    // MARK: Body
    var body: some View {
        VStack {
            Spacer()
            // Transition Text
            if isTextActive {
                Text("Taylor Swift 🧣")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .transition(.rotateAsymmetric) // Changed
            }
            Spacer()
            // On/Off Button
            Button("Show") {
                withAnimation(.easeInOut) {
                    isTextActive.toggle()
                }
            }
        }
    }
}
```

Now, let’s try it and see how it works. (In this example I’ll only show the `.rotateAsymmetric` transition.)

![CustomTransition Example](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*R9BuVuzdKui2DE7nHJa4RQ.gif)

## Conclusion
Congrats 🎉, you’ve learned how to create symmetric transitions, asymmetric transitions, and custom transitions. Also, we’ve explored SwiftUI transitions in depth, so now you can understand what the differences are between symmetric and asymmetric transitions. Keep experimenting 🚀 and create magical user experiences! ✨

Here is the Medium article for this repo: https://ataberkturan.dev/swiftui-mastering-custom-transitions-symmetric-and-asymmetric-544839a3b05a
