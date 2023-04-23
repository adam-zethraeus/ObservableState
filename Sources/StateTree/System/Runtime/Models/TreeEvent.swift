import Behavior

// MARK: - TreeEvent

public enum TreeEvent: TreeState, CustomStringConvertible {

  case recording(event: RecordingEvent)
  case tree(event: TreeLifecycleEvent)
  case node(event: NodeEvent)
  case behavior(event: BehaviorEvent)

  // MARK: Public

  public var maybeRecording: RecordingEvent? {
    if case .recording(event: let event) = self {
      return event
    }
    return nil
  }

  public var maybeTree: TreeLifecycleEvent? {
    if case .tree(event: let event) = self {
      return event
    }
    return nil
  }

  public var maybeNode: NodeEvent? {
    if case .node(event: let event) = self {
      return event
    }
    return nil
  }

  public var maybeBehavior: BehaviorEvent? {
    if case .behavior(event: let event) = self {
      return event
    }
    return nil
  }

  public var description: String {
    switch self {
    case .recording(let event):
      return event.description
    case .tree(let event):
      return event.description
    case .node(let event):
      return event.description
    case .behavior(let event):
      return event.description
    }
  }
}
