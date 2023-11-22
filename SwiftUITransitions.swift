//
//  SwiftUITransitions.swift
//  CustomTransition
//
//  Created by Ataberk Turan on 22/11/2023.
//

import SwiftUI

//MARK: - Basic Concepts of Transitions in SwiftUI
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
                    .transition(.move(edge: .leading))
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

// MARK: - Asymmetric Transitions
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

// MARK: - Custom Transitions
// MARK: Custom Modifier
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
                    .transition(.rotateAsymmetric)
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

#Preview {
    CustomTransition()
}
