import Foundation

final class ImageCacher {
    
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    
    static func save(_ images: [ImageModel]) {
        DispatchQueue.global(qos: .utility).async {
            do {
                let data = try encoder.encode(images)
                UserDefaults.standard.set(data, forKey: Constants.key)
            } catch {
                print("\(Constants.cacheError) \(error)")
            }
        }
    }
    
    static func load(offset: Int = 0, limit: Int = Constants.loadLimit, completion: @escaping ([ImageModel]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = UserDefaults.standard.data(forKey: Constants.key) else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            
            do {
                let allImages = try decoder.decode([ImageModel].self, from: data)
                let slice = Array(allImages.dropFirst(offset).prefix(limit))
                DispatchQueue.main.async {
                    completion(slice)
                }
            } catch {
                print("\(Constants.readError) \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    static func totalCount() -> Int {
        guard let data = UserDefaults.standard.data(forKey: Constants.key) else { return 0 }
        return (try? JSONDecoder().decode([ImageModel].self, from: data).count) ?? 0
    }
    
    private enum Constants {
        static let key = "cachedImages"
        static let readError = "Ошибка чтения кэша:"
        static let cacheError = "Ошибка кэширования:"
        
        static let loadLimit = 30
    }
}
