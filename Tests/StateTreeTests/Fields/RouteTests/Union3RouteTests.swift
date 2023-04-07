import Disposable
import XCTest
@_spi(Implementation) @testable import StateTree

// MARK: - Union3RouteTests

final class Union3RouteTests: XCTestCase {

  let stage = DisposableStage()

  override func setUp() { }
  override func tearDown() {
    stage.reset()
  }

  @TreeActor
  func test_Union3Route_A() async throws {
    let tree = try Tree_REMOVE.main
      .start(root: NestedUnion3RouteHost(routeTo: .a))
    tree.stage(on: stage)
    XCTAssertNotNil(tree.root)
    XCTAssertNil(tree.rootNode.hosted?.b)
    XCTAssertNil(tree.rootNode.hosted?.c)
    let routed = try XCTUnwrap(tree.rootNode.hosted?.a)
    XCTAssertEqual(
      String(describing: type(of: routed)),
      String(describing: AModel.self)
    )
  }

  @TreeActor
  func test_Union3Route_B() async throws {
    let tree = try Tree_REMOVE.main
      .start(root: NestedUnion3RouteHost(routeTo: .b))
    tree.stage(on: stage)
    XCTAssertNotNil(tree.root)
    XCTAssertNil(tree.rootNode.hosted?.a)
    XCTAssertNil(tree.rootNode.hosted?.c)
    let routed = try XCTUnwrap(tree.rootNode.hosted?.b)
    XCTAssertEqual(
      String(describing: type(of: routed)),
      String(describing: BModel.self)
    )
  }

  @TreeActor
  func test_Union3Route_C() async throws {
    let tree = try Tree_REMOVE.main
      .start(root: NestedUnion3RouteHost(routeTo: .c))
    tree.stage(on: stage)
    XCTAssertNotNil(tree.root)
    XCTAssertNil(tree.rootNode.hosted?.a)
    XCTAssertNil(tree.rootNode.hosted?.b)
    let routed = try XCTUnwrap(tree.rootNode.hosted?.c)
    XCTAssertEqual(
      String(describing: type(of: routed)),
      String(describing: CModel.self)
    )
  }

  @TreeActor
  func test_Union3Route_none() async throws {
    let tree = try Tree_REMOVE.main
      .start(root: NestedUnion3RouteHost(routeTo: nil))
    tree.stage(on: stage)
    XCTAssertNotNil(tree.root)
    XCTAssertNil(tree.rootNode.hosted?.a)
    XCTAssertNil(tree.rootNode.hosted?.b)
    XCTAssertNil(tree.rootNode.hosted?.c)
  }

  @TreeActor
  func test_Union3Route_reroute() async throws {
    let tree = try Tree_REMOVE.main
      .start(root: NestedUnion3RouteHost(routeTo: .a))
    tree.stage(on: stage)
    XCTAssertNotNil(tree.root)
    XCTAssertNil(tree.rootNode.hosted?.b)
    XCTAssertNil(tree.rootNode.hosted?.c)
    let routed = try XCTUnwrap(tree.rootNode.hosted?.a)
    XCTAssertEqual(
      String(describing: type(of: routed)),
      String(describing: AModel.self)
    )

    tree.rootNode.routeTo = .b
    XCTAssertNil(tree.rootNode.hosted?.a)
    XCTAssertNil(tree.rootNode.hosted?.c)
    let routed2 = try XCTUnwrap(tree.rootNode.hosted?.b)
    XCTAssertEqual(
      String(describing: type(of: routed2)),
      String(describing: BModel.self)
    )

    tree.rootNode.routeTo = nil
    XCTAssertNil(tree.rootNode.hosted)

    tree.rootNode.routeTo = .c
    XCTAssertNil(tree.rootNode.hosted?.a)
    XCTAssertNil(tree.rootNode.hosted?.b)
    let routed3 = try XCTUnwrap(tree.rootNode.hosted?.c)
    XCTAssertEqual(
      String(describing: type(of: routed3)),
      String(describing: CModel.self)
    )
  }

}

extension Union3RouteTests {

  enum Model: TreeState {
    case a
    case b
    case c
  }

  // MARK: - NestedRoute

  struct AModel: Node {
    var rules: some Rules { .none }
  }

  // MARK: - BModel

  struct BModel: Node {
    var rules: some Rules { .none }
  }

  // MARK: - CModel

  struct CModel: Node {
    var rules: some Rules { .none }
  }

  // MARK: - NestedUnion3RouteHost

  struct NestedUnion3RouteHost: Node {

    @Value var routeTo: Model?
    @Route(AModel.self, BModel.self, CModel.self) var hosted

    var rules: some Rules {
      if let routeTo {
        switch routeTo {
        case .a:
          $hosted
            .route { .a(AModel()) }
        case .b:
          $hosted
            .route { .b(BModel()) }
        case .c:
          $hosted
            .route { .c(CModel()) }
        }
      }
    }
  }
}
