import Disposable
import TreeActor

// MARK: - StreamBehaviorType

public protocol StreamBehaviorType<Input, Output>: BehaviorType
  where Producer: AsyncSequence, Producer.Element == Output,
  Subscriber == Behaviors.StreamSubscriber<
    Input,
    Producer
  >
{
  func start(
    input: Input,
    handler: Handler,
    resolving: Behaviors.Resolution
  ) async
    -> AnyDisposable
}

extension StreamBehaviorType {
  public func scoped(
    to scope: some BehaviorScoping,
    manager: BehaviorManager
  ) -> ScopedBehavior<Self> {
    .init(behavior: self, scope: scope, manager: manager)
  }
}

// MARK: StreamBehaviorType.Func

extension StreamBehaviorType {
  public typealias Func = (_ input: Input) async -> Producer
}
