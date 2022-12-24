import Behavior
import Disposable
import Model
import SourceLocation
import Tree
import XCTest

@MainActor
final class DidUpdateTests: XCTestCase {

  let stage = DisposalStage()

  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
    stage.reset()
  }

  func test_didUpdateCalledOnce_onStart() async throws {
    var count = 0
    var leaf: TreeSegment?
    let didUpdate: (TreeSegment) -> Void = { value in
      count += 1
      XCTAssertEqual(value, leaf)
    }

    leaf =
      try TreeSegment
      ._startedAsRoot(
        config: .init(
          hooks: Hooks(),
          startMode: .interactive,
          dependencies: .defaults
        ),
        stage: stage
      ) {
        .init(
          store: .init(
            rootState: .init(
              segment: .leaf(.init())
            )
          ),
          didUpdate: didUpdate
        )
      }

    await Task.flush()
    XCTAssertEqual(count, 1)
  }
}

private struct Hooks: StateTreeHooks {
  func didWriteChange(at: SourcePath) {}
  func wouldRun<B: BehaviorType>(behavior: B, from: SourceLocation) -> BehaviorInterception<
    B.Output
  > { .passthrough }
  func didRun<B: BehaviorType>(behavior: B, from: SourceLocation) {}
}
