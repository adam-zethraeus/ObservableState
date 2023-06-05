import Disposable
import Emitter
import Foundation
@_spi(Implementation) import StateTreeBase
import SwiftUI
import TreeActor
import Utilities

// MARK: - ReportedTree

@TreeActor
public final class ReportedTree<N: Node> {

  // MARK: Lifecycle

  public init(tree: Tree<N>) throws {
    self.tree = tree
    self.handle = try tree.start()
  }

  // MARK: Public

  public var root: Reporter<N> {
    Reporter(scope: handle.root)
  }

  // MARK: Private

  private let tree: Tree<N>
  private let handle: TreeHandle<N>

}
