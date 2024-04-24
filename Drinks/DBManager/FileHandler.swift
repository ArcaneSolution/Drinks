//
//  FileHanlder.swift
//  Drinks
//
//  Created by M Usman on 24/04/2024.
//
import Foundation
import UIKit

class FileHandler {
    static let shared = FileHandler()
    let documentsDirectoryURL: URL
    
    private init() {
        // Get the documents directory
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Documents directory not found")
        }
        self.documentsDirectoryURL = documentsDirectory
    }
    
    func save(image: UIImage, withName imageName: String) {
        guard let data = image.pngData() else {
            return
        }
        
        let fileURL = documentsDirectoryURL.appendingPathComponent("\(imageName).png")
        
        do {
            try data.write(to: fileURL)
            return
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return
        }
    }
    
    func getImage(withName imageName: String) -> UIImage? {
        let fileURL = documentsDirectoryURL.appendingPathComponent("\(imageName).png")
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            if let image = UIImage(data: imageData) {
                return image
            } else {
                print("Error: Unable to create image from data")
                return nil
            }
        } catch {
            print("Error retrieving image: \(error.localizedDescription)")
            return nil
        }
    }
    func deleteImage(withName imageName: String) {
            let fileURL = documentsDirectoryURL.appendingPathComponent("\(imageName).png")
            
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Error deleting image: \(error.localizedDescription)")
            }
        }
}
