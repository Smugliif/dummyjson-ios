
/// This codable represents the Users fetched from the backend.
struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let age: Int
    let gender: String
    let image: String
    let phone: String
}
