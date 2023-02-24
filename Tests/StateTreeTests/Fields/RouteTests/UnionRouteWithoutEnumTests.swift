@_spi(Implementation) import StateTree
import XCTest

// MARK: - UnionRouteWithoutEnumTests

@TreeActor
final class UnionRouteWithoutEnumTests: XCTestCase {

  func test_directNodeRoute_Union2() throws {
    let lifetime = try Tree.main
      .start(
        root: Union2Node()
      )
    XCTAssertNil(lifetime.rootNode.route)
    lifetime.rootNode.select = "a"
    XCTAssertNotNil(lifetime.rootNode.route?.a)
    lifetime.rootNode.select = "b"
    XCTAssertNotNil(lifetime.rootNode.route?.b)
    lifetime.rootNode.select = "bad"
    XCTAssertNil(lifetime.rootNode.route)
  }

  func test_directNodeRoute_Union3() throws {
    let lifetime = try Tree.main
      .start(
        root: Union3Node()
      )
    XCTAssertNil(lifetime.rootNode.route)
    lifetime.rootNode.select = "a"
    XCTAssertNotNil(lifetime.rootNode.route?.a)
    lifetime.rootNode.select = "b"
    XCTAssertNotNil(lifetime.rootNode.route?.b)
    lifetime.rootNode.select = "c"
    XCTAssertNotNil(lifetime.rootNode.route?.c)
    lifetime.rootNode.select = "bad"
    XCTAssertNil(lifetime.rootNode.route)
  }
}

extension UnionRouteWithoutEnumTests {

  // MARK: - UnionNode

  struct Union2Node: Node {
    @Value var select: String?
    @Route(NodeA.self, NodeB.self) var route
    var rules: some Rules {
      switch select {
      case "a":
        try $route.route(to: NodeA())
      case "b":
        try $route.route {
          NodeB()
        }
      default:
        try $route.route(to: BadNode())
      }
    }
  }

  struct Union3Node: Node {
    @Value var select: String?
    @Route(NodeA.self, NodeB.self, NodeC.self) var route
    var rules: some Rules {
      if select == "a" {
        try $route.route(to: NodeA())
      } else if select == "b" {
        try $route.route {
          NodeB()
        }
      }

      if select == "c" {
        try $route.route(to: NodeC())
      } else if select == "bad" {
        try $route.route(to: BadNode())
      }
    }
  }

  struct BadNode: Node {
    var rules: some Rules { .none }
  }

  // MARK: - NodeA

  struct NodeA: Node {
    var rules: some Rules { .none }
  }

  // MARK: - NodeB

  struct NodeB: Node {
    var rules: some Rules { .none }
  }

  // MARK: - NodeB

  struct NodeC: Node {
    var rules: some Rules { .none }
  }

  struct NodeD: Node {
    var rules: some Rules { .none }
  }
}
