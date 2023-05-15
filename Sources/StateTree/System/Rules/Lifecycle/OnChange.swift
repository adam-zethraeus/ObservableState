@_spi(Implementation) import Behavior
import Disposable
import Emitter
import TreeActor
import Utilities

// MARK: - OnChange

public struct OnChange<Value: Equatable, B: Behavior>: Rules where B.Input == (Value, Value),
  B.Output: Sendable
{

  // MARK: Lifecycle

  public init(
    moduleFile: String = #file,
    line: Int = #line,
    column: Int = #column,
    _ value: Value,
    _ id: BehaviorID? = nil,
    action: @TreeActor @escaping (_ oldValue: Value, _ newValue: Value) -> Void
  ) where B == Behaviors.SyncSingle<(Value, Value), Void, Never> {
    self.value = value
    let id = id ?? .meta(moduleFile: moduleFile, line: line, column: column, meta: "")
    let behavior: Behaviors.SyncSingle<(Value, Value), Void, Never> = Behaviors
      .make(id, input: (Value, Value).self) { action($0.0, $0.1) }
    self.callback = { scope, tracker, input in
      behavior.run(tracker: tracker, scope: scope, input: input)
    }
  }

  public init(
    moduleFile: String = #file,
    line: Int = #line,
    column: Int = #column,
    _ value: Value,
    _ id: BehaviorID? = nil,
    action: @TreeActor @escaping (_ oldValue: Value, _ newValue: Value) async -> Void
  ) where B == Behaviors.AsyncSingle<(Value, Value), Void, Never> {
    self.value = value
    let id = id ?? .meta(moduleFile: moduleFile, line: line, column: column, meta: "")
    let behavior: Behaviors.AsyncSingle<(Value, Value), Void, Never> = Behaviors
      .make(id, input: (Value, Value).self) { await action($0.0, $0.1) }
    self.callback = { scope, tracker, input in
      behavior.run(tracker: tracker, scope: scope, input: input)
    }
  }

  public init<Seq: AsyncSequence>(
    moduleFile: String = #file,
    line: Int = #line,
    column: Int = #column,
    _ value: Value,
    _ id: BehaviorID? = nil,
    run behaviorFunc: @escaping (_ oldValue: Value, _ newValue: Value) async -> Seq,
    onValue: @escaping @TreeActor (_ value: Seq.Element) -> Void,
    onFinish: @escaping @TreeActor () -> Void = { },
    onFailure: @escaping @TreeActor (_ error: Error) -> Void = { _ in }
  ) where B == Behaviors.Stream<(Value, Value), Seq.Element, Error> {
    self.value = value
    let id = id ?? .meta(moduleFile: moduleFile, line: line, column: column, meta: "")
    let behavior: Behaviors.Stream<(Value, Value), Seq.Element, Error> = Behaviors
      .make(id, input: (Value, Value).self) {
        await behaviorFunc($0.0, $0.1)
      }
    self.callback = { scope, tracker, value in
      behavior.run(
        tracker: tracker,
        scope: scope,
        input: value,
        handler: .init(onValue: onValue, onFinish: onFinish, onFailure: onFailure, onCancel: { })
      )
    }
  }

  // MARK: Public

  public func act(
    for _: RuleLifecycle,
    with _: RuleContext
  )
    -> LifecycleResult
  {
    .init()
  }

  public mutating func applyRule(with _: RuleContext) throws { }

  public mutating func removeRule(with _: RuleContext) throws {
    scope.dispose()
  }

  public mutating func updateRule(
    from other: Self,
    with context: RuleContext
  ) throws {
    if other.value != value {
      let lastValue = value
      value = other.value
      scope.reset()
      callback(scope, context.runtime.behaviorTracker, (lastValue, value))
    }
  }

  // MARK: Private

  private var value: Value
  private let callback: (any BehaviorScoping, BehaviorTracker, (Value, Value)) -> Void
  private let scope: BehaviorStage = .init()
}

extension OnChange {

  public init(
    _ value: Value,
    _ id: BehaviorID? = nil,
    runBehavior behavior: B
  ) {
    var behavior = behavior
    self.value = value
    if let id = id {
      behavior.setID(to: id)
    }
    self.callback = { scope, tracker, value in
      behavior.run(tracker: tracker, scope: scope, input: value)
    }
  }

  public init(
    _ value: Value,
    _ id: BehaviorID? = nil,
    runBehavior behavior: B,
    handler: B.Handler
  )
    where B: Behavior
  {
    self.value = value
    var behavior = behavior
    if let id = id {
      behavior.setID(to: id)
    }
    self.callback = { scope, tracker, value in
      behavior.run(tracker: tracker, scope: scope, input: value, handler: handler)
    }
  }
}
