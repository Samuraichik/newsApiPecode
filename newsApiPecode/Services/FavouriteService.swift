//
//  FavouriteService.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 16.06.2022.
//

import UIKit
import RealmSwift

class FavouriteService {
    
    public static let shared = FavouriteService()
    
    private lazy var realm: Realm = {
        return try! Realm()
    }()
    
    public func isArticleFavorite(title: String) -> Bool {
        if let favoriteArray = UserDefaults.standard.stringArray(forKey: title) {
            if favoriteArray.contains("\(title)") {
                return true
            }else {
                return false
            }
        }
        return false
    }
    
    public func articleDidTapped(title: String, favorite: FavoriteArticle) {
        if self.isArticleFavorite(title: favorite.title) {
            try! self.realm.write {
                self.realm.add(favorite)
            }
        }else {
            try! self.realm.write {
                realm.delete(realm.objects(FavoriteArticle.self).filter("title=%@", title))
            }
        }
    }
    
    public func addArticle (title: String){
        if var favoriteArray = UserDefaults.standard.stringArray(forKey: title) {
            if !favoriteArray.contains("\(title)") {
                favoriteArray.append("\(title)")
                UserDefaults.standard.set(favoriteArray, forKey: title)
            }
        } else {
            let favoriteArray = ["\(title)"]
            UserDefaults.standard.set(favoriteArray, forKey: title)
        }
    }
    
    public func removeArticle(titles: String) {
        UserDefaults.standard.removeObject(forKey:"\(titles)")
    }
}

