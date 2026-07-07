import XCTest
@testable import SiblingFairnessTracker

@MainActor
final class SiblingFairnessTrackerTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    func testAddItem() {
        let item = Entry(childName: "Test", note: "Note")
        store.add(item)
        XCTAssertEqual(store.items.count, 1)
    }

    func testAddInsertsAtFront() {
        store.add(Entry(childName: "First", note: ""))
        store.add(Entry(childName: "Second", note: ""))
        XCTAssertEqual(store.items.first?.childName, "Second")
    }

    func testDeleteItem() {
        let item = Entry(childName: "ToDelete", note: "")
        store.add(item)
        store.delete(item)
        XCTAssertTrue(store.items.isEmpty)
    }

    func testDeleteAtOffsets() {
        store.add(Entry(childName: "A", note: ""))
        store.add(Entry(childName: "B", note: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }

    func testFreeLimitAllowsAdding() {
        for i in 0..<Store.freeLimit {
            store.add(Entry(childName: "Item \(i)", note: ""))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.add(Entry(childName: "One", note: ""))
        XCTAssertTrue(store.canAddMore)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(Entry(childName: "Item \(i)", note: ""))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateItem() {
        var item = Entry(childName: "Original", note: "")
        store.add(item)
        item.childName = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.childName, "Updated")
    }
}
