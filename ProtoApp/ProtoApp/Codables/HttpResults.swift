
/// This codable struct is used to retrieve an Array of User objects from the backend
struct HttpResults: Codable {
    let users: [User]
}
