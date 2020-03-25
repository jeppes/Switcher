# Switcher

Consider the following enum:
```swift
enum ViewState {
    case state1
    case state2(String)
    case state3(left: Int, right: Int)
}
```

If we want to represent a view which can be in one of these states, we'd probably want to write something like:
```swift
struct MyView: View {
    let state: ViewState

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

Unfortunately, SwiftUI doesn't compile this unless we wrap all of these views in `AnyView`s.

With `Switcher`, expressing this is a breeze:
```swift
struct MyView: View {
    let state: ViewState

    var body: some View {
        Switcher(value: state)
            .when(ViewState.case1) { View1() }
            .when(ViewState.case2) { string in
                View2(string)
            }
            .when(ViewState.case3) { left, right in
                View3(left, right)
            }
    }
}
```
