import SwiftUI
import CasePaths

public protocol ComposableView {
    associatedtype Value
    associatedtype Body: View

    var value: Value { get }
    
    func unwrap<V: View>(_ unwrap: @escaping (Value) -> V?) -> SwitcherWithView<Value, _ConditionalContent<Body?, V?>>
}

extension ComposableView {
    public func fallback<V: View>(
        body: @escaping (Value) -> V
    ) -> SwitcherWithView<Value, _ConditionalContent<Body?, V?>> {
        unwrap { (value: Value) -> V? in body(value) }
    }

    public func when<V: View>(
        _ predicate: @escaping (Value) -> Bool,
        body: @escaping (Value) -> V
    ) -> SwitcherWithView<Value, _ConditionalContent<Body?, V?>> {
        unwrap { (value: Value) -> V? in
            if predicate(value) {
                return body(value)
            } else {
                return nil
            }
        }
    }
    
    public func match<V: View, InnerValue>(
        _ enumCase: @escaping (InnerValue) -> Value,
        body: @escaping (InnerValue) -> V
    ) -> SwitcherWithView<Value, _ConditionalContent<Body?, V?>> {
        let casePath = CasePath<Value, InnerValue>.case(enumCase)
        return unwrap { (value: Value) -> V? in
            if let value = casePath.extract(from: value) {
                return body(value)
            } else {
                return nil
            }
        }
    }
}

public extension ComposableView where Value: Equatable {
    func just<V: View>(
        _ constant: Value,
        body: @escaping (Value) -> V
    ) -> SwitcherWithView<Value, _ConditionalContent<Body?, V?>> {
        return unwrap { (value: Value) -> V? in
            if value == constant {
                return body(value)
            } else {
                return nil
            }
        }
    }
}

public struct Switcher<Value>: ComposableView {
    public typealias Body = EmptyView
    
    public let value: Value
    private let empty: EmptyView? = nil
    
    public init(_ value: Value) {
        self.value = value
    }
    
    public func unwrap<V: View>(
        _ _unwrap: @escaping (Value) -> V?
    ) -> SwitcherWithView<Value, _ConditionalContent<EmptyView?, V?>> {
        SwitcherWithView(switcher: self, view: merge(empty, _unwrap))
    }

    @ViewBuilder
    internal func merge<V1: View, V2: View>(
        _ first: V1?,
        _ second: @escaping (Value) -> V2?
    ) -> _ConditionalContent<V1?, V2?> {
        if first != nil {
            first
        } else {
            second(value)
        }
    }
}

public struct SwitcherWithView<Value, Body: View>: View, ComposableView {
    internal let switcher: Switcher<Value>
    public let view: Body?
    public var value: Value { switcher.value }
    
    public func unwrap<NewView: View>(
        _ _unwrap: @escaping (Value) -> NewView?
    ) -> SwitcherWithView<Value, _ConditionalContent<Body??, NewView?>> {
        let cond: _ConditionalContent<Body??, NewView?> = switcher.merge(view, _unwrap)
        return SwitcherWithView<Value, _ConditionalContent<Body??, NewView?>>(switcher: switcher, view: cond)
    }
    
    public var body: Body? { view }
}
