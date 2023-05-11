import Foundation
import OrderedCollections
import StateTree

// MARK: - ToDo
public struct SelectedToDo: Node, Identifiable {

  // MARK: Public

  @Route(TagSelector.self) public var tagSelector

  public var id: UUID {
    record.id
  }

  public var title: String {
    get { record.title }
    set { record.title = newValue }
  }

  public var isCompleted: Bool {
    get { record.completed }
    set { record.completed = newValue }
  }

  public var dueDate: Date? {
    get { record.dueDate }
    set { record.dueDate = newValue }
  }

  public var note: String {
    get { record.note }
    set { record.note = newValue }
  }

  public var tags: Set<TagRecord> {
    Set(record.tags.compactMap { allTags[$0] })
  }

  public var rules: some Rules {
    $tagSelector
      .route(to: TagSelector(allTags: $allTags, todo: $record))
  }

  // MARK: Internal

  @Projection var record: ToDoRecord
  @Projection var allTags: OrderedDictionary<UUID, TagRecord>

  // MARK: Private

  @Scope private var scope

}
