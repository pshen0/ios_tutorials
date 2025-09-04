import Foundation

final class ImageGalleryViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var query: String = ""
    
    private var currentPage = 1
    private var canLoadMore = true
    private var isLoadingFromNetwork = false
    private var isLoadingFromCache = false
    private var cacheOffset = 0
    private var networkFailureCount = 0
    
    func search(reset: Bool = false) {
        if reset {
            currentPage = 1
            cacheOffset = 0
            images = []
            canLoadMore = true
            isLoadingFromNetwork = false
            isLoadingFromCache = false
            networkFailureCount = 0
        }
        
        guard !isLoadingFromNetwork && !isLoadingFromCache else { return }
        
        if !canLoadMore && cacheOffset >= ImageCacher.totalCount() {
            cacheOffset = 0
        }
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedQuery.isEmpty && images.isEmpty {
            loadFromCache()
            return
        }
        
        if trimmedQuery.isEmpty && !canLoadMore {
            loadFromCache()
        } else {
            loadFromNetwork(query: trimmedQuery)
        }
    }
    
    private func loadFromNetwork(query: String) {
        guard canLoadMore else { return }
        isLoadingFromNetwork = true
        
        if query.isEmpty {
            NetworkService.shared.fetchRandomImages(count: Constants.cachePageSize) { [weak self] result in
                self?.handleNetworkResult(result)
            }
        } else {
            NetworkService.shared.searchImages(query: query, page: currentPage) { [weak self] result in
                self?.handleNetworkResult(result)
            }
        }
    }
    
    private func handleNetworkResult(_ result: Result<[ImageModel], Error>) {
        DispatchQueue.main.async {
            self.isLoadingFromNetwork = false
            
            switch result {
            case .success(let newImages):
                self.networkFailureCount = 0
                if newImages.isEmpty {
                    self.canLoadMore = false
                    self.loadFromCache()
                } else {
                    let uniqueImages = newImages.filter { newImage in
                        !self.images.contains(where: { $0.id == newImage.id })
                    }
                    self.images.append(contentsOf: uniqueImages)
                    ImageCacher.save(self.images)
                    self.currentPage += 1
                }
                
            case .failure(let error):
                print("\(Constants.loadError) \(error.localizedDescription)")
                self.networkFailureCount += 1
                if self.networkFailureCount >= Constants.maxNetworkFailures {
                    self.canLoadMore = false
                    self.loadFromCache()
                }
            }
        }
    }
    
    private func loadFromCache() {
        guard !isLoadingFromCache else { return }
        isLoadingFromCache = true
        
        ImageCacher.load(offset: cacheOffset, limit: Constants.cachePageSize) { [weak self] cachedImages in
            guard let self = self else { return }
            
            let imagesToAppend = cachedImages
            if imagesToAppend.isEmpty {
                self.cacheOffset = 0
                ImageCacher.load(offset: self.cacheOffset, limit: Constants.cachePageSize) { fallbackImages in
                    self.appendCacheImages(fallbackImages)
                    self.isLoadingFromCache = false
                }
            } else {
                self.appendCacheImages(imagesToAppend)
                self.isLoadingFromCache = false
            }
        }
    }
    
    private func appendCacheImages(_ newImages: [ImageModel]) {
        images.append(contentsOf: newImages)
        cacheOffset += newImages.count
    }
    
    private enum Constants {
        static let cachePageSize = 30
        static let maxNetworkFailures = 2
        
        static let loadError = "Ошибка загрузки:"
    }
}
