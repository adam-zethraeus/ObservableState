import Disposable

// MARK: - Node

@TreeActor
public protocol Node {
  associatedtype NodeRules: Rules
  @RuleBuilder var rules: Self.NodeRules { get }
}

extension Node {
  public nonisolated var cuid: CUID? {
    guard let identifiableNode = self as? any Identifiable
    else {
      return nil
    }
    let id = identifiableNode.id
    let hashID = AnyHashable(id)
    return CUID(hashID.description)
  }
}
