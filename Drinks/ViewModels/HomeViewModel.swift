//
//  HomeViewModel.swift
//  Drinks
//
//  Created by M Usman on 24/04/2024.
//

import Foundation
import Combine
import UIKit
class HomeViewModel {
    @Published var drinks = [Drinks]()
    var favoriteStatusUpdate = PassthroughSubject<Bool,Never>()
    @Published var isLoading = false
    var bindings = Set<AnyCancellable>()
    func initialRecipeFetch(){
        if UserDefaultManager.shared.getIsSearchByAlphabet() {
            fetchRecipesby(text: "a")
        }else{
            fetchRecipesby(text: "margarita")
        }
    }
    func fetchRecipesby(text:String){
        isLoading = true
        let apiModel = UserDefaultManager.shared.getIsSearchByAlphabet() ? DrinkRest.getDrinksByAlphabet(firstAlphabet: text) : DrinkRest.getDrinksByName(name: text)
        apiModel.fetchData()
            .sink { completion in
                if case .failure(let err) = completion {
                    self.isLoading = false
                    print(err)
                }
            } receiveValue: { response in
                if let drinks = response?.drinks{
                    self.isLoading = false
                    self.drinks = drinks
                }
            }.store(in: &bindings)
    }
    func addToFavorite(index:Int,image:UIImage?){
        if let id = self.drinks[index].idDrink {
            if DBManager.shared.checkIsFavoriteExist(byID: id) {
                DBManager.shared.deleteRecipe(byID: id)
                FileHandler.shared.deleteImage(withName: id)
                self.favoriteStatusUpdate.send(true)
            }else{
                    DBManager.shared.saveFavorites(recipe: FavoriteModel(name: self.drinks[index].strDrink ?? "", image: id, alcoholic: self.drinks[index].strAlcoholic ?? "", category: self.drinks[index].strCategory ?? "", id: id), completion: { (success) -> Void in
                        self.favoriteStatusUpdate.send(true)
                    })
                if let img = image {
                    FileHandler.shared.save(image: img, withName: id)
                    if DBManager.shared.getAllFavorites().count == 1 {
                        //removing old notification without product and saving new Notification
                        NotificationManager.shared.removeAllNotifications()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            NotificationManager.shared.handleNotification()
                        }
                    }
                }else{
                    ImageDownloader.shared.getImage(fromURLString: self.drinks[index].strDrinkThumb ?? "")
                        .sink { image in
                            if let img = image {
                                // Use the downloaded image
                                print("image downloaded")
                                FileHandler.shared.save(image: img, withName: id)
                                if DBManager.shared.getAllFavorites().count == 1 {
                                    //removing old notification without product and saving new Notification
                                    NotificationManager.shared.removeAllNotifications()
                                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                                        NotificationManager.shared.handleNotification()
                                    }
                                }
                            } else {
                                print("image can't download")
            
                            }
                        }
                        .store(in: &bindings)
                }
            }
        }
    }
}
