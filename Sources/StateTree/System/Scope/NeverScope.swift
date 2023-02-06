import Foundation
// MARK: - NeverScope

struct NeverScope: Scoped {

  // MARK: Lifecycle

  nonisolated init() {
    assertionFailure("NeverScope should never be invoked")
    self._node = NeverNode()
  }

  // MARK: Internal

  struct NeverNode: Node {
    nonisolated init() {
      assertionFailure("NeverNode should never be invoked")
    }

    var rules: some Rules {
      assertionFailure("NeverScope should never be invoked")
      return .none
    }
  }

  typealias N = NeverNode
  struct NeverScopeError: Error { }

  var id: NodeID {
    assertionFailure("NeverScope should never be invoked")
    return .invalid
  }

  var depth: Int {
    assertionFailure("NeverScope should never be invoked")
    return Int.max
  }

  var uniqueIdentity: String? {
    assertionFailure("NeverScope should never be invoked")
    return .none
  }

  var behaviorResolutions: [BehaviorResolution] {
    get async {
      assertionFailure("NeverScope should never be invoked")
      return []
    }
  }

  var node: N {
    get {
      assertionFailure("NeverScope should never be invoked")
      return _node
    }
    nonmutating set { }
  }

  var isActive: Bool {
    assertionFailure("NeverScope should never be invoked")
    return false
  }

  var childScopes: [AnyScope] {
    assertionFailure("NeverScope should never be invoked")
    return []
  }

  var initialCapture: NodeCapture {
    assertionFailure("NeverScope should never be invoked")
    return .init(_node)
  }

  var record: NodeRecord {
    get {
      assertionFailure("NeverScope should never be invoked")
      return .init(id: .invalid, origin: .invalid, records: [])
    }
    nonmutating set {
      assertionFailure("NeverScope should never be invoked")
    }
  }

  var dependencies: DependencyValues {
    assertionFailure("NeverScope should never be invoked")
    return .defaults
  }

  var valueFieldDependencies: Set<FieldID> {
    assertionFailure("NeverScope should never be invoked")
    return []
  }

  var requiresReadying: Bool {
    assertionFailure("NeverScope should never be invoked")
    return false
  }

  var isClean: Bool {
    assertionFailure("NeverScope should never be invoked")
    return false
  }

  var requiresFinishing: Bool {
    assertionFailure("NeverScope should never be invoked")
    return true
  }

  var isFinished: Bool {
    assertionFailure("NeverScope should never be invoked")
    return true
  }

  static func == (_: NeverScope, _: NeverScope) -> Bool {
    assertionFailure("NeverScope should never be invoked")
    return false
  }

  func focus() {
    assertionFailure("NeverScope should never be invoked")
  }

  func unfocus() {
    assertionFailure("NeverScope should never be invoked")
  }

  func applyIntent(_: Intent) -> StepResolutionInternal {
    assertionFailure("NeverScope should never be invoked")
    return .inapplicable
  }

  func hash(into _: inout Hasher) {
    assertionFailure("NeverScope should never be invoked")
  }

  func host<B: BehaviorType>(behavior: B, input _: B.Input) -> B.Action? {
    assertionFailure("NeverScope should never be invoked")
    behavior.dispose()
    return nil
  }

  func own(_ disposable: some Disposable) {
    assertionFailure("NeverScope should never be invoked")
    disposable.dispose()
  }

  func stepTowardsFinished() throws {
    assertionFailure("NeverScope should never be invoked")
  }

  func stop() throws {
    assertionFailure("NeverScope should never be invoked")
  }

  func markDirty(pending _: ExternalRequirement) {
    assertionFailure("NeverScope should never be invoked")
  }

  func stepTowardsReady() throws {
    assertionFailure("NeverScope should never be invoked")
    throw NeverScopeError()
  }

  func erase() -> AnyScope {
    assertionFailure("NeverScope should never be invoked")
    return AnyScope(scope: self)
  }

  // MARK: Private

  private let _node: N
  private let uuid = UUID()

}
