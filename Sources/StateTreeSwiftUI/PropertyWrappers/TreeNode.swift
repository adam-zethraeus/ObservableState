import Combine
import Disposable
@_spi(Implementation) import StateTree
import SwiftUI

// MARK: - TreeNode

@propertyWrapper
@dynamicMemberLookup
public struct TreeNode<NodeType: Node>: DynamicProperty, NodeAccess {

  // MARK: Lifecycle

  init(scope: NodeScope<NodeType>) {
    self.scope = scope
    self.observed = .init(scope: scope)
    self.nid = scope.nid
    self.cuid = scope.cuid
    observed.startIfNeeded()
  }

  public init(projectedValue: TreeNode<NodeType>) {
    self = projectedValue
    observed.startIfNeeded()
  }

  // MARK: Public

  @_spi(Implementation) public let scope: NodeScope<NodeType>

  public var wrappedValue: NodeType {
    scope.node
  }

  public var projectedValue: TreeNode<NodeType> {
    self
  }

  // MARK: Internal

  let nid: NodeID
  let cuid: CUID?

  @ObservedObject var observed: ObservableNode<NodeType>

  var runtime: Runtime {
    scope.runtime
  }

  var node: N {
    scope.node
  }

  // MARK: Private

  private var disposable: AutoDisposable?
}

// MARK: Identifiable

extension TreeNode: Identifiable where NodeType: Identifiable {
  public var id: CUID {
    cuid ?? .invalid
  }
}
