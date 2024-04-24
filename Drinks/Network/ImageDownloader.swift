//
//  ImageDownloader.swift
//  Drinks
//
//  Created by M Usman on 23/04/2024.
//

import Foundation

import UIKit
import Combine

class ImageDownloader {
    static let shared = ImageDownloader()
    private let cache = NSCache<NSString, UIImage>()
    
    func getImagee(fromURLString urlString: String) -> AnyPublisher<UIImage?, NetworkError> {
        
        return Future { promise in
            if let cachedImage = self.cache.object(forKey: urlString as NSString) {
                promise(.success(cachedImage))
                return
            }
            // Download the image
            guard let url = URL(string: urlString) else {
                promise(.failure(.invalidURL))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .sink(receiveValue: { image in
                    if let image = image {
                        // Cache the downloaded image
                        self.cache.setObject(image, forKey: urlString as NSString)
                    }
                    promise(.success(image))
                })
                .store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
        
        
        
        
    }
    
    
    
    func getImage(fromURLString urlString: String) -> AnyPublisher<UIImage?, Never> {
        let subject = PassthroughSubject<UIImage?, Never>()
        
        // Check if the image is already cached
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            subject.send(cachedImage)
//            subject.send(completion: .finished)
//            return subject.eraseToAnyPublisher()
        }
        
        // Download the image
        guard let url = URL(string: urlString) else {
            subject.send(nil)
//            subject.send(completion: .finished)
            return subject.eraseToAnyPublisher()
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .sink(receiveValue: { image in
                if let image = image {
                    // Cache the downloaded image
                    self.cache.setObject(image, forKey: urlString as NSString)
                }
                subject.send(image)
//                subject.send(completion: .finished)
            })
            .store(in: &subscriptions)
        
        return subject.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
}
