# Switcher

The lack of `switch` statements, pattern matching, and `if let x = x` can make expressing certain things in SwiftUI a bit cumbersome. `Switcher` gives you back that power.

## `enum`s and pattern matching

Consider the following enum:
```swift
enum ViewState: Equatable {
    case state1
    case state2(String)
    case state3(left: Int, right: Int)
}
```

If we want to represent a view which can be in one of these states, we'd probably want to write something like:
```swift
struct MyView: View {
    let state: ViewState

    // 🛑 Swift Compiler Error: "Function declares an opaque return type, but the return statements
    // in its body do not have matching underlying types"
    var body: some View {
        switch state {
        case .state1:
            return View1()
        case .state2(let string):
            return View2(string)
        case .state3(let left, let right):
            return View3(left, right)
        }
    }
}
```

Unfortunately, SwiftUI doesn't compile this unless we wrap all of these views in `AnyView`s (which has it's own set of problems. With `Switcher`, expressing this is a breeze, and it works entirely without `AnyView`:

```swift
struct MyView: View {
    let state: ViewState

    var body: some View {
        Switcher(state)
            .just(ViewState.state1) { View1() }
            .match(ViewState.state2) { string in
                View2(string)
            }
            .match(ViewState.state3) { left, right in
                View3(left, right)
            }
    }
}
```
In `.match`, the associated values of the `enum` you define in the first argument become the arguments to the closure you pass as the second argument. 🎉

Note: If your `enum` has cases with no associated values, your enum will need to conform to `Equatable` in order to match on those cases.

## `if let` assignments

Unwrapping `Optional`s with `if let something = something { ... }` is common practice in Swift. Switcher brings this functionality to SwiftUI with the same syntax as before:

```swift
struct IfCaseLetDemo: View {
    // We only want to draw something if this field is not `nil`
    let optional: String?

    var body: some View {
        Switcher(optional)
            // `if let` is just the same as `match` on `Optional`'s `.some` case:
            .match(Optional.some) { unwrappedOptional in
                Text(unwrappedOptional)
            }
            // Optional fallback. You can leave this out and nothing will be drawn.
            .fallback { _ in
                Text("Fallback text here")

            }
    }
}
```

## Non-`enum`s
No enum? No problem. The following types of matchers are supported too:

```swift
let count: Int = ...
Switcher(count)
    // If your type is equatable, you can match against values directly with `.just`
    .just(2) { _ in Text("Double trouble.") }

    // All matchers send the value that was matched as an argument to their closure
    .just(3) { three in Text("\(three) == 3") }

    // Arbitrary predicates are also supported with `.when`
    .when({ $0 > 9 && $0 < 11 }) { _ in Text("Ten.") }

    // Use `.fallback` to catch all remaining cases. Note: cases are matched in order, so always put `fallback` last!
    .fallback { n in Text("\(n)") }
```

## Acknowledgements

Switcher's enum-related functionality is powered by [pointfreeco/swift-case-paths](https://github.com/pointfreeco/swift-case-paths).
