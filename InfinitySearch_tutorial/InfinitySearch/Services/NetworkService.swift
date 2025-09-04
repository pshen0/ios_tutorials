import Foundation

final class NetworkService {
    static let shared = NetworkService()

    func fetchRandomImages(count: Int = 30, completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        let urlString = "https://api.unsplash.com/photos/random?count=\(count)&client_id=\(Constants.accessKey)"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    let responseText = String(data: data ?? Data(), encoding: .utf8) ?? Constants.unknownError
                    completion(.failure(NSError(domain: Constants.invalidResponse, code: 0, userInfo: [NSLocalizedDescriptionKey: responseText])))
                    return
                }

                do {
                    let images = try JSONDecoder().decode([ImageModel].self, from: data)
                    completion(.success(images))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

    func searchImages(query: String, page: Int, perPage: Int = 20, completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?page=\(page)&per_page=\(perPage)&query=\(query)&client_id=\(Constants.accessKey)"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: Constants.noData, code: 0)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded.results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    private struct SearchResponse: Decodable {
        let results: [ImageModel]
    }

    private enum Constants {
        static let accessKey = "ABZVVFGBlV7H0EbrXfmMRib_52GmLtyJ1lis1AcAV50"
        static let invalidResponse = "InvalidResponse"
        static let noData = "NoData"
        static let unknownError = "UnknownError"
    }
}
