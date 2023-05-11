import TreeActor

// MARK: - TreeValueAccess

@TreeActor
protocol TreeValueAccess {
  var treeValue: TreeValue? { get nonmutating set }
}

// MARK: - TreeValue

@TreeActor
struct TreeValue {
  let runtime: Runtime
  let id: FieldID
  var scope: AnyScope? {
    try? runtime.getScope(for: id.nodeID)
  }

  func getValue<T: Codable & Hashable>(as t: T.Type) -> T? {
    runtime.getValue(field: id, as: t)
  }

  func setValue(to newValue: some Codable & Hashable) {
    runtime.setValue(field: id, to: newValue)
  }
}

// MARK: - ValueField

protocol ValueField<WrappedValue> {
  associatedtype WrappedValue: Codable & Hashable
  var access: any TreeValueAccess { get }
  var anyInitial: any Codable & Hashable { get }
  var initial: WrappedValue { get }
}

// MARK: - Value

@propertyWrapper
public struct Value<WrappedValue: Codable & Hashable>: ValueField, Accessor {

  // MARK: Lifecycle

  public init(wrappedValue: WrappedValue) {
    self.initial = wrappedValue
    self.inner = .init(initialValue: wrappedValue)
  }

  // MARK: Public

  public typealias WrappedValue = WrappedValue

  @TreeActor public var wrappedValue: WrappedValue {
    get {
      let value = inner
        .treeValue?
        .getValue(as: WrappedValue.self) ?? inner.cache
      return value
    }
    nonmutating set {
      inner.cache = newValue
      inner
        .treeValue?
        .setValue(to: newValue)
    }
  }

  public var projectedValue: Projection<WrappedValue> {
    .init(
      self,
      initial: initial
    )
  }

  public var value: WrappedValue {
    get {
      wrappedValue
    }
    nonmutating set {
      wrappedValue = newValue
    }
  }

  public var source: ProjectionSource {
    if let id = inner.treeValue?.id {
      return .valueField(id)
    } else {
      return .programmatic
    }
  }

  public func isValid() -> Bool {
    inner.treeValue != nil
  }

  // MARK: Internal

  @TreeActor final class InnerValue: TreeValueAccess {

    // MARK: Lifecycle

    init(initialValue: WrappedValue) {
      self.cache = initialValue
    }

    // MARK: Internal

    var treeValue: TreeValue?
    var cache: WrappedValue
  }

  let inner: InnerValue

  let initial: WrappedValue

  var access: any TreeValueAccess { inner }
  var anyInitial: any Codable & Hashable {
    initial
  }

}
