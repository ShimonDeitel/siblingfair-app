import Foundation

struct Entry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var childName: String
    var note: String
    var date: Date = Date()
}
