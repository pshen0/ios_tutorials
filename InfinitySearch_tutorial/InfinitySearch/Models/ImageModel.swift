import Foundation

struct ImageModel: Codable {
    
    let id: String
    let urls: ImageURLs
    let description: String?
    
    struct ImageURLs: Codable {
        let small: String
        let regular: String
    }
    
}
