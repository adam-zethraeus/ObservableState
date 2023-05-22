import Foundation
import OrderedCollections
import TreeActor

// MARK: - RouteConnection

public struct RouteConnection {
  let runtime: Runtime
  let fieldID: FieldID
}

// MARK: - RouterWriteContext

public struct RouterWriteContext {
  let depth: Int
  let dependencies: DependencyValues
}

// MARK: - RouterType

public protocol RouterType<Value> {
  associatedtype Value
  static var type: RouteType { get }
  var fallback: Value { get }
  var fallbackRecord: RouteRecord { get }
  @TreeActor var current: Value { get throws }
  @TreeActor
  func connectDefault() throws -> RouteRecord
  @TreeActor
  func apply(
    connection: RouteConnection,
    writeContext: RouterWriteContext
  ) throws
  @TreeActor
  func update(from: Self)
}

// MARK: - OneRouterType

protocol OneRouterType<Value>: RouterType {
  init(
    builder: @escaping () -> Value
  )
}

// MARK: - NRouterType

protocol NRouterType<Element>: RouterType where Value == [Element] {
  associatedtype Element
  init(
    buildKeys: OrderedSet<LSID>,
    builder: @escaping (LSID) throws -> Element
  )
}
