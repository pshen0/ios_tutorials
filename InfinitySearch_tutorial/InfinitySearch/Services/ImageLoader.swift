import UIKit
import Combine

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private static let imageCache = NSCache<NSString, UIImage>()
    private var urlString: String?

    func loadImage(from urlString: String) {
        self.urlString = urlString

        if let cachedImage = ImageLoader.imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard
                    let data = data,
                    let uiImage = UIImage(data: data),
                    error == nil
                else { return }

                DispatchQueue.main.async {
                    ImageLoader.imageCache.setObject(uiImage, forKey: urlString as NSString)
                    if self.urlString == urlString {
                        self.image = uiImage
                    }
                }
            }.resume()
        }
    }
}
