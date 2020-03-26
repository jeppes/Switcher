import SwiftUI
import CasePaths

public struct Switcher<Value, Wrapping: View>: View {
    private let value: Value
    private let matcher: (Value) -> Bool
    private let unwrap: (Value) -> Wrapping

    fileprivate init(
        value: Value,
        matcher: @escaping (Value) -> Bool,
        unwrap: @escaping (Value) -> Wrapping
    ) {
        self.value = value
        self.matcher = matcher
        self.unwrap = unwrap
    }

    public func when<NewWrapping: View>(
        _ newMatcher: @escaping (Value) -> Bool,
        unwrap newUnwrap: @escaping (Value) -> NewWrapping
    ) -> Switcher<Value, _ConditionalContent<Wrapping, NewWrapping>> {
        Switcher<Value, _ConditionalContent<Wrapping, NewWrapping>>(
            value: value,
            matcher: { (value: Value) -> Bool
                in self.matcher(value) || newMatcher(value)
            },
            unwrap: { value in
                self._unwrap(value: value, fallback: newUnwrap)
            }
        )
    }

    @ViewBuilder
    private func _unwrap<NewWrapping: View>(
        value: Value,
        fallback: @escaping (Value) -> NewWrapping
    ) -> _ConditionalContent<Wrapping, NewWrapping> {
        if matcher(value) {
            unwrap(value)
        } else {
            fallback(value)
        }
    }

    @ViewBuilder
    public var body: some View {
        if matcher(value) {
            unwrap(value)
        } else {
            EmptyView()
        }
    }
}

public extension Switcher {
    func fallback<NewWrapping: View>(
        _ unwrap: @escaping (Value) -> NewWrapping
    ) -> Switcher<Value, _ConditionalContent<Wrapping, NewWrapping>> {
        when({ _ in true }) { value in unwrap(value) }
    }
}

public extension Switcher where Wrapping == EmptyView {
    init(_ value: Value) {
        self.init(
            value: value,
            matcher: { _ in false },
            unwrap: { _ in EmptyView() }
        )
    }
}

public extension Switcher where Value: Equatable {
    func just<NewWrapping: View>(
        _ value: Value,
        unwrap: @escaping (Value) -> NewWrapping
    ) -> Switcher<Value, _ConditionalContent<Wrapping, NewWrapping>> {
        when({ $0 == value }, unwrap: unwrap)
    }
}

public extension Switcher {
    func match<NewWrapping: View, InnerValue>(
        _ enumCase: @escaping (InnerValue) -> Value,
        unwrap: @escaping (InnerValue) -> NewWrapping
    ) -> Switcher<Value, _ConditionalContent<Wrapping, NewWrapping>> {
        let casePath = CasePath<Value, InnerValue>.case(enumCase)
        return when({ casePath.extract(from: $0) != nil }) { value in
            let innerValue = casePath.extract(from: value)!
            return unwrap(innerValue)
        }
    }
}
