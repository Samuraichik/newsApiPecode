//
//  FavoriteListViewModel.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 17.06.2022.
//


import Foundation
import RealmSwift

protocol FavoriteListViewModel {
    var shouldReload: (() -> Void)? { get set }
    var results: Results<FavoriteArticle>! { get set }
    
    func getResults()
    func addToFavorites(path: IndexPath)
}

class FavoriteListViewModelImpl: FavoriteListViewModel {
    
    var results: Results<FavoriteArticle>!
    
    let realm = try! Realm()
    
    var shouldReload: (() -> Void)?
    
    private var favorites: [FavoriteArticle]?
    
    func getResults() {
        self.results = self.realm.objects(FavoriteArticle.self)
    }
    
    func addToFavorites(path: IndexPath) {
        let favorite = FavoriteArticle()
        
        FavouriteService.shared.articleDidTapped(title: self.results[path.row].title, favorite: favorite)
        self.shouldReload?()
    }
}
