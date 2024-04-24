//
//  FavoriteViewModel.swift
//  Drinks
//
//  Created by M Usman on 24/04/2024.
//

import Foundation
import Combine
import UIKit

class FavoriteViewModel {
    @Published var drinks = [FavoriteModel]()
    @Published var isLoading = false
//    var favoriteStatusUpdate = PassthroughSubject<Bool,Never>()
    
    func getFavorite(){
        drinks = DBManager.shared.getAllFavorites()
    }
    
    func removeFromFavorite(index:Int){
        let id = self.drinks[index].id
        if DBManager.shared.checkIsFavoriteExist(byID: id) {
            DBManager.shared.deleteRecipe(byID: id)
            FileHandler.shared.deleteImage(withName: id)
            drinks.remove(at: index)
        }
    }
        
}
