import SwiftUI

struct ImageGalleryView: View {
    @StateObject private var viewModel = ImageGalleryViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField(Constants.searchText, text: $viewModel.query, onCommit: {
                    viewModel.search(reset: true)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Constants.gridVSpacing) {
                        ForEach(Array(viewModel.images.enumerated()), id: \.0) { index, image in
                            RemoteImageView(urlString: image.urls.small)
                                .onAppear {
                                    let thresholdIndex = viewModel.images.index(
                                        viewModel.images.endIndex,
                                        offsetBy: Constants.loadOffset,
                                        limitedBy: viewModel.images.startIndex
                                    ) ?? 0
                                    
                                    if index == thresholdIndex {
                                        viewModel.search()
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle(Constants.titleText)
        }
        .onAppear {
            if viewModel.images.isEmpty {
                viewModel.search(reset: true)
            }
        }
    }
    
    private enum Constants {
        static let searchText = "Поиск..."
        static let titleText = "Галерея"
        
        static let gridVSpacing = 12.0
        static let loadOffset = -6
        
    }
}


struct RemoteImageView: View {
    @StateObject private var loader = ImageLoader()
    let urlString: String
    
    let size: CGFloat = (UIScreen.main.bounds.width - Constants.offset) / 2
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipped()
                    .cornerRadius(Constants.cornerRadius)
            } else {
                Color.gray.opacity(Constants.placeholderOpacity)
                    .frame(width: size, height: size)
                    .cornerRadius(Constants.cornerRadius)
            }
        }
        .onAppear {
            loader.loadImage(from: urlString)
        }
    }
    
    private enum Constants {
        static let offset = 36.0
        static let cornerRadius = 8.0
        static let placeholderOpacity = 0.1
    }
}


