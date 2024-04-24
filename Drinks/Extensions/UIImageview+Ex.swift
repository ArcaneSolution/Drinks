//
//  UIImageview+Ex.swift
//  Drinks
//
//  Created by M Usman on 23/04/2024.
//

import UIKit
import Combine

fileprivate var cancellables = Set<AnyCancellable>()

extension UIImageView {
    func setImage(fromURLString urlString: String, placeholder: UIImage = UIImage.placeHolderImg){
//        self.image = placeholder
        ImageDownloader.shared.getImage(fromURLString: urlString)
            .receive(on: DispatchQueue.main)
            .sink { image in
                if let image = image {
                    // Use the downloaded image
                    self.image = image
                }
            }
            .store(in: &cancellables)
    }
}
