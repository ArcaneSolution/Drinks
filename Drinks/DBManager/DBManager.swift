//
//  DBManager.swift
//  Drinks
//
//  Created by M Usman on 23/04/2024.
//

import Foundation
import UIKit
import CoreData



class DBManager {
    static let shared = DBManager()
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer
    init(){
        persistentContainer = NSPersistentContainer(name: "Drinks")
                persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
                    if let error = error as NSError? {
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
    }
    func saveFavorites(recipe:FavoriteModel,completion : @escaping(Bool)->()){
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context) else{return}
        let newRecord = NSManagedObject(entity: entity, insertInto: context)
        newRecord.setValue(recipe.alcoholic, forKey: "alcoholic")
        newRecord.setValue(recipe.category, forKey: "category")
        newRecord.setValue(recipe.id, forKey: "id")
        newRecord.setValue(recipe.image, forKey: "image")
        newRecord.setValue(recipe.name, forKey: "name")
        do {
          try context.save()
            completion(true)
         } catch {
          print("Error saving")
        }
    }
    func getAllFavorites()->[FavoriteModel]{
        var favorites = [FavoriteModel]()
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                if let id = data.value(forKey: "id") as? String, let name = data.value(forKey: "name") as? String, let category = data.value(forKey: "category") as? String, let img = data.value(forKey: "image") as? String, let alcoholic = data.value(forKey: "alcoholic") as? String {
                    favorites.append(FavoriteModel(name: name, image: img, alcoholic: alcoholic, category: category, id: id))
                }
            }
        } catch {
            
            print("Failed")
        }
        return favorites
    }
    func checkIsFavoriteExist(byID:String)->Bool{
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                if let id = data.value(forKey: "id") as? String , id == byID {
                    return true
                }
            }
        } catch {
            return false
        }
        return false
    }
    func deleteRecipe(byID:String){
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                if let id = data.value(forKey: "id") as? String , id == byID {
                    context.delete(data)
                    try context.save()
                }
            }
        } catch {
            
            print("Failed")
        }
    }
}
